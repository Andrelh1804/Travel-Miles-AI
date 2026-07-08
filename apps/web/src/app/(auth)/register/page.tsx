"use client";

import { useState } from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { createClient } from "@/lib/supabase/client";

export default function RegisterPage() {
  const router = useRouter();
  const [formData, setFormData] = useState({ name: "", email: "", password: "" });
  const [error, setError] = useState<string | null>(null);
  const [success, setSuccess] = useState(false);
  const [loading, setLoading] = useState(false);

  const handleRegister = async (e: React.FormEvent) => {
    e.preventDefault();
    setError(null);
    setLoading(true);

    const supabase = createClient();
    const { error } = await supabase.auth.signUp({
      email: formData.email,
      password: formData.password,
      options: { data: { name: formData.name, role: "user" } },
    });

    if (error) {
      setError(error.message.includes("already registered")
        ? "Este e-mail já está cadastrado."
        : error.message);
      setLoading(false);
      return;
    }

    setSuccess(true);
    setLoading(false);
  };

  if (success) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-brand-950 to-brand-900 flex items-center justify-center px-4">
        <div className="w-full max-w-md bg-white dark:bg-brand-900 rounded-2xl shadow-2xl p-8 text-center animate-slide-up">
          <div className="text-5xl mb-4">✉️</div>
          <h2 className="text-2xl font-bold text-gray-900 dark:text-white">Verifique seu e-mail</h2>
          <p className="text-gray-500 dark:text-gray-400 mt-2">
            Enviamos um link de confirmação para <strong>{formData.email}</strong>.
            Clique no link para ativar sua conta.
          </p>
          <Link
            href="/auth/login"
            className="mt-6 inline-block px-6 py-2.5 bg-brand-600 text-white rounded-lg hover:bg-brand-700 transition-colors"
          >
            Ir para o login
          </Link>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-brand-950 to-brand-900 flex items-center justify-center px-4">
      <div className="w-full max-w-md bg-white dark:bg-brand-900 rounded-2xl shadow-2xl p-8 animate-slide-up">
        <div className="text-center mb-8">
          <Link href="/" className="inline-flex items-center gap-2 text-brand-600 dark:text-brand-400 mb-4">
            <span className="text-2xl">✈</span>
            <span className="font-bold text-xl">TravelMiles AI</span>
          </Link>
          <h1 className="text-2xl font-bold text-gray-900 dark:text-white">Criar conta gratuita</h1>
          <p className="text-gray-500 dark:text-gray-400 mt-1">Comece a economizar em passagens</p>
        </div>

        {error && (
          <div className="bg-red-50 dark:bg-red-900/20 text-red-600 dark:text-red-400 text-sm p-3 rounded-lg mb-4">
            {error}
          </div>
        )}

        <form onSubmit={handleRegister} className="space-y-4">
          {[
            { label: "Nome completo", key: "name", type: "text", placeholder: "João Silva" },
            { label: "E-mail", key: "email", type: "email", placeholder: "joao@email.com" },
            { label: "Senha", key: "password", type: "password", placeholder: "Mínimo 8 caracteres" },
          ].map(({ label, key, type, placeholder }) => (
            <div key={key}>
              <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">{label}</label>
              <input
                type={type}
                required
                value={formData[key as keyof typeof formData]}
                onChange={(e) => setFormData((p) => ({ ...p, [key]: e.target.value }))}
                className="w-full px-4 py-2.5 border border-gray-300 dark:border-brand-700 rounded-lg bg-white dark:bg-brand-800 text-gray-900 dark:text-white focus:outline-none focus:ring-2 focus:ring-brand-500"
                placeholder={placeholder}
              />
            </div>
          ))}

          <button
            type="submit"
            disabled={loading}
            className="w-full py-3 bg-brand-600 hover:bg-brand-700 disabled:opacity-50 text-white font-semibold rounded-lg transition-colors"
          >
            {loading ? "Criando conta..." : "Criar conta"}
          </button>
        </form>

        <p className="text-xs text-gray-400 text-center mt-4">
          Ao criar uma conta, você concorda com nossos{" "}
          <Link href="/terms" className="text-brand-500 hover:underline">Termos de Uso</Link> e{" "}
          <Link href="/privacy" className="text-brand-500 hover:underline">Política de Privacidade</Link>.
        </p>

        <p className="text-center text-sm text-gray-500 dark:text-gray-400 mt-4">
          Já tem uma conta?{" "}
          <Link href="/auth/login" className="text-brand-600 dark:text-brand-400 font-medium hover:underline">
            Entrar
          </Link>
        </p>
      </div>
    </div>
  );
}
