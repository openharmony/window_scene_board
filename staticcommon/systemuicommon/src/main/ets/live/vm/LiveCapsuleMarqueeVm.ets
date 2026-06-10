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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { CutoutVm } from '../../statusbar/vm/CutoutVm';
import { ArkUIAdapter } from '../../utils/ArkUIAdapter';
import { AccessibilityVm } from '../../vm/AccessibilityVm';
import { DeviceInfoVm } from '../../vm/DeviceInfoVm';
import { ResourceVm } from '../../vm/ResourceVm';
import { LiveStyle } from '../constants/LiveStyle';
import { ILiveCapsuleMarqueeVm } from '../interface/ILiveCapsuleMarqueeVm';
import { ILiveCapsuleVm } from '../interface/ILiveCapsuleVm';
import { CapsuleShowType, LiveProgressModel, LiveType } from '../model/LiveCommonModel';
import { LiveNotification } from '../model/LiveNotification';
import { LiveItemBaseVm } from './LiveBaseVm';
import { SystemUICommonUtil } from '../../utils/SystemUICommonUtil';
import { LiveCardScoreModel } from '../model/LiveCardScoreModel';
import { ResUtils } from '@ohos/windowscene';
import measure from '@ohos.measure';

const TAG = 'LiveCapsuleMarqueeVm';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

@ObservedV2
export class LiveCapsuleMarqueeVm extends LiveItemBaseVm implements ILiveCapsuleMarqueeVm {
  public cutoutVm: CutoutVm = CutoutVm.instance;
  public fixedIsSplicing: boolean = false;
  public fixedTextWidth: number = 0;
  public fixedExtendTextWidth: number = 0;
  public fixedTextSize: Length = 0;
  public fixedExtendTextSize: Length = 0;
  @Trace public opacity = 1;
  @Trace public scaleX: number = 1;
  @Trace public scaleY: number = 1;
  @Trace public centerX: string | number = '100%';
  @Trace public centerY: string | number = '100%';
  @Trace public radius: number = 0;
  @Trace public offsetX: number = 0;
  public fixedOffsetX: number = 0;
  @Trace public isMarqueeEnabled = false;
  public fixedIsMarqueeEnabled = false;
  @Trace public isExtendTextMarqueeEnabled = false;
  public fixedIsExtendTextMarqueeEnabled = false;
  private static readonly DEFAULT_PERCENTAGE: number = 100;
  public needFixOffsetX: number = 0; //更新胶囊文本时，跑马灯组件的位移
  /**
   * 是否拼接主副文本
   */
  @Trace public isSplicing: boolean = false;
  @Computed public get isHideContent(): boolean {
    return false;
  }

  public get capsuleVm(): ILiveCapsuleVm {
    return this.vmInjector.getCapsuleVm(this.live);
  }

  @Trace public isRunning = false;
  @Trace public isExtendRunning = false;
  @Trace public textWidth: number = LiveStyle.CAPSULE_TITLE_WIDTH;
  @Trace public extendTextWidth: number = LiveStyle.CAPSULE_EXTEND_TEXT_WIDTH;
  @Trace public isBuildScoreText = false;

  @Computed
  public get hasScroll(): boolean {
    const textWidth = this.getTextWidthBySize(this.textSize);
    const viewWidth = this.textWidth;

    return textWidth > viewWidth;
  }

  @Computed
  public get hasExtendScroll(): boolean {
    const textWidth = this.getTextWidthBySize(this.extendTextSize, true);
    const viewWidth = this.extendTextWidth;

    return textWidth > viewWidth;
  }

  @Computed
  public get marqueeStrategy(): MarqueeUpdateStrategy {
    return this.live.isInstant() ? MarqueeUpdateStrategy.DEFAULT : MarqueeUpdateStrategy.PRESERVE_POSITION;
  }

  public get isExtendShow(): boolean {
    // 宽屏大于预置且存在文本，则认为是能够显示扩展胶囊
    if (ArkUIAdapter.px2vp(DeviceInfoVm.instance.width) <= LiveStyle.WIDTH_THRESHOLD_SMALL &&
      !this.capsuleVm.isLayoutSupportExtendShow) {
      if (this.live.capsule?.isTimer() && this.live.capsule.timer) {
        return true;
      }
      return false;
    }
    const textLen: number = this.getExtendText().length;
    if (textLen === 0 && this.capsuleVm.fixedIsShowRightIcon) {
      // 有右侧图标时，右侧图标相当于副文本
      return true;
    }
    log.showInfo(`isExtendCapsuleShow extendText len ${textLen} display width ${DeviceInfoVm.instance.width}
      isLayoutSupportExtendShow ${this.capsuleVm.isLayoutSupportExtendShow}.`);
    return textLen !== 0;
  }

