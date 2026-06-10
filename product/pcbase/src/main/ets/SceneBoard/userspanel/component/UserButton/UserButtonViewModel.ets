/*
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import { UserTextStyle } from '../UserText/UserText';

interface IUserButtonStyle {
  size?: SizeOptions;
  constraintSize?: ConstraintSizeOptions;
  padding?: Padding | Length;
  borderRadius?: BorderRadiuses | Length;
  backgroundColor?: ResourceColor | undefined;
}

/**
 * 自定义按钮样式类，用于传递和修改 Button 组件样式
 * @since 2024-07-25
 */
@Observed
export class UserButtonStyle {
  public size: SizeOptions | undefined;
  public constraintSize: ConstraintSizeOptions | undefined;
  public padding: Padding | Length | undefined;
  public borderRadius: BorderRadiuses | Length;
  public backgroundColor: ResourceColor | undefined;

  constructor(style: IUserButtonStyle) {
    this.size = style.size;
    this.constraintSize = style.constraintSize;
    this.padding = style.padding;
    this.borderRadius = style.borderRadius || 8;
    this.backgroundColor = style.backgroundColor;
  }
}

interface IUserButtonConfig {
  id: string;
  text: ResourceStr;
  type?: ButtonType;
  enabled?: boolean;
  focusAble?: boolean;
  defaultFocus?: boolean;
  style?: UserButtonStyle;
  textStyle?: UserTextStyle;
  onClick?: (ev: ClickEvent) => void;
}

/**
 * UserButton 组件的 ViewModel 类
 * @since 2024-07-25
 */
@Observed
export class UserButtonVM {
  public id: string;
  public text: ResourceStr;
  public type: ButtonType;
  public enabled: boolean;
  public focusAble?: boolean;
  public defaultFocus: boolean;
  public style: UserButtonStyle = new UserButtonStyle({
    borderRadius: $r('sys.float.corner_radius_level4'),
    backgroundColor: $r('sys.color.comp_background_tertiary'),
    padding: { left: 12, right: 12, top: 6, bottom: 6 }
  });
  public textStyle: UserTextStyle = new UserTextStyle({
    size: $r('sys.float.Caption_L'),
    weight: FontWeight.Medium,
    color: $r('sys.color.font_emphasize'),
    lineHeight: 16,
  });
  public onClick: ((ev: ClickEvent) => void) | undefined;

  constructor(config: IUserButtonConfig) {
    this.id = config.id;
    this.text = config.text;
    this.type = config.type || ButtonType.Normal;
    this.enabled = config.enabled || true;
    this.focusAble = config.focusAble || undefined;
    this.defaultFocus = config.defaultFocus || false;
    this.style = config.style || this.style;
    this.textStyle.merge(config.textStyle);
    this.onClick = config.onClick;
  }
}