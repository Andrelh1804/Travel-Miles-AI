import { PaymentProvider, PaymentStatus, SubscriptionPlan, SubscriptionStatus } from "../common/enums";

export interface Subscription {
  id: string;
  userId: string;
  plan: SubscriptionPlan;
  status: SubscriptionStatus;
  priceBrl: number;
  billingCycle: "monthly" | "yearly";
  provider: PaymentProvider;
  providerSubscriptionId: string | null;
  currentPeriodStart: Date;
  currentPeriodEnd: Date;
  cancelAtPeriodEnd: boolean;
  canceledAt: Date | null;
  trialEnd: Date | null;
  createdAt: Date;
  updatedAt: Date;
}

export interface Payment {
  id: string;
  userId: string;
  subscriptionId: string | null;
  amountBrl: number;
  currency: string;
  provider: PaymentProvider;
  providerPaymentId: string;
  status: PaymentStatus;
  description: string | null;
  metadata: Record<string, unknown> | null;
  createdAt: Date;
}

export interface Coupon {
  id: string;
  code: string;
  discountPercent: number | null;
  discountBrl: number | null;
  maxUses: number | null;
  usesCount: number;
  validUntil: Date | null;
  isActive: boolean;
  createdAt: Date;
}

export const SUBSCRIPTION_LIMITS: Record<SubscriptionPlan, {
  maxAlerts: number;
  maxMilesAccounts: number;
  hasPriceHistory: boolean;
  hasAiAssistant: boolean;
}> = {
  [SubscriptionPlan.FREE]: {
    maxAlerts: 3,
    maxMilesAccounts: 2,
    hasPriceHistory: false,
    hasAiAssistant: false,
  },
  [SubscriptionPlan.STARTER]: {
    maxAlerts: 10,
    maxMilesAccounts: 5,
    hasPriceHistory: true,
    hasAiAssistant: false,
  },
  [SubscriptionPlan.PRO]: {
    maxAlerts: 50,
    maxMilesAccounts: 20,
    hasPriceHistory: true,
    hasAiAssistant: true,
  },
  [SubscriptionPlan.ENTERPRISE]: {
    maxAlerts: Infinity,
    maxMilesAccounts: Infinity,
    hasPriceHistory: true,
    hasAiAssistant: true,
  },
};
