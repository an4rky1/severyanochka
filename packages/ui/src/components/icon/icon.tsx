import { LucideIcon } from "lucide-react";
import { iconMap } from "./icon.model";
import { IconProps } from "./icon.types";

export function Icon({ type, ...props }: IconProps) {
  const Component: LucideIcon = iconMap[type];

  return <Component {...props} />;
}
