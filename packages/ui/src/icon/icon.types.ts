import { ComponentProps } from "react";
import { iconMap } from "./icon.model";

export type IconProps = {
  type: IconType;
} & ComponentProps<"svg">;

export type IconType = keyof typeof iconMap;
