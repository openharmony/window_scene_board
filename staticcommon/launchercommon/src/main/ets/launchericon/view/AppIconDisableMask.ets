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

import { AttributeUpdater } from '@kit.ArkUI';
import { StyleConstants } from '../../constants/StyleConstants';

@Component
export struct AppIconDisableMask {
  appIconId: string = '';
  bundleName: string = '';
  onDisableStatusChange: () => void = (): void => {};
  private iconMarginTop: number = 0;
  private isAdaptiveExtendLayout: boolean = false;
  private itemOffset?: Position;
  private disableMaskModifier?: AttributeUpdater<CommonAttribute>;
  private iconAlignRules: AlignRuleOption = {
    middle: { anchor: '__container__', align: HorizontalAlign.Center },
    top: { anchor: '__container__', align: VerticalAlign.Top }
  }

  @Link iconSize: number;
  @Prop iconRadius: number;
  @Prop iconScale: number = 1;
  // 用于小文件夹打开关闭透明度动效
  @Prop iconOpacity: number = 1.0;

  build() {
    Column()
      .width(this.isAdaptiveExtendLayout ? StyleConstants.PERCENTAGE_100 : this.iconSize)
      .height(this.isAdaptiveExtendLayout ? StyleConstants.PERCENTAGE_100 : this.iconSize)
      .backgroundColor(StyleConstants.APP_ICON_GRAY_COLOR)
      .scale({ x: this.iconScale, y: this.iconScale })
      .borderRadius(this.iconRadius)
      .opacity(this.iconOpacity)
      .enabled(false)
      .alignRules(this.iconAlignRules)
      .margin({
        top: this.iconMarginTop,
      })
      .offset(this.itemOffset)
      .id(`${this.appIconId}_AppIconDisableMask`)
      .attributeModifier(this.disableMaskModifier)
  }
}