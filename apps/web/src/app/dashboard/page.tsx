import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";

export const metadata = { title: "Dashboard" };

export default async function DashboardPage() {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();

  if (!user) redirect("/auth/login");

  const name = user.user_metadata?.["name"] ?? user.email?.split("@")[0] ?? "Viajante";

  return (
    <div className="min-h-screen bg-gray-50 dark:bg-brand-950">
      {/* Header */}
      <header className="bg-white dark:bg-brand-900 border-b border-gray-200 dark:border-brand-800 px-6 py-4">
        <div className="max-w-7xl mx-auto flex items-center justify-between">
          <div className="flex items-center gap-2">
            <span className="text-xl">✈</span>
            <span className="font-bold text-brand-700 dark:text-brand-400">TravelMiles AI</span>
          </div>
          <div className="flex items-center gap-4">
            <span className="text-sm text-gray-600 dark:text-gray-400">
              Olá, <strong>{name}</strong>
            </span>
            <form action="/auth/signout" method="post">
              <button className="text-sm text-gray-500 hover:text-red-600 transition-colors">
                Sair
              </button>
            </form>
          </div>
        </div>
      </header>

      {/* Main content */}
      <main className="max-w-7xl mx-auto px-6 py-8">
        <h1 className="text-2xl font-bold text-gray-900 dark:text-white mb-6">
          Seu painel de viagens
        </h1>

        {/* Stats */}
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 mb-8">
          {[
            { label: "Economia acumulada", value: "R$ 0", icon: "💰", color: "text-green-600" },
            { label: "Alertas ativos", value: "0", icon: "🔔", color: "text-blue-600" },
            { label: "Pesquisas realizadas", value: "0", icon: "🔍", color: "text-purple-600" },
            { label: "Milhas cadastradas", value: "0", icon: "💎", color: "text-yellow-600" },
          ].map((stat) => (
            <div
              key={stat.label}
              className="bg-white dark:bg-brand-900 rounded-xl border border-gray-200 dark:border-brand-800 p-5"
            >
              <div className="flex items-center justify-between">
                <span className="text-2xl">{stat.icon}</span>
                <span className={`text-2xl font-bold ${stat.color}`}>{stat.value}</span>
              </div>
              <p className="text-sm text-gray-500 dark:text-gray-400 mt-2">{stat.label}</p>
            </div>
          ))}
        </div>

        {/* Quick actions */}
        <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
          {[
            { title: "Pesquisar passagens", desc: "Encontre as melhores tarifas", icon: "✈", href: "/search", color: "bg-brand-600" },
            { title: "Criar alerta", desc: "Seja notificado quando o preço cair", icon: "🔔", href: "/alerts/new", color: "bg-purple-600" },
            { title: "Minhas milhas", desc: "Gerencie seus programas de fidelidade", icon: "💎", href: "/loyalty", color: "bg-yellow-600" },
          ].map((action) => (
            <a
              key={action.title}
              href={action.href}
              className={`${action.color} rounded-xl p-6 text-white hover:opacity-90 transition-opacity`}
            >
              <span className="text-3xl">{action.icon}</span>
              <h3 className="font-semibold mt-3">{action.title}</h3>
              <p className="text-sm opacity-80 mt-1">{action.desc}</p>
            </a>
          ))}
        </div>

        {/* Coming soon banner */}
        <div className="mt-8 bg-gradient-to-r from-brand-600 to-purple-600 rounded-2xl p-6 text-white">
          <div className="flex items-center gap-4">
            <span className="text-4xl">🤖</span>
            <div>
              <h3 className="font-bold text-lg">Assistente IA em breve</h3>
              <p className="text-white/80 text-sm mt-1">
                Nosso assistente inteligente vai recomendar destinos, prever tendências de preços e
                planejar viagens completas para você.
              </p>
            </div>
          </div>
        </div>
      </main>
    </div>
  );
}
