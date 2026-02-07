import {
  Heart,
  LogIn,
  LogOut,
  LucideIcon,
  Menu,
  Package,
  Search,
  ShoppingCart,
} from "lucide-react";

export const iconMap = {
  search: Search,
  order: Package,
  cart: ShoppingCart,
  favorita: Heart,
  menu: Menu,
  login: LogIn,
  logout: LogOut,
} as const satisfies Record<string, LucideIcon>;
