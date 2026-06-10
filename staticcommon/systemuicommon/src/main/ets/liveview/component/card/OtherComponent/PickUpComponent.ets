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
import { LivePickUpTemplate } from '../../../data/template/LivePickUpTemplate';
import { immersiveKgMgr } from '../../../../immersivekeyguardcommon/manager/ImmersiveKeyguardStateManager';
import { CommonUtils } from '@ohos/basicutils';
import { ResUtils } from '@ohos/windowscene';
import { LiveTimerData } from '../../../data/extend/LiveTimerData';
import { NotificationType } from '../../../../constants/NotificationType';
import { RTLUtil } from '@ohos/componenthelper';

/**
 * 扩展区为强调文本模板：比如取餐
 */
@Component
export struct PickUpComponent {
  @ObjectLink data: LivePickUpTemplate;
  @ObjectLink timerData: LiveTimerData;
  @State contentLayoutLength: number = 0;

  /**
   * 通知面板类型
   */
  @Consume notificationType: number;

  @State isShowLine: boolean = true;
  @Prop isSmallFoldOuterScreen: boolean = false;

  build() {
    if (this.data) {
      Column() {
        Row({ space: 10 }) {
          this.buildExtendColumn()
          Image(this.data?.descPic)
            .height(this.isSmallFoldOuterScreen ? 40 : '100%')
            .objectFit(ImageFit.Contain)
            .draggable(false)
            .interpolation(ImageInterpolation.Medium)
            .constraintSize({ maxWidth: 100 })
            .visibility(this.data?.descPic ? Visibility.Visible : Visibility.Hidden)
        }
        .width('100%')
        .height(this.isSmallFoldOuterScreen ? 46 : 60)
        .justifyContent(FlexAlign.SpaceBetween)
        .alignItems(this.isSmallFoldOuterScreen ? VerticalAlign.Bottom : undefined)

        if (this.data.providerName) {
          this.buildProviderName()
        }
      }
      .width('100%')
      .height(this.isSmallFoldOuterScreen ? 46 : 72)
      .opacity(undefined)
      .padding(this.isSmallFoldOuterScreen ? undefined : {
        left: 12,
        right: 12
      })
      .alignItems(HorizontalAlign.End)
    }
  }

  @Builder
  buildExtendColumn() {
    Column() {
      Text(this.data?.extendTitle)
        .fontFamily('HarmonyHeiTi')
        .fontWeight(FontWeight.Regular)
        .fontSize(this.getFontSize())
        .fontColor($r('sys.color.ohos_id_color_text_secondary'))
        .textAlign(TextAlign.Start)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .renderGroup(true)
        .margin({ bottom: this.isSmallFoldOuterScreen ? 5 : 4 })
      this.buildStack();
    }
    .layoutWeight(1)
    .height('100%')
    .justifyContent(this.isSmallFoldOuterScreen ? FlexAlign.End : FlexAlign.Center)
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  buildStack(){
    Stack() {
      if (this.data?.underlineColor && this.isShowLine) {
        Line()
          .height('7vp')
          .width(this.contentLayoutLength)
          .backgroundColor(this.data?.underlineColor)
          .borderRadius('3.5vp')
          .opacity(1)
          .margin({
            top: this.isSmallFoldOuterScreen ? 12 : 20
          })
      }
      Text(this.getExtendContent())
        .accessibilityText(this.data?.transformTimerAccessibilityText(this.data.extendContent ?? '', this.timerData))
        .fontFamily('HarmonyHeiTi')
        .fontWeight(this.isAodTimer() ? FontWeight.Medium : FontWeight.Bold)
        .fontSize(this.isSmallFoldOuterScreen ? '18vp' : '26vp')
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .onSizeChange((oldValue: SizeOptions, newValue: SizeOptions) => {
          setTimeout(() => {
            this.contentLayoutLength = newValue?.width as number;
          }, 0)
        })
        .renderGroup(true)
        .scale(this.getExtendContentScale())
    }
    .alignContent(Alignment.Start)
    .height(this.isSmallFoldOuterScreen ? 20 : undefined)
  }



  @Builder
  buildProviderName() {
    Text(this.data.providerName)
      .fontFamily('HarmonyHeiTi')
      .fontWeight(FontWeight.Regular)
      .fontSize('8vp')
      .fontColor($r('sys.color.ohos_id_color_text_tertiary'))
      .textAlign(TextAlign.Start)
      .maxLines(1)
      .textOverflow({ overflow: TextOverflow.Ellipsis })
      .renderGroup(true)
      .height(12)
  }

  /**
   * 特殊处理：扩展区content长度小于1，则不绘制下划线
   * @returns
   */
  getExtendContent(): string {
    if (CommonUtils.isInvalid(this.data)) {
      return '';
    }
    let result = this.data.transformTimerText(this.data.extendContent ?? '', this.timerData);
    this.isShowLine = result.trim().length > 0;
    if (result.trim().length === 0) {
      return '';
    }
    // 含计时器控件的实况拓展区，AOD下显示为正在计时或正在倒计时
    if (this.isAodTimer()) {
      if (this.timerData?.isCountDown) {
        return ResUtils.getInnerString($r('app.string.aod_count_down_timer_text'));
      }
      return ResUtils.getInnerString($r('app.string.aod_timing_timer_text'));
    }
    return result;
  }

  private getFontSize(): string {
    if (this.isSmallFoldOuterScreen) {
      return '10vp';
    }
    return ResUtils.getNumber($r('sys.float.ohos_id_text_size_body3')) + 'vp';
  }

  /**
   * 特殊处理：扩展区计时控件AOD下文本缩放倍数
   *
   * @returns 拓展区文本缩放参数
   */
  private getExtendContentScale(): ScaleOptions {
    let scaleRate = 1;
    if (this.isAodTimer()) {
      // VDE外屏扩展区计时器字号18，AOD下扩展区计时器文本字号14
      if (this.isSmallFoldOuterScreen) {
        scaleRate = 14 / 18;
      } else {
        // 直板机扩展区计时器字号26，AOD下扩展区计时器文本字号16
        scaleRate = 16 / 26;
      }
    }
    return {
      x: scaleRate,
      y: scaleRate,
      centerX: RTLUtil.isRTL() ? '100%' : 0,
      centerY: '50%',
    };
  }

  /**
   *
   * @returns boolean 通知类型为含有计时器的实况类型
   */
  private isAodTimer(): boolean {
    return this.data.isTimeTemplate ? true : false;
  }
}