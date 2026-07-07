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

import measure from '@ohos.measure';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { CapsuleShowType } from '../model/LiveCommonModel';
import { LiveStyle } from '../constants/LiveStyle';
import { LiveBaseVm } from './LiveBaseVm';
import { LiveNotification } from '../model/LiveNotification';
import { ILiveCapsuleVm } from '../interface/ILiveCapsuleVm';
import { CutoutVm } from '../../statusbar/vm/CutoutVm';
import { DeviceInfoVm } from '../../vm/DeviceInfoVm';
import { ArkUIAdapter } from '../../utils/ArkUIAdapter';
import { LiveCardScoreModel } from '../model/LiveCardScoreModel';

const TAG = 'LiveCapsuleListLayoutBaseVm';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

interface TextInfo {
  width: number;
  fontSize: number;
}

export class StackIconStyle {
  /**
   * 单边堆叠右边图标最大偏移距离
   */
  public static readonly STACK_ICON_MAX_MARGIN = 16;
  /**
   * 不把时间挤没的前提下，单边堆叠右边图标最小偏移距离
   * 有录屏时如果用这个距离还放不下，可以把时间挤没
   */
  public static readonly STACK_ICON_MIN_MARGIN_WITH_TIME = 12;
  /**
   * 单边挂孔胶囊最小宽度
   * 赛事比分场景以两边比分均为三位数计算出该宽度
   */
  public static readonly CAPSULE_HANGING_HOLE_MIN_WIDTH = 78;
}

@ObservedV2
export class LiveCapsuleListLayoutBaseVm extends LiveBaseVm {
  public cutoutVm: CutoutVm = CutoutVm.instance;
  /**
   * 普通除去文本内容宽度之前其他元素宽度之和（不显示拓展文本）
   * |-2-24-4-main text-6|
   */
  private readonly capsuleNonTextWidthWithoutExtend: number = 36;
  /**
   * 普通(右侧有图标)除去文本内容宽度之前其他元素宽度之和（不显示拓展文本）
   * |-2-24-4-main text-6|
   */
  private readonly doubleIconCapsuleNonTextWidthWithoutExtend: number = 60;
  /**
   * 普通胶囊除去文本内容宽度之前其他元素宽度之和（显示拓展文本）
   * |-2-24-4-main text-6-extend text-6|
   */
  private readonly capsuleNonTextWidthWithExtend: number = 42;
  /**
   * 普通胶囊（右侧有图标）除去文本内容宽度之前其他元素宽度之和（显示拓展文本）
   * |-2-24-4-main text-6-extend text-4-24-2|
   */
  private readonly doubleIconCapsuleNonTextWidthWithExtend: number = 66;
  /**
   * 挂孔胶囊除去文本内容宽度之前其他元素宽度之和（不显示拓展文本）
   * |-2-24-4-main text-2-2-hole|
   */
  private readonly hangingCapsuleNonTextWidthWithoutExtend: number = 32;
  /**
   * 窄屏设备定制定制 挂孔胶囊除去文本内容宽度之前其他元素宽度之和（不显示拓展文本）
   * |-2-24-4-main text-1-hole| 这里去掉2，hangingCapsuleGap去掉1
   */
  private readonly hangingCapsuleNonTextWidthWithoutExtendCustom: number = 30;
  /**
   * 挂孔胶囊除去文本内容宽度之前其他元素宽度之和（显示拓展文本）
   * |-2-24-4-main text-4-extend text-2-2-hole|
   */
  private readonly hangingCapsuleNonTextWidthWithExtend: number = 36;
  /**
   * 窄屏设备定制定制 挂孔胶囊除去文本内容宽度之前其他元素宽度之和（显示拓展文本）
   * |-2-24-4-main text-4-extend text-1-hole| 这里去掉2，hangingCapsuleGap去掉1
   */
  private readonly hangingCapsuleNonTextWidthWithExtendCustom: number = 34;
  /**
   * 双端挂孔胶囊左侧除去文本内容宽度之前其他元素宽度之和
   * 双端挂孔胶囊右侧除去文本内容宽度之前其他元素宽度之和（有图标）
   * |-2-24-4-main text-2-2-hole- 4 - extend text - 4-(24?)-2|
   */
  private readonly hangingLeftAndRightCapsuleNonTextWidth: number = 34;
  /**
   * 窄屏设备定制定制 挂孔胶囊除去文本内容宽度之前其他元素宽度之和（不显示拓展文本）
   * |-2-24-4-main text-2-2-hole- 1 - extend text - 6|
   */
  private readonly hangingLeftCapsuleNonTextWidthCustom: number = 31;
  /**
   * 挂孔胶囊除去文本内容宽度之前其他元素宽度之和（显示拓展文本）
   * |-2-24-4-main text-2-2-hole- 4 - extend text - 6|
   */
  private readonly hangingRightCapsuleNonTextWidth: number = 10;
  /**
   * 窄屏设备定制定制 挂孔胶囊除去文本内容宽度之前其他元素宽度之和（显示拓展文本）
   * |-2-24-4-main text-2-2-hole- 1 - extend text - 6|
   */
  private readonly hangingRightCapsuleNonTextWidthCustom: number = 7;
  /**
   * 有无胶囊切换时，状态栏高度变化标识tag
   */
  public readonly statusbarHeightChangeTag: string = 'statusbarHeightChangeTag';