  @Trace public textSize: Length = LiveStyle.CAPSULE_FONT_SIZE;
  @Trace public extendTextSize: Length = LiveStyle.CAPSULE_FONT_SIZE;
  public textColor: ResourceColor = Color.White;

  @Monitor('cutoutVm.top', 'cutoutVm.position')
  onCutoutChange() {
    if (CutoutVm.instance.isMiddleCutout()) {
      this.centerX = '100%';
      this.centerY = '100%';
      return;
    }
    this.centerX = '0%';
    this.centerY = '0%';
  }

  public static getProgressText(progress?: LiveProgressModel): string {
    if (!progress || Number.isNaN(progress?.currentValue)) {
      return '';
    }
    const maxValue = progress.maxValue ?? LiveCapsuleMarqueeVm.DEFAULT_PERCENTAGE;
    const isPercentage = progress.isPercentage ?? true;
    if (isPercentage) {
      let percentage = progress.currentValue / maxValue * LiveCapsuleMarqueeVm.DEFAULT_PERCENTAGE;
      return percentage.toFixed(0) + '%';
    }
    return `${progress.currentValue}/${maxValue}`;
  }

  public getTextWidthBySize(textSize: Length, isExtend: boolean = false): number {
    return Math.ceil(ArkUIAdapter.px2vp(this.measureCapsuleTextWidth(textSize, isExtend)));
  }

  private measureCapsuleTextWidth(textSize: Length, isExtend: boolean = false): number {
    return measure.measureText({
      textContent: isExtend ? this.getExtendText() : this.getText(),
      fontSize: ArkUIAdapter.vp2px(textSize as number) + 'px',
      fontWeight: LiveStyle.CAPSULE_FONT_WEIGHT,
      fontFamily: LiveStyle.CAPSULE_FONT_FAMILY,
    });
  }

  /**
   * 文本
   */
  public getText(liveNotification?: LiveNotification, capsuleShowType?: CapsuleShowType, isSplicing?: boolean): string {
    const live: LiveNotification = liveNotification ?? this.live;
    const showType: CapsuleShowType = capsuleShowType ?? this.capsuleVm.showType;
    const fixedIsSplicing: boolean = isSplicing ?? this.isSplicing;
    if (this.isHideContent && !this.live.isMediaPlayer()) {
      return ResUtils.getInnerString($r('app.string.please_unlock'));
    }
    let extendTextContent: string = live.capsule?.getExtendTextContent() ?? '';
    if (this.capsuleVm.isScoreScene(live)) {
      extendTextContent = (live.card as LiveCardScoreModel).layoutGuestScore ?? '';
    }
    const mainText: string = this.getMainText(live);
    if (showType === CapsuleShowType.HANGING_HOLE_DOUBLE_ENDED && extendTextContent.length === 0) {
      if (live.capsule?.isTailIconDisplayed && live.capsule.tailIcon) {
        return mainText;
      }
      log.showInfo(`HANGING_HOLE_DOUBLE_ENDED capsule ${live.hashCode} text length = 0}`)
      return '';
    }

    const extendText: string = this.getExtendText(live);
    if (this.live.capsule?.isTimer() && this.live.capsule.timer) {
      return mainText;
    }
    return (fixedIsSplicing && !liveNotification) ? (mainText + ' ' + extendText) : mainText;
  }

  public getMainText(liveNotification?: LiveNotification): string {
    const live: LiveNotification = liveNotification ?? this.live;
    if (live.capsule?.isText()) {
      // 赛事比分场景，返回主队比分
      if (this.capsuleVm.isScoreScene(live)) {
        return (live.card as LiveCardScoreModel).layoutHostScore ?? '';
      }
      return live.capsule.title ?? '';
    }

    if (live.capsule?.isProgress()) {
      const progressText = LiveCapsuleMarqueeVm.getProgressText(live.capsule.progress);
      return live.isCharge() ? live.capsule.title ?? '' : progressText;
    }

    if (live.capsule?.isTimer() && live.capsule.timer) {
      return this.vmInjector.getTimerVm().getTimerText(live.capsule.timer);
    }

    return '';
  }

