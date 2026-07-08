export enum UserRole {
  SUPER_ADMIN = "super_admin",
  ADMIN = "admin",
  USER = "user",
}

export enum SubscriptionPlan {
  FREE = "free",
  STARTER = "starter",
  PRO = "pro",
  ENTERPRISE = "enterprise",
}

export enum SubscriptionStatus {
  ACTIVE = "active",
  CANCELED = "canceled",
  PAST_DUE = "past_due",
  TRIALING = "trialing",
  INCOMPLETE = "incomplete",
}

export enum CabinClass {
  ECONOMY = "economy",
  PREMIUM_ECONOMY = "premium_economy",
  BUSINESS = "business",
  FIRST = "first",
}

export enum FlightType {
  ONE_WAY = "one_way",
  ROUND_TRIP = "round_trip",
  MULTI_CITY = "multi_city",
}

export enum AlertType {
  PRICE = "price",
  MILES = "miles",
  ROUTE = "route",
}

export enum NotificationChannel {
  EMAIL = "email",
  PUSH = "push",
  WHATSAPP = "whatsapp",
}

export enum PaymentProvider {
  STRIPE = "stripe",
  MERCADO_PAGO = "mercado_pago",
}

export enum PaymentStatus {
  PENDING = "pending",
  COMPLETED = "completed",
  FAILED = "failed",
  REFUNDED = "refunded",
}

export enum LoyaltyProgramType {
  AIRLINE = "airline",
  BANK = "bank",
  HOTEL = "hotel",
}

export enum TripStatus {
  PLANNING = "planning",
  BOOKED = "booked",
  COMPLETED = "completed",
  CANCELED = "canceled",
}

export enum AuditAction {
  CREATE = "create",
  UPDATE = "update",
  DELETE = "delete",
  LOGIN = "login",
  LOGOUT = "logout",
  FAILED_LOGIN = "failed_login",
  PASSWORD_RESET = "password_reset",
}
