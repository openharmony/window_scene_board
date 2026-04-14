/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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

import { display } from '@kit.ArkUI';
import { ArrayUtils, CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { RTLUtil } from '@ohos/componenthelper';
import { LiveViewCapsuleStyle } from '../../common/LiveViewCapsuleStyle';
import type { LiveCapsuleData } from '../../data/capsule/LiveCapsuleData';
import type { LiveViewData } from '../../data/LiveViewData';
import measure from '@ohos.measure';
import { CapsuleType, LiveViewCommonConstants } from '../../common/LiveConstants';
import type { LiveTimerData } from '../../data/extend/LiveTimerData';
import type { LiveProgressData } from '../../data/extend/LiveProgressData';
import { NumberUtils } from '../../parse/utils/NumberUtils';
import { DeviceHelper } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { LayoutUtils, XTLayoutType } from '@ohos/systemuiutils/src/main/ets/base/LayoutUtils';
import { DisplayAdapter } from '../../../adapter/DisplayAdapter';

const TAG = 'CapsuleListState';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

/**
 * 预留/清除动效胶囊数据的场景
 */
export enum AnimDataScene {
  /**
   * 无动效场景
   */
  SCENE_NONE = 0,

  /**
   * 隐藏胶囊场景
   */
  SCENE_HIDE_CAPSULE = 0x01,

  /**
   * 应用退出到胶囊场景
   */
  SCENE_EXIT_TO_CAPSULE = 0x02,

  /**
   * 面板展开收起动效状态
   */
  SCENE_LIVE_BANNER = 0x04,

  /**
   * 外屏沉浸态收起到胶囊场景
   */
  SCENE_IMME_LIVE = 0x08
}

/**
 * 胶囊列表隐藏场景
 */
export enum CapsuleHideScene {
  /**
   * 无隐藏场景，显示
   */
  SCENE_NONE = 0,

  /**
   * 实况面板显示场景，隐藏胶囊，不占位
   */
  SCENE_SHOW_LIVE_LIST_PANEL = 0x01,

  /**
   * 动效替代胶囊显示场景，隐藏胶囊，占位
   */
  SCENE_OVERLAY_ANIM = 0x02,

  /**
   * 状态栏将胶囊隐藏的场景
   */
  SCENE_HIDE_BY_STATUS_BAR = 0x04
}

/**
 * 胶囊显示宽度切换监听
 */
export type OnCapsuleWidthChangeListener = (oldWidth: number, newWidth: number) => void;

/**
 * 胶囊列表数据状态管理
 */
@Observed
export class CapsuleListState {
  /**
   * 胶囊隐藏场景，默认显示
   */
  capsuleHideScene: number = CapsuleHideScene.SCENE_NONE;
  /**
   * 强提醒胶囊队列
   */
  remindCapsuleQueue: LiveCapsuleData[] = [];
  /**
   * 当前顶部显示胶囊数据
   */
  topCapsule?: LiveViewData;
  /**
   * 当前顶部显示胶囊数据
   */
  shadowCapsule?: LiveViewData;
  /**
   * 当前进行强提醒动效的实况数据
   */
  remindCapsule?: LiveViewData;
  /**
   * 动效场景，显示内容胶囊数据
   */
  animContentCapsule?: LiveViewData;
  /**
   * 动效场景，显示内容胶囊切换时的数据
   */
  animOverlayCapsule?: LiveViewData;
  /**
   * 动效场景，显示阴影胶囊数据
   */
  animShadowCapsule?: LiveViewData;
  /**
   * 是否多胶囊状态
   */
  isMulShow: boolean = false;
  /**
   * 当前是否宽屏状态
   */
  isWideScreen: boolean = false;
  /**
   * 是否支持胶囊拓展布局
   */
  isExtendLayoutSupport: boolean = false;
  /**
   * 是否展示胶囊扩展文本
   */
  isContentDisplayed: boolean = true;
  /**
   * 是否胶囊扩展文本组件独立显示
   */
  isShowExtendNoSplicing: boolean = true;
  /**
   * 主副文本中间间距
   */
  capsuleTextSpace: number = LiveViewCapsuleStyle.CAPSULE_TEXT_SPACE;
  /**
   * 文本左右间距
   */
  capsuleTextMargin: number = LiveViewCapsuleStyle.CAPSULE_TEXT_MARGIN;
  /**
   * 胶囊主文本默认宽度
   */
  capsuleMainTextWidth: number = LiveViewCapsuleStyle.CAPSULE_MAIN_TEXT_WIDTH;
  /**
   * 扩展文本默认宽度
   */
  capsuleExtendTextWidth: number = LiveViewCapsuleStyle.CAPSULE_EXTEND_TEXT_WIDTH;
  /**
   * 文字大小
   */
  capsuleTextSize: number = LiveViewCapsuleStyle.TEXT_FONT_SIZE;
  /**
   * 上次胶囊主文本默认宽度
   */
  lastCapsuleMainTextWidth: number = LiveViewCapsuleStyle.CAPSULE_MAIN_TEXT_WIDTH;
  /**
   * 上次扩展文本默认宽度
   */
  lastCapsuleExtendTextWidth: number = LiveViewCapsuleStyle.CAPSULE_EXTEND_TEXT_WIDTH;
  /**
   * 上次文字大小
   */
  lastCapsuleTextSize: number = LiveViewCapsuleStyle.TEXT_FONT_SIZE;
  /**
   * 胶囊高度
   */
  capsuleHeight: number = LiveViewCapsuleStyle.CAPSULE_HEIGHT;
  /**
   * icon宽度
   */
  capsuleIconWidth: number = LiveViewCapsuleStyle.CAPSULE_IMAGE_WIDTH;
  /**
   * icon左边距
   */
  capsuleIconLeftMargin: number = LiveViewCapsuleStyle.CAPSULE_ICON_LEFT_MARGIN;
  /**
   * 是否拼接主副文本
   */
  isSplicing: boolean = false;
  /**
   * 隐藏胶囊颜色
   */
  public shadowCapsuleBgColor: string = LiveViewCapsuleStyle.CAPSULE_SHADOW_COLOR_BLACK;
  /**
   * 当前存在的动效场景
   */
  private animScene: number = AnimDataScene.SCENE_NONE;
  /**
   * 胶囊宽度
   */
  private capsuleWidth: number = 0;
  /**
   * 胶囊宽度切换监听器
   */
  private widthListeners: Set<OnCapsuleWidthChangeListener> = new Set();
  /**
   * 主文本
   */
  private mainText: string = '';
  /**
   * 扩展文本内容
   */
  private extendText: string = '';

  /**
   * 注册胶囊宽度监听器
   *
   * @param listener 监听器
   */
  registerCapsuleWidthChangeListener(listener: OnCapsuleWidthChangeListener): void {
    this.widthListeners.add(listener);
  }

  /**
   * 注销胶囊宽度监听器
   *
   * @param listener 监听器
   */
  unregisterCapsuleWidthChangeListener(listener: OnCapsuleWidthChangeListener): void {
    this.widthListeners.delete(listener);
  }

  /**
   * 是否副文本独立显示
   * @returns
   */
  checkShowExtendNoSplicing(): void {
    this.isShowExtendNoSplicing = this.isExtendLayoutSupport && this.isContentDisplayed &&
      !CommonUtils.isEmpty(this.extendText) && this.capsuleExtendTextWidth !== 0;
    log.showInfo('checkShowExtendNoSplicing: ' + this.isShowExtendNoSplicing);
  }

  /**
   * 设置当前顶部显示胶囊
   *
   * @param liveData 胶囊
   */
  setTopCapsule(liveData?: LiveViewData): void {
    log.showInfo('setTopCapsule: ' + liveData?.hashCode);
    this.topCapsule = liveData;
    if (liveData) {
      this.checkCapsuleWidthChange();
      // 缓存上一次胶囊宽度及字体大小
      this.lastCapsuleMainTextWidth = this.capsuleMainTextWidth;
      this.lastCapsuleExtendTextWidth = this.capsuleExtendTextWidth;
      this.lastCapsuleTextSize = this.capsuleTextSize;
      this.refreshCapsule(liveData?.capsule);
    }
  }

  refreshCapsule(capsuleData?: LiveCapsuleData): void {
    if (!CommonUtils.isInvalid(capsuleData)) {
      if (capsuleData.isDataType(CapsuleType.TYPE_TIMER)) {
        this.mainText = this.getTimeCapsuleMainText(capsuleData.typeData as LiveTimerData);
      } else if (capsuleData.isDataType(CapsuleType.TYPE_PROGRESS)) {
        this.mainText = this.getProgressCapsuleMainText(capsuleData.typeData as LiveProgressData);
      } else {
        this.mainText = capsuleData.title;
      }
    }
    this.extendText = capsuleData?.extend ?? '';
    this.isContentDisplayed = capsuleData?.isContentDisplayed ?? true;
    log.showInfo('refreshCapsuleView: ' + capsuleData?.hashCode);
    this.refreshCapsuleView();
  }

  refreshTopCapsule(capsuleData?: LiveCapsuleData): void {
    if (capsuleData?.hashCode !== this.getCurrentTopCapsule()?.hashCode) {
      return;
    }
    log.showInfo('refreshTopCapsule: ' + capsuleData?.hashCode);
    this.checkCapsuleWidthChange();
    this.refreshCapsule(capsuleData);
  }

  /**
   * 设置当前阴影胶囊
   *
   * @param liveData 实况实况数据
   */
  setShadowCapsule(liveData?: LiveViewData): void {
    this.shadowCapsule = liveData;
  }

  /**
   * 设置当前强提醒的实况
   *
   * @param liveData 实况实况数据
   */
  setRemindCapsule(liveData?: LiveViewData): void {
    this.remindCapsule = liveData;
  }

  /**
   * 得到格式化的时间胶囊文本
   * @param timeData 时间数据
   * @returns 时间胶囊主文本数据
   */
  getTimeCapsuleMainText(timeData?: LiveTimerData): string {
    if (CommonUtils.isInvalid(timeData)) {
      return '';
    }
    return LiveViewCommonConstants.formatDate(timeData?.initialTime, new Date(), timeData?.isCountDown);
  }

  /**
   * 得到格式化的进度胶囊文本
   * @param timeData 时间数据
   * @returns 进度胶囊主文本数据
   */
  getProgressCapsuleMainText(progressData?: LiveProgressData): string {
    if (CommonUtils.isInvalid(progressData)) {
      return '';
    }
    return NumberUtils.getPercentage(progressData?.currentValue, progressData?.maxValue, progressData?.isPercentage ?? false);
  }

  /**
   * 设置是否宽屏
   *
   * @param isWidestScreen true宽屏
   */
  setWideScreen(isWideScreen: boolean): void {
    if (isWideScreen !== this.isWideScreen) {
      this.isWideScreen = isWideScreen;
      this.checkExtendLayout();
    }
  }

  /**
   * 检查是否支持胶囊拓展布局
   */
  checkExtendLayout(): void {
    let isExtendLayoutSupport = this.isWideScreen;
    // XT设备在G态且屏幕0°且非镜像场景，不支持拓展布局
    if (LayoutUtils.isMatchXTFoldMode(XTLayoutType.G) && !RTLUtil.isRTL() &&
      DisplayAdapter.getDefaultDisplaySync().rotation === display.Orientation.PORTRAIT) {
      isExtendLayoutSupport = false;
      log.showInfo('device not support extend layout');
    }

    if (this.isExtendLayoutSupport === isExtendLayoutSupport) {
      return;
    }

    this.isExtendLayoutSupport = isExtendLayoutSupport;
    // 执行宽度变化动效
    this.checkCapsuleWidthChange();
    log.showInfo('refreshCapsuleView isExtendLayoutSupport: ' + isExtendLayoutSupport);
    this.refreshCapsuleView();
  }

  /**
   * 设置是否多胶囊状态
   *
   * @param isMulShow true多胶囊状态
   */
  setMultiShow(isMulShow: boolean): void {
    if (isMulShow !== this.isMulShow) {
      this.isMulShow = isMulShow;
      // 执行胶囊变化动效
      this.checkCapsuleWidthChange();
      log.showInfo('refreshCapsuleView isMulShow: ' + isMulShow);
      this.refreshCapsuleView();
    }
  }

  /**
   * 当前是否维持多胶囊状态
   *
   * @returns true 多胶囊状态
   */
  isCurrentMultiShow(): boolean {
    // 动效时维持状态
    return this.isMulShow;
  }

  /**
   * 获取当前胶囊宽度
   *
   * @param capsule 目标胶囊数据
   * @param isMultiCapsule 是否多胶囊场景
   * @returns 宽度 vp
   */
  getCapsuleWidth(capsule?: LiveCapsuleData, isMultiCapsule?: boolean): number {
    // 胶囊宽度，无目标胶囊则以顶部显示胶囊为准
    if (CommonUtils.isInvalid(capsule)) {
      capsule = this.getCurrentTopCapsule()?.capsule;
    }
    if (CommonUtils.isInvalid(capsule)) {
      // 默认宽度
      return LiveViewCapsuleStyle.CAPSULE_BORDER_WIDTH;
    }
    let isContentDisplayed = capsule?.isContentDisplayed ?? true;
    // 宽屏且存在扩展字段，则使用大宽度
    if (this.isExtendLayoutSupport && isContentDisplayed && !CommonUtils.isEmpty(capsule?.extend)) {
      return LiveViewCapsuleStyle.CAPSULE_EXTEND_BORDER_WIDTH;
    }
    // 多胶囊场景，使用小宽度
    if (isMultiCapsule || this.isCurrentMultiShow()) {
      return LiveViewCapsuleStyle.CAPSULE_STACK_BORDER_WIDTH;
    }
    // 默认宽度
    return LiveViewCapsuleStyle.CAPSULE_BORDER_WIDTH;
  }

  /**
   * 添加胶囊隐藏场景
   *
   * @param scene 场景
   */
  addCapsuleHideScene(scene: CapsuleHideScene): void {
    log.showInfo(`Add capsule hide scene: ${scene}`);
    this.capsuleHideScene |= scene;
  }

  /**
   * 清除胶囊隐藏场景
   *
   * @param scene 场景
   */
  clearCapsuleHideScene(scene: CapsuleHideScene): void {
    log.showInfo(`clear capsule hide scene: ${scene}`);
    this.capsuleHideScene &= ~scene;
  }

  /**
   * 当前胶囊列表组件是否允许占位显示
   *
   * @returns true显示
   */
  isCapsuleListShow(): boolean {
    // 非实况面板隐藏场景则认为胶囊可占位显示
    return !this.isCapsuleHideScene(CapsuleHideScene.SCENE_SHOW_LIVE_LIST_PANEL);
  }

  /**
   * 当前胶囊列表是否目标隐藏场景
   *
   * @param hideScene 隐藏场景
   * @returns true目标隐藏场景
   */
  isCapsuleHideScene(hideScene: CapsuleHideScene): boolean {
    return (this.capsuleHideScene & hideScene) !== 0;
  }

  /**
   * 添加强提醒胶囊到队列
   *
   * @param capsule 胶囊
   */
  addRemindCapsule(capsule: LiveCapsuleData): void {
    this.remindCapsuleQueue.push(capsule);
  }

  /**
   * 设置动效数据集
   *
   * @param scene 动效场景
   * @param capsuleList 动效数据集
   */
  setAnimCapsuleData(scene: AnimDataScene, capsuleList?: Array<LiveViewData>): void {
    // 是否清除数据场景
    let isClearData = ArrayUtils.isEmpty(capsuleList);
    if (isClearData) {
      // 清除场景后，无动效场景，则清除动效数据
      this.animScene &= ~scene;
      if (this.animScene === AnimDataScene.SCENE_NONE) {
        this.animContentCapsule = undefined;
        this.animShadowCapsule = undefined;
      }
    } else {
      // 预留动效数据场景，刷新动效数据
      this.animScene |= scene;
      let contentCapsule: LiveViewData | undefined = undefined;
      let shadowCapsule = capsuleList?.find((data) => {
        if (CommonUtils.isInvalid(contentCapsule) && data?.capsule?.isCapsuleShowContent()) {
          contentCapsule = data;
        }
        return data?.capsule?.isCapsuleShowShadow() ?? false;
      });
      this.animContentCapsule = contentCapsule;
      this.animShadowCapsule = shadowCapsule;
    }
  }

  hasAnimScene(animScene: AnimDataScene): boolean {
    return (this.animScene & animScene) !== 0;
  }

  /**
   * 是否有动效胶囊数据
   *
   * @param animScene 目标动效场景
   * @returns true动效场景
   */
  hasAnimCapsule(animScene?: AnimDataScene): boolean {
    // 带有目标动效场景时，需判断当前是否包含目标动效场景
    if (!CommonUtils.isInvalid(animScene) && (this.animScene & animScene) === 0) {
      return false;
    }
    return !CommonUtils.isInvalid(this.animContentCapsule);
  }

  /**
   * 获取阴影胶囊需要显示的背景色
   *
   * @returns 颜色
   */
  public getShadowCapsuleBgColor(): string {
    if (this.shadowCapsule?.capsule?.isRedShadow) {
      return LiveViewCapsuleStyle.CAPSULE_SHADOW_COLOR_RED;
    }
    return this.shadowCapsuleBgColor;
  }

  /**
   * 重置胶囊样式
   */
  private restore(): void {
    this.capsuleTextSpace = LiveViewCapsuleStyle.CAPSULE_TEXT_SPACE;
    this.capsuleTextMargin = LiveViewCapsuleStyle.CAPSULE_TEXT_MARGIN;
    this.capsuleMainTextWidth = this.getCapsuleMainTextWidth();
    this.capsuleExtendTextWidth = this.getCapsuleExtendTextWidth();
    this.capsuleTextSize = LiveViewCapsuleStyle.TEXT_FONT_SIZE;
    this.isSplicing = false;
  }

  /**
   * 是否是小外屏折叠态
   */
  isOuterHomeFolded(): boolean {
    return false;
  }

  /**
   * 小外屏获取胶囊主文本区域宽度
   */
  getCapsuleMainTextWidth(): number {
    return this.isOuterHomeFolded() ? LiveViewCapsuleStyle.OUTER_CAPSULE_MAIN_TEXT_WIDTH :
    LiveViewCapsuleStyle.CAPSULE_MAIN_TEXT_WIDTH;
  }

  /**
   * 小外屏获取扩展文本默认宽度
   */
  getCapsuleExtendTextWidth(): number {
    return this.isOuterHomeFolded() ? LiveViewCapsuleStyle.OUTER_CAPSULE_EXTEND_TEXT_WIDTH :
    LiveViewCapsuleStyle.CAPSULE_EXTEND_TEXT_WIDTH;
  }

  /**
   * 小外屏获取多胶囊主文本区域宽度
   */
  getCapsuleMainTextWidthMul(): number {
    return this.isOuterHomeFolded() ? LiveViewCapsuleStyle.OUTER_CAPSULE_MAIN_TEXT_WIDTH_MUL :
    LiveViewCapsuleStyle.CAPSULE_MAIN_TEXT_WIDTH_MUL;
  }

  /**
   * 胶囊内布局刷新
   */
  private refreshCapsuleView(): void {
    if (CommonUtils.isEmpty(this.mainText)) {
      return;
    }
    this.restore();

    // 宽屏扩展文字宽度要变化
    if (this.isExtendLayoutSupport && this.isContentDisplayed && !CommonUtils.isEmpty(this.extendText)) {
      this.calcTextWidth();
    } else {
      // 胶囊文本边距要变化
      if (this.isMulShow) {
        this.capsuleTextMargin = LiveViewCapsuleStyle.CAPSULE_TEXT_MARGIN_MUL;
        this.capsuleMainTextWidth = this.getCapsuleMainTextWidthMul();
      }

      let textWidth: number = px2vp(this.measureCapsuleTextWidth(this.mainText));
      if (textWidth > this.capsuleMainTextWidth) {
        this.capsuleTextSize = LiveViewCapsuleStyle.TEXT_SMALL_FONT_SIZE;
      }
    }

    this.checkShowExtendNoSplicing();
  }

  /**
   * 扩展胶囊态根据主文本副文本宽度计算实际宽度
   */
  private calcTextWidth(): void {
    let mainTextWidth: number = px2vp(this.measureCapsuleTextWidth(this.mainText));
    let extendTextWidth: number = px2vp(this.measureCapsuleTextWidth(this.extendText));
    let totalTextWidth = mainTextWidth + extendTextWidth;
    // 胶囊文本可展示宽度
    let totalWidth = this.getCapsuleMainTextWidth() + this.getCapsuleExtendTextWidth();

    if (totalTextWidth > totalWidth) {
      this.capsuleTextSize = LiveViewCapsuleStyle.TEXT_SMALL_FONT_SIZE;
      mainTextWidth = px2vp(this.measureCapsuleTextWidth(this.mainText));
      extendTextWidth = px2vp(this.measureCapsuleTextWidth(this.extendText));
      totalTextWidth = mainTextWidth + extendTextWidth;
    }

    let isTotalOver: boolean = totalTextWidth > totalWidth;

    if (isTotalOver) {
      this.capsuleMainTextWidth = totalWidth + LiveViewCapsuleStyle.CAPSULE_TEXT_SPACE;
      this.capsuleExtendTextWidth = 0;
      this.capsuleTextSpace = 0;
      this.isSplicing = true;
    } else {
      if (mainTextWidth > LiveViewCapsuleStyle.CAPSULE_MAIN_TEXT_WIDTH ||
        extendTextWidth > LiveViewCapsuleStyle.CAPSULE_EXTEND_TEXT_WIDTH) {
        let diffWidth = (totalWidth - totalTextWidth) / 2;
        this.capsuleMainTextWidth = mainTextWidth + diffWidth;
        this.capsuleExtendTextWidth = extendTextWidth + diffWidth;
      }
    }
  }

  private measureCapsuleTextWidth(content: string): number {
    return measure.measureText({
      textContent: content,
      fontSize: this.capsuleTextSize + 'vp',
      fontWeight: LiveViewCapsuleStyle.FONT_WEIGHT,
      fontFamily: LiveViewCapsuleStyle.FONT_FAMILY,
    });
  }

  /**
   * 获取当前顶部显示胶囊
   *
   * @returns 顶部胶囊
   */
  public getCurrentTopCapsule(): LiveViewData | undefined {
    // 优先使用原始显示数据
    if (!CommonUtils.isInvalid(this.topCapsule)) {
      return this.topCapsule;
    }

    // 动效场景，取动效数据
    return this.animContentCapsule ?? this.animShadowCapsule;
  }

  /**
   * 检测胶囊宽度是否变化
   */
  private checkCapsuleWidthChange(): void {
    let oldWidth = this.capsuleWidth;
    this.capsuleWidth = this.getCapsuleWidth();
    if (oldWidth === this.capsuleWidth) {
      return;
    }
    this.widthListeners.forEach((listener) => {
      listener?.(oldWidth, this.capsuleWidth);
    });
  }

  /**
   * 获取获取文字大小
   * @param data  胶囊数据
   * @returns 返回该胶囊文字大小
   */
  getCapsuleTextSize(data: LiveCapsuleData): number {
    if (this.isOuterHomeFolded()) {
      return this.topCapsule?.capsule === data ? this.capsuleTextSize : this.lastCapsuleTextSize;
    } else {
      return this.capsuleTextSize;
    }
  }
}