  public getExtendText(liveNotification?: LiveNotification, capsuleShowType?: CapsuleShowType): string {
    if (this.isHideContent) {
      return '';
    }
    const live: LiveNotification = liveNotification ?? this.live;
    // 赛事比分场景，返回客队比分
    if (this.capsuleVm.isScoreScene(live)) {
      return (live.card as LiveCardScoreModel).layoutGuestScore ?? '';
    }

    const showType: CapsuleShowType = capsuleShowType ?? this.capsuleVm.showType;
    const extendTextContent: string = live.capsule?.getExtendTextContent() ?? '';
    if (showType === CapsuleShowType.HANGING_HOLE_DOUBLE_ENDED && extendTextContent.length === 0) {
      if (live.capsule?.isTailIconDisplayed && live.capsule?.tailIcon) {
        return '';
      }
      return this.getMainText(live);
    }

    return extendTextContent;
  }

  public getAccessibilityText(isExtend: boolean): string {
    if (!AccessibilityVm.instance.isEnabled) {
      return '';
    }
    if (this.isHideContent && !this.live.isMediaPlayer()) {
      return ResUtils.getInnerString($r('app.string.please_unlock'));
    }
    const extendTextContent: string = this.live.capsule?.getExtendTextContent() ?? '';
    if (this.capsuleVm.showType === CapsuleShowType.HANGING_HOLE_DOUBLE_ENDED && extendTextContent.length === 0) {
      if (!isExtend) {
        return '';
      }
    } else if (isExtend) {
      return this.getExtendText();
    }

    if (this.live.capsule?.isText()) {
      if (this.isSplicing) {
        return this.live.capsule.title + this.getExtendText();
      }
      return this.live.capsule.title ?? '';
    }

    if (this.live.capsule?.isProgress()) {
      return this.live.type === LiveType.INSTANT ? this.live.capsule.title ?? '' :
      LiveCapsuleMarqueeVm.getProgressText(this.live.capsule.progress);
    }

    if (this.live.capsule?.isTimer() && this.live.capsule.timer) {
      return this.vmInjector.getTimerVm().getTimerAccessibilityText(this.live.capsule.timer);
    }
    return '';
  }

  public async updateUIProperty(): Promise<void> {
    this.computedMarqueeOffset();
    this.textWidth = this.fixedTextWidth;
    this.extendTextWidth = this.fixedExtendTextWidth;
    this.textSize = this.fixedTextSize;
    this.extendTextSize = this.fixedExtendTextSize;
    this.isSplicing = this.fixedIsSplicing;
    this.offsetX = 0;
    const capsuleVm = this.vmInjector.getCapsuleVm(this.live);
    capsuleVm.isLayoutSupportExtendShow = capsuleVm.fixedIsLayoutSupportExtendShow;
  }

  private computedMarqueeOffset(): void {
    if (!this.textWidth) {
      this.needFixOffsetX = 0;
    }
    if (this.textWidth) {
      if (this.textWidth >= this.fixedTextWidth) {
        this.needFixOffsetX = 0;
      } else {
        this.needFixOffsetX = this.textWidth - this.fixedTextWidth;
      }
    }
    log.showInfo(`computedMarqueeOffset: ${this.needFixOffsetX}`);
  }

  public isCapsuleMarqueeRTL(isExtend: boolean): boolean {
    return ResourceVm.instance.isTextRTL(isExtend ? this.getExtendText() : this.getText());
  }

  public getCapsuleMarqueeAlign(isExtend: boolean): Alignment {
    if (this.capsuleVm.showType === CapsuleShowType.HANGING_HOLE_DOUBLE_ENDED) {
      // 主文本居左
      let alignment = ResourceVm.instance.isRTL ? Alignment.End : Alignment.Start;
      if (isExtend) {
        // 副文本居右
        alignment = ResourceVm.instance.isRTL ? Alignment.Start : Alignment.End;
      }
      return alignment;
    }

    if (this.hasScroll || isExtend) {
      return ResourceVm.instance.isRTL ? Alignment.End : Alignment.Start;
    }
    return Alignment.Center;
  }

  public isEnabled(isExtend: boolean): boolean {
    return isExtend ? this.isExtendTextMarqueeEnabled : this.isMarqueeEnabled;
  }
}