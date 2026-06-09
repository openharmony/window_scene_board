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

import { RTLUtil } from '@ohos/componenthelper/src/main/ets/TsIndex';

const ROOT_ID = '__container__';

// 隐藏文本ID
const HIDE_TEXT_ID = 'hide_sign_text';

// 隐藏文本间距
const HIDE_PADDING = 1;

const MAX_LINES = 1;

const LOOP_COUNT = 2;

const STEP_COUNT = 2;

/**
 * 签名组件
 */
@Component
export struct SignWidget {
  // 最大宽度
  @Prop signMaxWidth: number | string = '100%';

  // 签名文本
  @Prop signText: string = '';

  // 文本颜色
  @Prop signFontColor?: ResourceColor = undefined;

  // 文本大小
  @Prop signFontSize?: Length = undefined;

  // 文本最小字体缩放比例
  @Prop signMinFontScale?: number | Resource = undefined;

  // 文本最大字体缩放比例
  @Prop signMaxFontScale?: number | Resource = undefined;

  // 文本对齐方式
  @Prop signTextAlign: Alignment = Alignment.Center;

  // 整体偏移
  @Prop signOffset?: Position = undefined;

  // 整体锚点
  @Prop signAnchor?: Position = undefined;

  // 整体透明度
  @Prop signAlpha?: number | Resource = undefined;

  // 文本缩放度
  @Prop signScale?: ScaleOptions = undefined;

  // Aod电池图标可见性
  @Prop aodBatteryIconVisibility: Visibility = Visibility.Hidden;

  @Prop isNotificationVisible: boolean = true;

  @Prop isFullBatteryLayout: boolean = false;

  // Aod预览界面
  public isPreviewPage: boolean = false;

  // 是否显示电量图标
  isShowAodBattery: boolean = false;

  // AOD签名最大宽度
  aodSignMaxWidth: number = 0;

  // AOD电量偏移
  aodBatteryOffset: number = 0;

  build() {
    RelativeContainer() {
      // 固定宽度文本
      Text(this.signText)
        .id(HIDE_TEXT_ID)
        .accessibilityLevel('no')
        .fontWeight(FontWeight.Medium)
        .fontColor(this.signFontColor)
        .fontSize(this.signFontSize)
        .opacity(this.signAlpha)
        .minFontScale(this.signMinFontScale)
        .maxFontScale(this.signMaxFontScale)
        .maxLines(MAX_LINES)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .wordBreak(WordBreak.BREAK_ALL)
        .constraintSize({
          maxWidth: this.getSignMaxWidth()
        })// 最大宽度限制
        .padding({ right: HIDE_PADDING }) // 跑马灯文本宽度和组件宽度相等会开启，留边界
        .alignRules(this.getAlignRuleOption())
        .visibility(this.isPreviewPage ? Visibility.Visible : Visibility.Hidden)
        .offset({
          x: this.getOffset() + 'px',
        })
        .scale(this.signScale)

      // 跑马灯文本
      Text(this.signText)
        .accessibilityLevel('no')
        .fontWeight(FontWeight.Medium)
        .fontColor(this.signFontColor)
        .fontSize(this.signFontSize)
        .minFontScale(this.signMinFontScale)
        .maxFontScale(this.signMaxFontScale)
        .maxLines(MAX_LINES)
        .textOverflow({ overflow: this.getMainTextOverflow() })
        .opacity(this.signAlpha)
        .scale(this.signScale)
        .alignRules({ // 与模板保持相同宽度
          left: { anchor: HIDE_TEXT_ID, align: HorizontalAlign.Start },
          right: { anchor: HIDE_TEXT_ID, align: HorizontalAlign.End }
        })
        .visibility(this.isPreviewPage ? Visibility.Hidden : Visibility.Visible)
        // 跑马灯跑2次后停下
        .marqueeOptions({ start: true, fromStart: true, step: STEP_COUNT, loop: LOOP_COUNT })
    }
    .clip(true)
    .width(this.signMaxWidth)
    .offset(this.signOffset)
    .markAnchor(this.signAnchor)
    .accessibilityGroup(true)
    .accessibilityText(this.signText)
  }

  private getMainTextOverflow(): TextOverflow {
    // 熄屏后，停止跑马灯
    return this.isPreviewPage ? TextOverflow.Ellipsis : TextOverflow.MARQUEE;
  }

  private getAlignRuleOption(): AlignRuleOption { // 对齐方式
    if (this.signTextAlign === Alignment.Start) {
      return {
        left: { anchor: ROOT_ID, align: HorizontalAlign.Start }
      };
    }
    if (this.signTextAlign === Alignment.End) {
      return {
        right: { anchor: ROOT_ID, align: HorizontalAlign.End }
      };
    }
    return {
      middle: { anchor: ROOT_ID, align: HorizontalAlign.Center }
    };
  }

  private getBatteryScale(): number {
    return 1;
  }

  private getSignMaxWidth(): number | string {
    if (this.aodBatteryIconVisibility !== Visibility.Visible || !this.isNotificationVisible) {
      return this.signMaxWidth;
    }
    return this.aodSignMaxWidth + 'px';
  }

  private getOffset(): number {
    if (this.aodBatteryIconVisibility !== Visibility.Visible || !this.isNotificationVisible || RTLUtil.isRTL()) {
      return 0;
    }

    return this.aodBatteryOffset;
  }
}