  protected getSpaceBetweenCapsuleAndStatusBar(): number {
    if (!this.cutoutVm.isMiddleCutout()) {
      return LiveStyle.CAPSULE_STATUS_BAR_GAP_WITHOUT_HOLE;
    }

    return this.cutoutVm.holes.length === 1 ? LiveStyle.CAPSULE_STATUS_BAR_GAP_SINGLE_HOLE :
    LiveStyle.CAPSULE_STATUS_BAR_GAP_MULTI_HOLE;
  }

  protected isExistTextContent(live: LiveNotification, isExtend: boolean): boolean {
    const extendText: string = this.getText(live, isExtend);
    if (live.capsule && extendText.length !== 0) {
      return true;
    }

    if (live.capsule && this.isShowRightIcon(live)) {
      return true;
    }

    return false;
  }

  /**
   * 获取最小宽度
   *
   * @param live 实况
   * @returns 最小显示宽度
   */
  public getMinWidth(live: LiveNotification, isLeft: boolean = true): number {
    const capsuleVm: ILiveCapsuleVm = this.vmInjector.getCapsuleVm(live);
    if (capsuleVm.fixedShowType === CapsuleShowType.HANGING_HOLE_DOUBLE_ENDED) {
      return this.getMinWidthForHangingHoleDoubleEnded(live, isLeft);
    }

    if (capsuleVm.fixedShowType === CapsuleShowType.HANGING_HOLE) {
      let minWidth = this.getMinHangHoleWidth(live);
      if (capsuleVm.isScoreScene(live)) {
        minWidth = Math.max(StackIconStyle.CAPSULE_HANGING_HOLE_MIN_WIDTH, minWidth);
      }
      log.showInfo(`getMinWidth capsuleVm.fixedShowType ${capsuleVm.fixedShowType} minWidth ${minWidth}.`);
      return minWidth;
    }

    if (capsuleVm.fixedShowType === CapsuleShowType.TOP) {
      const isShowForExtend: boolean = this.isExtendShow(live);
      return isShowForExtend ? LiveStyle.CAPSULE_EXTEND_WIDTH : LiveStyle.CAPSULE_WIDTH;
    }

    if (capsuleVm.fixedShowType === CapsuleShowType.LEFT_HOLE ||
      capsuleVm.fixedShowType === CapsuleShowType.RIGHT_HOLE ||
      capsuleVm.fixedShowType === CapsuleShowType.ROUND_CAKE ||
      capsuleVm.fixedShowType === CapsuleShowType.RETRACTABLE_ROUND_CAKE) {
      return LiveStyle.CAPSULE_CIRCLE_WIDTH;
    }

    if (capsuleVm.fixedShowType === CapsuleShowType.SHADOW) {
      return LiveStyle.SHADOW_CAPSULE_CIRCLE_WIDTH;
    }

    return 0;
  }

  /**
   * 计算双端挂孔胶囊的最短长度规则如下：
   * 1. 如果挖孔宽度/实际占用宽度 < 30%, 则直接使用单端默认最小宽度。
   * 2. 如果挖孔宽度/实际占用宽度 >= 30%, 说明挖孔占胶囊整体宽度较宽，胶囊无需再做伸长调整，直接使用单端实际占用宽度，单必须在27vp和48vp范围内
   * @param live
   * @param isLeft
   * @returns
   */
  protected getMinWidthForHangingHoleDoubleEnded(live: LiveNotification, isLeft: boolean): number {
    const fixedFontSize = this.getCapsuleFontSize(live, false);
    const leftWidth = this.getHangingHoleDoubleCapsuleRealWidth(live, fixedFontSize, true);
    const rightWidth = this.getHangingHoleDoubleCapsuleRealWidth(live, fixedFontSize, false);
    const ratio = this.cutoutVm.width / (leftWidth + this.cutoutVm.width + rightWidth);

    let result = 0;
    if (ratio < 0.3) {
      result = LiveStyle.HANGING_HOLE_DOUBLE_ENDED_LEFT_RIGHT_MIN_WIDTH;
    } else {
      const nonText = (rightWidth - this.getCapsuleMarqueeWithoutTextWidth(live, true)) === 0;
      result = isLeft? leftWidth : rightWidth
      result = Math.min(Math.max(result, LiveStyle.HANGING_HOLE_DOUBLE_ENDED_LEFT_RIGHT_MIN_WIDTH_WITHOUT_TEXT),
        LiveStyle.HANGING_HOLE_DOUBLE_ENDED_LEFT_RIGHT_MIN_WIDTH);
      if (nonText && this.isShowRightIcon(live)) {
        return rightWidth + 2;
      }
    }
    log.showInfo(`getMinWidthForHangingHoleDoubleEnded, leftWidth: ${leftWidth}, rightWidth: ${rightWidth}, ratio: ${ratio}, result: ${result}`);
    return result;
  }

  protected getCapsuleFontSize(live: LiveNotification, isMin: boolean): number {
    return LiveStyle.CAPSULE_FONT_MIN_SIZE;
  }

  protected isNeedAdjustWidth(space: number, showType: CapsuleShowType): boolean {
    if (space < 0) {
      return false;
    }

    if (showType === CapsuleShowType.LEFT_HOLE || showType === CapsuleShowType.RIGHT_HOLE ||
      showType === CapsuleShowType.ROUND_CAKE || showType === CapsuleShowType.SHADOW) {
      return false;
    }
    return true;
  }

