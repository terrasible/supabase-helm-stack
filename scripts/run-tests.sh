#!/bin/bash

# Supabase Helm Chart Test Runner
# This script runs comprehensive tests for the Supabase Helm chart

set -e

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Default values
NAMESPACE="supabase"
RELEASE_NAME="supabase"
CHART_PATH="./charts/supabase"
VALUES_FILE=""
TEST_TIMEOUT="300s"
CLEANUP_ON_FAILURE="true"
VERBOSE="false"
TEST_SUITE="all"

# Test suites
ALL_TESTS=(
    "kong-operator-test"
    "services-test"
    "network-policy-test"
    "monitoring-test"
    "security-rbac-test"
    "scaling-test"
    "integration-test-suite"
)

INDIVIDUAL_TESTS=(
    "kong-operator-test"
    "services-test"
    "network-policy-test"
    "monitoring-test"
    "security-rbac-test"
    "scaling-test"
)

QUICK_TESTS=(
    "services-test"
    "monitoring-test"
)

# Help function
show_help() {
    cat << EOF
Supabase Helm Chart Test Runner

Usage: $0 [OPTIONS]

Options:
    -n, --namespace NAMESPACE       Kubernetes namespace (default: supabase)
    -r, --release RELEASE_NAME      Helm release name (default: supabase)
    -c, --chart CHART_PATH          Path to chart directory (default: ./charts/supabase)
    -f, --values VALUES_FILE        Values file to use for testing
    -t, --timeout TIMEOUT          Test timeout (default: 300s)
    -s, --suite SUITE              Test suite to run: all|individual|quick|integration (default: all)
    --no-cleanup                   Don't cleanup on failure
    -v, --verbose                   Verbose output
    -h, --help                     Show this help

Test Suites:
    all         - Run all tests including integration suite
    individual  - Run individual component tests only
    quick       - Run quick smoke tests
    integration - Run integration test suite only

Examples:
    # Run all tests with default values
    $0

    # Run tests with custom values file
    $0 -f examples/test-configurations/production-test.yaml

    # Run only quick tests
    $0 -s quick

    # Run tests in custom namespace
    $0 -n my-supabase -r my-release

    # Run with verbose output
    $0 -v
EOF
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -n|--namespace)
            NAMESPACE="$2"
            shift 2
            ;;
        -r|--release)
            RELEASE_NAME="$2"
            shift 2
            ;;
        -c|--chart)
            CHART_PATH="$2"
            shift 2
            ;;
        -f|--values)
            VALUES_FILE="$2"
            shift 2
            ;;
        -t|--timeout)
            TEST_TIMEOUT="$2"
            shift 2
            ;;
        -s|--suite)
            TEST_SUITE="$2"
            shift 2
            ;;
        --no-cleanup)
            CLEANUP_ON_FAILURE="false"
            shift
            ;;
        -v|--verbose)
            VERBOSE="true"
            shift
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            echo "Unknown option $1"
            show_help
            exit 1
            ;;
    esac
done

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

# log_warning function removed as it was unused

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_debug() {
    if [[ "$VERBOSE" == "true" ]]; then
        echo -e "${PURPLE}[DEBUG]${NC} $1"
    fi
}

# Check prerequisites
check_prerequisites() {
    log_info "Checking prerequisites..."

    # Check if kubectl is available
    if ! command -v kubectl &> /dev/null; then
        log_error "kubectl is not installed or not in PATH"
        exit 1
    fi

    # Check if helm is available
    if ! command -v helm &> /dev/null; then
        log_error "helm is not installed or not in PATH"
        exit 1
    fi

    # Check if chart directory exists
    if [[ ! -d "$CHART_PATH" ]]; then
        log_error "Chart directory not found: $CHART_PATH"
        exit 1
    fi

    # Check if values file exists (if specified)
    if [[ -n "$VALUES_FILE" && ! -f "$VALUES_FILE" ]]; then
        log_error "Values file not found: $VALUES_FILE"
        exit 1
    fi

    # Check kubectl connectivity
    if ! kubectl cluster-info &> /dev/null; then
        log_error "Cannot connect to Kubernetes cluster"
        exit 1
    fi

    log_success "Prerequisites check passed"
}

# Create namespace if it doesn't exist
ensure_namespace() {
    log_info "Ensuring namespace '$NAMESPACE' exists..."

    if ! kubectl get namespace "$NAMESPACE" &> /dev/null; then
        log_info "Creating namespace '$NAMESPACE'..."
        kubectl create namespace "$NAMESPACE"
    else
        log_debug "Namespace '$NAMESPACE' already exists"
    fi
}

