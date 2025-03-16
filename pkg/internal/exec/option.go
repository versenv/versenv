package exec

type ExecOption interface {
	apply(o *execOption)
}

var _ ExecOption = execOptionFunc(nil)

type execOptionFunc func(o *execOption)

func (f execOptionFunc) apply(o *execOption) { f(o) }

type execOption struct {
	envv []string
}

func WithExecOptionEnv(envv []string) ExecOption {
	return execOptionFunc(func(o *execOption) { o.envv = envv })
}