  /**
   * 文本
   */
  protected getText(live: LiveNotification, isExtend: boolean = false, inMarquee: boolean = false): string {
    const capsuleVm = this.vmInjector.getCapsuleVm(live);
    const capsuleMarqueeVm = this.vmInjector.getCapsuleMarqueeVm(live);
    if (inMarquee) {
      return isExtend ? capsuleMarqueeVm.getExtendText(live, capsuleVm.fixedShowType) :
      capsuleMarqueeVm.getText(undefined, capsuleVm.fixedShowType, capsuleMarqueeVm.fixedIsSplicing);
    }
    return isExtend ? capsuleMarqueeVm.getExtendText(live, capsuleVm.fixedShowType) :
    capsuleMarqueeVm.getText(live, capsuleVm.fixedShowType);
  }

  /**
   * 获取指定胶囊副文本内容
   */
  protected getExtendTextContent(live: LiveNotification): string {
    const capsule = live.capsule;
    if (!capsule) {
      return '';
    }
    if (this.vmInjector.getCapsuleVm(live).isScoreScene(live)) {
      return (live.card as LiveCardScoreModel).layoutGuestScore ?? '';
    }
    return capsule.getExtendTextContent();
  }

  protected isShowRightIcon(live: LiveNotification): boolean {
    const capsuleVm = this.vmInjector.getCapsuleVm(live);
    if (capsuleVm.isScoreScene(live)) {
      // 赛事显示右侧图标
      return (capsuleVm.fixedShowType === CapsuleShowType.HANGING_HOLE_DOUBLE_ENDED ||
        capsuleVm.fixedShowType === CapsuleShowType.TOP ||
        capsuleVm.fixedShowType === CapsuleShowType.SELF_ADAPTIVE_ROUND_CAKE)
    }
    if (live.capsule?.isTailIconDisplayed && live.capsule.tailIcon) {
      return capsuleVm.fixedShowType === CapsuleShowType.HANGING_HOLE_DOUBLE_ENDED ||
        capsuleVm.fixedShowType === CapsuleShowType.TOP ||
        capsuleVm.fixedShowType === CapsuleShowType.SELF_ADAPTIVE_ROUND_CAKE;
    }
    return false;
  }

  protected isExtendShow(live: LiveNotification): boolean {
    if (ArkUIAdapter.px2vp(DeviceInfoVm.instance.width) <= LiveStyle.WIDTH_THRESHOLD_SMALL) {
      return false;
    }

    const extendTextLen: number = this.getExtendTextContent(live).length;
    log.showInfo(`isExtendCapsuleShow extendText len ${extendTextLen} display width ${DeviceInfoVm.instance.width}.`);
    return extendTextLen !== 0;
  }

  protected getExpectWidth(live: LiveNotification, isShowForExtend: boolean = false,
    realCapsuleWidth?: number): number {
    const capsuleVm = this.vmInjector.getCapsuleVm(live);
    if (capsuleVm.fixedShowType === CapsuleShowType.SHADOW) {
      return LiveStyle.SHADOW_CAPSULE_CIRCLE_WIDTH;
    }

    if (capsuleVm.fixedShowType === CapsuleShowType.RETRACTABLE_ROUND_CAKE) {
      return LiveStyle.CAPSULE_WIDTH;
    }

    if (capsuleVm.fixedShowType === CapsuleShowType.HANGING_HOLE) {
      if (!isShowForExtend) {
        log.showInfo(`getExpectWidth fixedShowType ${capsuleVm.fixedShowType} minWidthWithExtendTextWidth ${LiveStyle.HANGING_CAPSULE_MAX_WIDTH}.`);
        realCapsuleWidth = realCapsuleWidth ?? this.getMinHangHoleWidth(live);
        const expectWidth =
          this.getExpectWidthByLimit(realCapsuleWidth, this.getMinHangHoleWidth(live),
            LiveStyle.HANGING_CAPSULE_MAX_WIDTH);
        log.showInfo(`capsule expect width ${expectWidth}.`);
        return expectWidth;
      }
      const maxCapsuleFontSize = this.getCapsuleFontSize(live, false);
      const expectWidthWithExtendTextWidth = this.getHangingHoleCapsuleRealWidth(live, maxCapsuleFontSize);
      log.showInfo(`getExpectWidth fixedShowType ${capsuleVm.fixedShowType} minWidthWithExtendTextWidth ${LiveStyle.HANGING_CAPSULE_MAX_WIDTH}.`);
      return expectWidthWithExtendTextWidth;
    }

    let capsuleMinWidth: number = LiveStyle.CAPSULE_WIDTH;
    let capsuleMaxWidth: number = LiveStyle.CAPSULE_MAX_WIDTH;
    if (isShowForExtend) {
      capsuleMinWidth = LiveStyle.CAPSULE_EXTEND_WIDTH;
      capsuleMaxWidth = LiveStyle.CAPSULE_EXTEND_MAX_WIDTH;
    }
    if (live.isInstant()) {
      capsuleMaxWidth = LiveStyle.CAPSULE_REMIND_MAX_WIDTH;
    }
    if (this.isShowRightIcon(live)) {
      const iconWidth = capsuleVm.iconWidth;
      capsuleMaxWidth += iconWidth;
    }
    realCapsuleWidth = realCapsuleWidth ?? capsuleMinWidth;
    const expectWidth = this.getExpectWidthByLimit(realCapsuleWidth, capsuleMinWidth, capsuleMaxWidth);
    log.showInfo(`capsule expect width ${expectWidth}.`);
    return expectWidth;
  }

  private getExpectWidthByLimit(realCapsuleWidth: number, capsuleMinWidth: number, capsuleMaxWidth: number) {
    let expectWidth = realCapsuleWidth;
    if (realCapsuleWidth < capsuleMinWidth) {
      expectWidth = capsuleMinWidth;
    } else if (realCapsuleWidth > capsuleMaxWidth) {
      expectWidth = capsuleMaxWidth;
    } else {
      expectWidth = realCapsuleWidth;
    }
    return expectWidth;
  }

