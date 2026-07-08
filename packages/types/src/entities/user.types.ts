import { UserRole, SubscriptionPlan } from "../common/enums";

export interface User {
  id: string;
  email: string;
  name: string | null;
  avatarUrl: string | null;
  role: UserRole;
  isActive: boolean;
  emailVerified: boolean;
  phoneNumber: string | null;
  subscriptionPlan: SubscriptionPlan;
  preferredCurrency: string;
  preferredLanguage: string;
  createdAt: Date;
  updatedAt: Date;
  deletedAt: Date | null;
}

export interface UserProfile extends User {
  milesAccountsCount: number;
  activeAlertsCount: number;
  totalSavedBrl: number;
}

export type CreateUserDto = Pick<User, "email" | "name"> & {
  password?: string;
};

export type UpdateUserDto = Partial<
  Pick<User, "name" | "avatarUrl" | "phoneNumber" | "preferredCurrency" | "preferredLanguage">
>;