# Install or upgrade the chart
install_chart() {
    log_info "Installing/upgrading Supabase chart..."

    local helm_cmd="helm upgrade --install $RELEASE_NAME $CHART_PATH --namespace $NAMESPACE --wait --timeout $TEST_TIMEOUT"

    if [[ -n "$VALUES_FILE" ]]; then
        helm_cmd="$helm_cmd -f $VALUES_FILE"
    fi

    log_debug "Running: $helm_cmd"

    if [[ "$VERBOSE" == "true" ]]; then
        eval "$helm_cmd"
    else
        eval "$helm_cmd" > /dev/null
    fi

    log_success "Chart installed successfully"
}

# Run a specific test
run_test() {
    local test_name="$1"
    log_info "Running test: $test_name"

    local test_cmd="helm test $RELEASE_NAME --namespace $NAMESPACE --timeout $TEST_TIMEOUT --filter name=$RELEASE_NAME-$test_name"

    log_debug "Running: $test_cmd"

    if [[ "$VERBOSE" == "true" ]]; then
        if eval "$test_cmd"; then
            log_success "Test '$test_name' passed"
            return 0
        else
            log_error "Test '$test_name' failed"
            return 1
        fi
    else
        if eval "$test_cmd" > /dev/null 2>&1; then
            log_success "Test '$test_name' passed"
            return 0
        else
            log_error "Test '$test_name' failed"
            # Show logs on failure
            log_info "Showing logs for failed test '$test_name':"
            kubectl logs -n "$NAMESPACE" -l "app.kubernetes.io/name=supabase,app.kubernetes.io/instance=$RELEASE_NAME" --tail=50 || true
            return 1
        fi
    fi
}

# Run test suite
run_test_suite() {
    local suite="$1"
    local tests_to_run=()

    case "$suite" in
        "all")
            tests_to_run=("${ALL_TESTS[@]}")
            ;;
        "individual")
            tests_to_run=("${INDIVIDUAL_TESTS[@]}")
            ;;
        "quick")
            tests_to_run=("${QUICK_TESTS[@]}")
            ;;
        "integration")
            tests_to_run=("integration-test-suite")
            ;;
        *)
            log_error "Unknown test suite: $suite"
            exit 1
            ;;
    esac

    log_info "Running test suite: $suite (${#tests_to_run[@]} tests)"

    local passed=0
    local failed=0
    local failed_tests=()

    for test in "${tests_to_run[@]}"; do
        if run_test "$test"; then
            ((passed++))
        else
            ((failed++))
            failed_tests+=("$test")
        fi
    done

    log_info "Test suite '$suite' completed"
    log_info "Results: $passed passed, $failed failed"

    if [[ $failed -gt 0 ]]; then
        log_error "Failed tests: ${failed_tests[*]}"
        return 1
    else
        log_success "All tests passed!"
        return 0
    fi
}

# Cleanup function
cleanup() {
    if [[ "$CLEANUP_ON_FAILURE" == "true" ]]; then
        log_info "Cleaning up..."
        helm uninstall "$RELEASE_NAME" --namespace "$NAMESPACE" || true
        kubectl delete namespace "$NAMESPACE" || true
    else
        log_info "Skipping cleanup (--no-cleanup specified)"
    fi
}

# Get deployment status
get_deployment_status() {
    log_info "Checking deployment status..."

    echo "Pods:"
    kubectl get pods -n "$NAMESPACE" -l "app.kubernetes.io/instance=$RELEASE_NAME" || true

    echo ""
    echo "Services:"
    kubectl get services -n "$NAMESPACE" -l "app.kubernetes.io/instance=$RELEASE_NAME" || true

    echo ""
    echo "Helm Release Status:"
    helm status "$RELEASE_NAME" -n "$NAMESPACE" || true
}

# Main execution
main() {
    echo -e "${BLUE}🧪 Supabase Helm Chart Test Runner${NC}"
    echo "===================================="
    echo "Namespace: $NAMESPACE"
    echo "Release: $RELEASE_NAME"
    echo "Chart: $CHART_PATH"
    echo "Values: ${VALUES_FILE:-"default"}"
    echo "Test Suite: $TEST_SUITE"
    echo "Timeout: $TEST_TIMEOUT"
    echo ""

    # Set up error handling
    trap 'log_error "Script failed!"; cleanup; exit 1' ERR

    # Run the test pipeline
    check_prerequisites
    ensure_namespace
    install_chart

    # Wait a bit for pods to be ready
    log_info "Waiting for pods to be ready..."
    sleep 30

    get_deployment_status

    # Run tests
    if run_test_suite "$TEST_SUITE"; then
        log_success "🎉 All tests completed successfully!"
        exit 0
    else
        log_error "❌ Some tests failed!"
        get_deployment_status
        cleanup
        exit 1
    fi
}

# Run main function
main "$@"