  protected getHangingHoleDoubleCapsuleRealWidth(live: LiveNotification, textSize: Length, isLeft: boolean = true) {
    const isExtend: boolean = !isLeft;
    const nonTextWidth: number = this.getCapsuleMarqueeWithoutTextWidth(live, isExtend);

    let text: string = this.getText(live, isExtend);
    const realTextWidth: number = this.getTextWidthBySize(textSize, text);
    log.showInfo(`getHangingHoleDoubleCapsuleRealWidth isExtend ${isExtend} text len ${text.length} ${realTextWidth} ${textSize}`);
    const expectCapsuleWidth =
      realTextWidth + nonTextWidth;
    return expectCapsuleWidth;
  }

  private getHangingHoleCapsuleRealWidth(live: LiveNotification, textSize: Length) {
    let text: string = this.getText(live);
    let extendText: string = this.getText(live, true);
    const realTextWidth: number = this.getTextWidthBySize(textSize, text);
    const realExtendTextWidth: number = this.getTextWidthBySize(textSize, extendText);
    log.showInfo(`getHangingHoleCapsuleRealWidth text len ${text.length} extendText len ${extendText.length} ${realTextWidth} ${realExtendTextWidth} ${textSize}`);
    const expectWidthWithExtendTextWidth =
      realTextWidth + realExtendTextWidth + this.getCapsuleMarqueeWithoutTextWidth(live, true);
    return expectWidthWithExtendTextWidth;
  }

  public adjustFixedWidth(space: number, live: LiveNotification, isUpdateImmediately: boolean,
    isLeft: boolean = true): number {
    const capsuleVm = this.vmInjector.getCapsuleVm(live);
    capsuleVm.fixedIsShowRightIcon = this.isShowRightIcon(live);
    if (capsuleVm.fixedShowType === CapsuleShowType.HANGING_HOLE_DOUBLE_ENDED) {
      const currentWidth: number = this.getMinWidth(live, isLeft);
      return this.adjustFixedWidthForHangingHoleDoubleEndedType(live, isLeft, space, currentWidth, isUpdateImmediately);
    }


    if (capsuleVm.fixedShowType === CapsuleShowType.HANGING_HOLE && this.isExistTextContent(live, true)) {
      let increasesUsedSpace: number = -1;
      increasesUsedSpace =
        this.adjustFixedWidthForHangingWithExtend(live, capsuleVm, space, isUpdateImmediately, increasesUsedSpace);

      if (increasesUsedSpace !== -1) {
        return increasesUsedSpace;
      }
    }
    capsuleVm.fixedIsLayoutSupportExtendShow = false;
    return this.adjustFixedWidthForNoHangingHoleType(live, space, isUpdateImmediately);
  }

  public adjustFixedWidth2SpecifyWidth(live: LiveNotification, isLeft: boolean, capsuleWidth: number,
    isUpdateImmediately: boolean): boolean {
    const capsuleVm = this.vmInjector.getCapsuleVm(live);
    if (capsuleVm.fixedShowType === CapsuleShowType.HANGING_HOLE_DOUBLE_ENDED) {
      this.adjustFixedWidth2SpecifyWidthForHangingHoleDoubleEndedType(live, isLeft, capsuleWidth, isUpdateImmediately);
      return true;
    }

    return false;
  }

  protected getTextWidthAndSizeByCapsuleWidth(live: LiveNotification, capsuleWidth: number, isLeft: boolean): TextInfo {
    const isExtend = !isLeft;
    const textWidth: number = capsuleWidth - this.getCapsuleMarqueeWithoutTextWidth(live, isExtend);
    const textContent = this.getText(live, isExtend);
    const frontSize: Length = this.getCapsuleFontSize(live, false);
    return { width: textWidth, fontSize: frontSize };
  }

  private adjustFixedWidth2SpecifyWidthForHangingHoleDoubleEndedType(live: LiveNotification, isLeft: boolean,
    capsuleWidth: number,
    isUpdateImmediately: boolean) {
    const textInfo: TextInfo = this.getTextWidthAndSizeByCapsuleWidth(live, capsuleWidth, isLeft);
    const capsuleMarqueeVm = this.vmInjector.getCapsuleMarqueeVm(live);
    capsuleMarqueeVm.fixedIsSplicing = false;
    if (isLeft) {
      capsuleMarqueeVm.fixedTextWidth = textInfo.width;
      capsuleMarqueeVm.fixedTextSize = textInfo.fontSize;
      capsuleMarqueeVm.fixedIsMarqueeEnabled = false;
    } else {
      capsuleMarqueeVm.fixedExtendTextWidth = textInfo.width;
      capsuleMarqueeVm.fixedExtendTextSize = textInfo.fontSize;
      let text: string = this.getText(live, true);
      const realTextWidth: number = this.getTextWidthBySize(textInfo.fontSize, text);
      capsuleMarqueeVm.fixedIsExtendTextMarqueeEnabled = realTextWidth > capsuleMarqueeVm.fixedExtendTextWidth;
    }
    capsuleMarqueeVm.fixedOffsetX = 0;
    if (isUpdateImmediately) {
      const capsuleMarqueeVm = this.vmInjector.getCapsuleMarqueeVm(live);
      log.showInfo(`adjustFixedWidth2SpecifyWidthForHangingHoleDoubleEndedType(hashcode:${live.hashCode} capsuleMarqueeVm.textWidth ${capsuleMarqueeVm.textWidth}` +
        ` ${capsuleMarqueeVm.fixedTextWidth} ${capsuleMarqueeVm.fixedExtendTextWidth} ${capsuleMarqueeVm.fixedTextSize} ${capsuleMarqueeVm.fixedIsSplicing}.`);
      capsuleMarqueeVm.updateUIProperty();
    }
  }

  protected adjustFixedWidthForHangingHoleDoubleEndedType(live: LiveNotification, isLeft: boolean, space: number,
    currentWidth: number,
    isUpdateImmediately: boolean, isTransientState: boolean = false): number {
    if (!isLeft && !this.isExistTextContent(live, true)) {
      log.showWarn(`adjustFixedWidthForHangingHoleDoubleEndedType no extend text for right capsule.`);
      const capsuleMarqueeVm = this.vmInjector.getCapsuleMarqueeVm(live);
      capsuleMarqueeVm.fixedExtendTextWidth = 0;
      return 0;
    }
    const capsuleVm = this.vmInjector.getCapsuleVm(live);
    const capsuleFontSize = this.getCapsuleFontSize(live, false);
    let expectWidth: number =
      this.getExpectWidthForHangingHoleDoubleEndedType(live, capsuleFontSize, isLeft, isTransientState);
    let expectIncreasedUseSpace: number = expectWidth - currentWidth;

    expectIncreasedUseSpace = expectIncreasedUseSpace < 0 ? 0 : expectIncreasedUseSpace;
    let realIncreasedUseSpace = (space >= expectIncreasedUseSpace) ? expectIncreasedUseSpace : space;
    log.showInfo(`adjustFixedWidthForHangingHoleDoubleEndedType currentWidth ${currentWidth} expectWidth ${expectWidth} expectIncreasedUseSpace ${expectIncreasedUseSpace} realIncreasedUseSpace ${realIncreasedUseSpace} isLeft ${isLeft}.`);
    const isExtend = !isLeft;
    let fixedWidth = currentWidth + realIncreasedUseSpace;
    const capsuleMarqueeVm = this.vmInjector.getCapsuleMarqueeVm(live);
    if (realIncreasedUseSpace >= expectIncreasedUseSpace) {
      this.setFixedTextProperties(live, isLeft, fixedWidth, capsuleFontSize);
      log.showInfo(`adjustFixedWidthForHangingHoleDoubleEndedType isLeft ${isLeft} capsuleMarqueeVm.fixedTextWidth ${capsuleMarqueeVm.fixedTextWidth} capsuleMarqueeVm.fixedExtendTextWidth ${capsuleMarqueeVm.fixedExtendTextWidth}.`);
    } else {
      let fixedTextSize: Length = capsuleFontSize;
      expectWidth = this.getExpectWidthForHangingHoleDoubleEndedType(live, fixedTextSize, isLeft, isTransientState);
      expectIncreasedUseSpace = expectWidth - currentWidth;
      expectIncreasedUseSpace = expectIncreasedUseSpace < 0 ? 0 : expectIncreasedUseSpace;
      realIncreasedUseSpace = (space >= expectIncreasedUseSpace) ? expectIncreasedUseSpace : space;
      fixedWidth = currentWidth + realIncreasedUseSpace;
      this.setFixedTextProperties(live, isLeft, fixedWidth, fixedTextSize);
    }
    capsuleMarqueeVm.fixedIsSplicing = false;
    capsuleMarqueeVm.fixedOffsetX = 0;
    capsuleVm.fixedIsLayoutSupportExtendShow = true;
    if (isUpdateImmediately) {
      const capsuleMarqueeVm = this.vmInjector.getCapsuleMarqueeVm(live);
      log.showInfo(`adjustFixedWidthForHangingHoleDoubleEndedType(hashcode:${live.hashCode} capsuleMarqueeVm.textWidth ${capsuleMarqueeVm.textWidth}` +
        ` ${capsuleMarqueeVm.fixedTextWidth} ${capsuleMarqueeVm.fixedExtendTextWidth} ${capsuleMarqueeVm.fixedTextSize} ${capsuleMarqueeVm.fixedIsSplicing}.`);
      capsuleMarqueeVm.updateUIProperty();
    }

    return realIncreasedUseSpace;
  }

  private setFixedTextProperties(live: LiveNotification, isLeft: boolean, fixedWidth: number,
    fixedTextSize: number) {
    const capsuleMarqueeVm = this.vmInjector.getCapsuleMarqueeVm(live);
    const isExtend = !isLeft;
    if (isLeft) {
      capsuleMarqueeVm.fixedTextWidth = fixedWidth - this.getCapsuleMarqueeWithoutTextWidth(live, isExtend);
      capsuleMarqueeVm.fixedTextSize = fixedTextSize;
      capsuleMarqueeVm.fixedIsMarqueeEnabled = false;
    } else {
      capsuleMarqueeVm.fixedExtendTextWidth = fixedWidth - this.getCapsuleMarqueeWithoutTextWidth(live, isExtend);
      capsuleMarqueeVm.fixedExtendTextSize = fixedTextSize;
      let text: string = this.getText(live, true);
      const realTextWidth: number = this.getTextWidthBySize(capsuleMarqueeVm.fixedExtendTextSize, text);
      capsuleMarqueeVm.fixedIsExtendTextMarqueeEnabled = realTextWidth > capsuleMarqueeVm.fixedExtendTextWidth;
    }
  }

  private getExpectWidthForHangingHoleDoubleEndedType(live: LiveNotification, fixedTextSize: number, isLeft: boolean,
    isTransientState: boolean = false): number {
    const realCapsuleWidth: number = this.getHangingHoleDoubleCapsuleRealWidth(live, fixedTextSize, isLeft);
    if (isLeft) {
      return realCapsuleWidth;
    }

    if (isTransientState) {
      return realCapsuleWidth;
    }

    const mainTextContent = this.getText(live, false);
    if (mainTextContent.length === 0) {
      if (live.isMediaPlayer()) {
        return Math.min(LiveStyle.MEDIA_PLAYER_DOUBLE_ENDED_SINGLE_TEXT_RIGHT_MAX_WIDTH, realCapsuleWidth);
      }
      return Math.min(LiveStyle.HANGING_HOLE_DOUBLE_ENDED_SINGLE_TEXT_RIGHT_MAX_WIDTH, realCapsuleWidth);
    }

    return Math.min(LiveStyle.HANGING_HOLE_DOUBLE_ENDED_DOUBLE_TEXT_RIGHT_MAX_WIDTH, realCapsuleWidth);
  }

  protected adjustFixedWidthForHangingWithExtend(live: LiveNotification, capsuleVm: ILiveCapsuleVm, space: number,
    isUpdateImmediately: boolean,
    increasesUsedSpace: number) {
    const minCapsuleFrontSize = this.getCapsuleFontSize(live, true);
    const maxCapsuleFrontSize = this.getCapsuleFontSize(live, false);
    for (let index = maxCapsuleFrontSize; index >= minCapsuleFrontSize; index--) {
      let text: string = this.getText(live);
      let extendText: string = this.getText(live, true);
      const realTextWidth: number = this.getTextWidthBySize(index, text);
      const realExtendTextWidth: number = this.getTextWidthBySize(index, extendText);
      log.showInfo(`adjustFixedWidthForHangingWithExtend ${realTextWidth} ${realExtendTextWidth} ${index}`);
      const isExtend = realExtendTextWidth > 0;
      const capsuleWidth = realTextWidth + realExtendTextWidth + this.getCapsuleMarqueeWithoutTextWidth(live, isExtend);
      log.showInfo(`adjustFixedWidthForHangingWithExtend ${capsuleVm.fixedWidth} ${space} ${capsuleWidth}.`);
      if (capsuleVm.fixedWidth + space >= capsuleWidth) {
        capsuleVm.fixedIsLayoutSupportExtendShow = true;
        increasesUsedSpace = (capsuleWidth - capsuleVm.fixedWidth) > 0 ? (capsuleWidth - capsuleVm.fixedWidth) : 0;
        capsuleVm.fixedWidth = capsuleWidth;
        log.showInfo(`adjustFixedWidthForHangingWithExtend ${capsuleVm.fixedWidth} ${space} ${capsuleWidth} ${capsuleVm.fixedIsLayoutSupportExtendShow}.`);
        this.setCapsuleMarqueeFixedParam(live, realTextWidth, realExtendTextWidth, index, isUpdateImmediately);
        break;
      }
    }

    return increasesUsedSpace;
  }

  private setCapsuleMarqueeFixedParam(live: LiveNotification, realTextWidth: number, realExtendTextWidth: number,
    index: number,
    isUpdateImmediately: boolean) {
    const capsuleMarqueeVm = this.vmInjector.getCapsuleMarqueeVm(live);
    capsuleMarqueeVm.fixedIsSplicing = false;
    capsuleMarqueeVm.fixedTextWidth = realTextWidth;
    capsuleMarqueeVm.fixedExtendTextWidth = realExtendTextWidth;
    capsuleMarqueeVm.fixedTextSize = index;
    capsuleMarqueeVm.fixedExtendTextSize = index;
    const capsuleVm = this.vmInjector.getCapsuleVm(live);
    capsuleMarqueeVm.fixedOffsetX = capsuleVm.fixedWidth > capsuleVm.width ?
      (capsuleVm.fixedWidth - capsuleVm.width) / 2 : 0;
    capsuleMarqueeVm.fixedIsMarqueeEnabled = false;
    capsuleMarqueeVm.fixedIsExtendTextMarqueeEnabled = false;
    if (isUpdateImmediately) {
      log.showInfo(`adjustFixedWidthForHangingWithExtend(hashcode:${live.hashCode} capsuleMarqueeVm.textWidth ${capsuleMarqueeVm.textWidth}` +
        ` ${capsuleMarqueeVm.fixedTextWidth} ${capsuleMarqueeVm.fixedExtendTextWidth} ${capsuleMarqueeVm.fixedTextSize} ${capsuleMarqueeVm.fixedIsSplicing} ${capsuleMarqueeVm.fixedOffsetX}.`);
      if (capsuleMarqueeVm.fixedTextWidth > 0) {
        capsuleMarqueeVm.updateUIProperty();
      }
    }
  }

  protected adjustFixedWidthForNoHangingHoleType(live: LiveNotification, space: number,
    isUpdateImmediately: boolean): number {
    let text: string = this.getText(live);
    const capsuleVm = this.vmInjector.getCapsuleVm(live);
    const isShowForExtend: boolean = this.isExtendShow(live);
    let extendText: string = isShowForExtend ? this.getText(live, true) : '';
    const capsuleFontSize = this.getCapsuleFontSize(live, false);
    const realTextWidth: number = this.getTextWidthBySize(capsuleFontSize, text);
    const realExtendTextWidth: number = this.getTextWidthBySize(capsuleFontSize, extendText);
    const realTotalTextWidth = realTextWidth + realExtendTextWidth;
    log.showInfo(`adjustFixedWidthForNoHangingHoleType realTextWidth ${realTextWidth} realExtendTextWidth ${realExtendTextWidth}  isShowForExtend ${isShowForExtend}`);
    const realCapsuleWidth: number =
      realTotalTextWidth + this.getCapsuleMarqueeWithoutTextWidth(live, isShowForExtend, realTotalTextWidth);
    const currentWidth: number = capsuleVm.fixedWidth;
    let increasedUseSpace = this.isNeedAdjustWidth(space, capsuleVm.fixedShowType) ?
    this.calculateIncreasedUseSpace(realCapsuleWidth, currentWidth, space, live, isShowForExtend) : 0;
    capsuleVm.fixedWidth = currentWidth + increasedUseSpace;
    this.calculateTextWidthAndSize(live, text, extendText, realTextWidth,
      realExtendTextWidth);
    const capsuleMarqueeVm = this.vmInjector.getCapsuleMarqueeVm(live);
    if (isUpdateImmediately) {
      log.showInfo(`adjustFixedWidthForNoHangingHoleType(hashcode:${live.hashCode} capsuleMarqueeVm.textWidth ${capsuleMarqueeVm.textWidth}` +
        ` ${capsuleMarqueeVm.fixedTextWidth} ${capsuleMarqueeVm.fixedExtendTextWidth} ${capsuleMarqueeVm.fixedTextSize} ${capsuleMarqueeVm.fixedIsSplicing}.`);
      if (capsuleMarqueeVm.fixedTextWidth > 0) {
        capsuleMarqueeVm.updateUIProperty();
      }
    }
    log.showInfo(`adjustFixedWidthForNoHangingHoleType(hashcode:${live.hashCode} space:${space} minWidth:${currentWidth} ` +
      `show type:${capsuleVm.fixedShowType}) fixed width ${capsuleVm.fixedWidth}, increased use space ${increasedUseSpace},` +
      ` isUpdateImmediately ${isUpdateImmediately}, ${realCapsuleWidth} ${capsuleMarqueeVm.fixedTextWidth} ${capsuleMarqueeVm.fixedIsSplicing} ` +
      `capsuleMarqueeVm.fixedOffsetX ${capsuleMarqueeVm.fixedOffsetX}.`);
    return increasedUseSpace;
  }

  private calculateIncreasedUseSpace(realCapsuleWidth: number, currentWidth: number, space: number,
    live: LiveNotification, isShowForExtend: boolean) {

    const expectWidth: number = this.getExpectWidth(live, isShowForExtend, realCapsuleWidth);
    let increasedUseSpace: number = expectWidth - currentWidth;
    increasedUseSpace = increasedUseSpace < 0 ? 0 : increasedUseSpace;
    const capsuleVm = this.vmInjector.getCapsuleVm(live);
    increasedUseSpace = (space >= increasedUseSpace) ? increasedUseSpace :
      (capsuleVm.fixedShowType === CapsuleShowType.RETRACTABLE_ROUND_CAKE ? 0 : space);
    return increasedUseSpace;
  }

  private calculateTextWidthAndSize(live: LiveNotification,
    text: string, extendText: string, realTextWidth: number, realExtendTextWidth: number): void {
    const capsuleVm = this.vmInjector.getCapsuleVm(live);
    const capsuleMarqueeVm = this.vmInjector.getCapsuleMarqueeVm(live);
    const capsuleMarqueeWithoutTextWidth =
      this.getCapsuleMarqueeWithoutTextWidth(live, undefined, realTextWidth + realExtendTextWidth);
    const capsuleFontSize = this.getCapsuleFontSize(live, false);
    if (capsuleVm.fixedWidth <= capsuleMarqueeWithoutTextWidth) {
      log.showInfo(`fixedWidth ${capsuleVm.fixedWidth} is smarller than ${capsuleMarqueeWithoutTextWidth}.`);
      capsuleMarqueeVm.fixedIsSplicing = false;
      capsuleMarqueeVm.fixedTextWidth = 0;
      capsuleMarqueeVm.fixedExtendTextWidth = 0;
      capsuleMarqueeVm.fixedTextSize = capsuleFontSize;
      capsuleMarqueeVm.fixedExtendTextSize = capsuleFontSize;
      capsuleMarqueeVm.fixedOffsetX = 0;
      capsuleMarqueeVm.fixedIsMarqueeEnabled = true;
      capsuleMarqueeVm.fixedIsExtendTextMarqueeEnabled = true;
      return;
    }

    const realTotalTextWidth = realTextWidth + realExtendTextWidth;
    if (extendText.length > 0) {
      const totalTextWidth: number = capsuleVm.fixedWidth - capsuleMarqueeWithoutTextWidth;
      const isTimer = live.capsule?.isTimer() && live.capsule.timer;
      if (realTotalTextWidth > totalTextWidth) {
        capsuleMarqueeVm.fixedIsSplicing = true;
        capsuleMarqueeVm.fixedTextWidth = isTimer ? realTextWidth : totalTextWidth + LiveStyle.CAPSULE_TEXT_MARGIN;
        capsuleMarqueeVm.fixedExtendTextWidth = isTimer ? totalTextWidth - realTextWidth : 0;
        capsuleMarqueeVm.fixedTextSize = capsuleFontSize;
        capsuleMarqueeVm.fixedExtendTextSize = capsuleMarqueeVm.fixedTextSize;
        capsuleMarqueeVm.fixedOffsetX = 0;
        capsuleMarqueeVm.fixedIsMarqueeEnabled = isTimer ? false : true;
        capsuleMarqueeVm.fixedIsExtendTextMarqueeEnabled = true;
      } else {
        capsuleMarqueeVm.fixedIsSplicing = false;
        const freeSpace: number = totalTextWidth - realTotalTextWidth;
        capsuleMarqueeVm.fixedTextWidth = realTextWidth + freeSpace / 2;
        capsuleMarqueeVm.fixedExtendTextWidth = realExtendTextWidth + freeSpace / 2;
        capsuleMarqueeVm.fixedTextSize = capsuleFontSize;
        capsuleMarqueeVm.fixedExtendTextSize = capsuleMarqueeVm.fixedTextSize;
        capsuleMarqueeVm.fixedOffsetX = capsuleVm.fixedWidth > capsuleVm.width ?
          (capsuleVm.fixedWidth - capsuleVm.width) / 2 : 0;
        capsuleMarqueeVm.fixedIsMarqueeEnabled = false;
        capsuleMarqueeVm.fixedIsExtendTextMarqueeEnabled = false;
      }
    } else {
      capsuleMarqueeVm.fixedIsSplicing = false;
      capsuleMarqueeVm.fixedTextWidth = capsuleVm.fixedWidth - capsuleMarqueeWithoutTextWidth;
      capsuleMarqueeVm.fixedExtendTextWidth = 0;
      if (realTotalTextWidth <= capsuleMarqueeVm.fixedTextWidth) {
        capsuleMarqueeVm.fixedTextSize = capsuleFontSize;
        capsuleMarqueeVm.fixedIsMarqueeEnabled = false;
        capsuleMarqueeVm.fixedIsExtendTextMarqueeEnabled = false;
      } else {
        capsuleMarqueeVm.fixedTextSize = capsuleFontSize;
        capsuleMarqueeVm.fixedIsMarqueeEnabled = true;
        capsuleMarqueeVm.fixedIsExtendTextMarqueeEnabled = true;
      }
      capsuleMarqueeVm.fixedExtendTextSize = capsuleMarqueeVm.fixedTextSize;
      capsuleMarqueeVm.fixedOffsetX = capsuleVm.fixedWidth > capsuleVm.width ?
        (capsuleVm.fixedWidth - capsuleVm.width) / 2 : 0;
    }
  }

  /**
   * 获取胶囊除去文本显示外其他元素宽度之和
   * @param live 当前胶囊数据
   * @param isExtend 是否包含扩展文本
   * @returns 除去文本显示外其他元素宽度之和
   */
  protected getCapsuleMarqueeWithoutTextWidth(live: LiveNotification, isExtend?: boolean,
    realTotalLength?: number): number {
    isExtend = isExtend ?? this.isExtendShow(live);
    const capsuleVm = this.vmInjector.getCapsuleVm(live);
    if (capsuleVm.fixedShowType === CapsuleShowType.HANGING_HOLE_DOUBLE_ENDED) {
      if (isExtend) {
        if (this.isShowRightIcon(live)) {
          return DeviceInfoVm.instance.isCustomDevice ? this.hangingLeftCapsuleNonTextWidthCustom :
            this.hangingLeftAndRightCapsuleNonTextWidth;
        }
        return DeviceInfoVm.instance.isCustomDevice ? this.hangingRightCapsuleNonTextWidthCustom :
          this.hangingRightCapsuleNonTextWidth;
      }
      return DeviceInfoVm.instance.isCustomDevice ? this.hangingLeftCapsuleNonTextWidthCustom :
        this.hangingLeftAndRightCapsuleNonTextWidth;
    }

    if (capsuleVm.fixedShowType === CapsuleShowType.HANGING_HOLE) {
      if (isExtend) {
        return DeviceInfoVm.instance.isCustomDevice ? this.hangingCapsuleNonTextWidthWithExtendCustom :
         this.hangingCapsuleNonTextWidthWithExtend;
      }
      return DeviceInfoVm.instance.isCustomDevice ? this.hangingCapsuleNonTextWidthWithoutExtendCustom :
       this.hangingCapsuleNonTextWidthWithoutExtend;
    }
    if (this.isShowRightIcon(live)) {
      return isExtend ? this.doubleIconCapsuleNonTextWidthWithExtend : this.doubleIconCapsuleNonTextWidthWithoutExtend;
    }
    return isExtend ? this.capsuleNonTextWidthWithExtend : this.capsuleNonTextWidthWithoutExtend;
  }

  protected getTextWidthBySize(textSize: Length, text: string): number {
    if (text.length <= 0) {
      return 0;
    }
    const textWidthPx: number = measure.measureText({
      textContent: text,
      fontSize: ArkUIAdapter.vp2px(textSize) + 'px',
      fontWeight: LiveStyle.CAPSULE_FONT_WEIGHT,
      fontFamily: LiveStyle.CAPSULE_FONT_FAMILY,
    })
    return Math.ceil(ArkUIAdapter.px2vp(textWidthPx));
  }

  /**
   * 计算单端挂孔胶囊最短宽度，计算规则：如果胶囊实际占用宽度小于挖孔宽度，则使用胶囊实际宽度，否则使用默认宽度
   * @param live
   * @returns
   */
  private getMinHangHoleWidth(live: LiveNotification): number {
    const minFontSize = this.getCapsuleFontSize(live, true);
    const realWidth = this.getHangingHoleCapsuleRealWidth(live, minFontSize);
    const defaultMinWidth = DeviceInfoVm.instance.isCustomDevice ? LiveStyle.HANGING_HOLE_MIN_CUSTOM_WIDTH :
      LiveStyle.HANGING_HOLE_MIN_WIDTH;
    const minWidth = realWidth < Math.min(this.cutoutVm.width, defaultMinWidth) ? realWidth : defaultMinWidth;
    return minWidth;
  }
}