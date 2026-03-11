/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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
import { Log, LogDomain, LogHelper, ObjUtil, SingletonHelper } from '@ohos/basicutils';

const TAG = 'OutSideWindowManager';
const logAA: LogHelper = LogHelper.getLogHelper(LogDomain.AA, TAG);

/**
 * 负一屏进出常量
 */
export class NegativeScreenConstants {
  /**
   * 进出速度阈值
   */
  static readonly THRESHOLD_SLIDING_SPEED = 780;

  /**
   * 负一屏时桌面模糊度
   */
  static readonly DESKTOP_INSIDE_BLUR_SHOW = 1;

  /**
   * 负一屏时桌面蒙版透明度
   */
  static readonly DESKTOP_INSIDE_OPACITY_SHOW = 0.2;

  /**
   * 负一屏时桌面缩放大小
   */
  static readonly DESKTOP_INSIDE_SCALE_SHOW = 0.94;

  /**
   * 负一屏时桌面缩放中心
   */
  static readonly DESKTOP_INSIDE_SCALE_CENTER = '50%';

  /**
   * 负一屏进出滑动最小值
   */
  static readonly PAN_GESTURE_MIN_DISTANCE = 5;

  /**
   * 负一屏页面消失时长
   */
  static readonly DURATION_AUTO_DISAPPEAR = 400;
}

/**
 * 全搜进出常量
 */
export class GlobalSearchConstants {
  /**
   * 进出速度阈值
   */
  static readonly THRESHOLD_SLIDING_SPEED = 1.5;

  /**
   * 全搜时桌面模糊度
   */
  static readonly DESKTOP_INSIDE_BLUR_SHOW = 1;

  /**
   * 负全搜时桌面蒙版透明度
   */
  static readonly DESKTOP_INSIDE_OPACITY_SHOW = 0.3;

  /**
   * 负全搜时桌面下滑最大距离
   */
  static readonly DESKTOP_INSIDE_DISTANCE_MAX_PX = 400;

  /**
   * 负全搜时判断进入有效的距离阈值
   */
  static readonly PAN_THRESHOLD_DISTANCE_VP = 100;

  /**
   * 全搜进出滑动最小值
   */
  static readonly PAN_GESTURE_MIN_DISTANCE = 6;

  /**
   * 全搜页面向下滑动阻尼系数
   */
  static readonly PAN_GESTURE_DAMPING = 1.848;

  /**
   * Maximum distance threshold for the desktop blur degree change
   */
  static readonly PAN_GESTURE_DESKTOP_MAX_DISTANCE = 400;

  /**
   * 低端机桌面进入全搜桌面元素渐隐最大距离
   */
  static readonly PAN_GESTURE_DESKTOP_MAX_DISTANCE_DISABLE = 100;

  /**
   * 全搜页面向下滑透明度变化最大距离
   */
  static readonly GLOBAL_SEARCH_ALPHA_MAX_DISTANCE = 100;

  /**
   * The start offset on the Y axis of the Global search
   */
  static readonly GLOBAL_SEARCH_START_TRANSLATE_Y_OFFSET = -65;

  /**
   * Sliding maximum distance with hand of the Global search
   */
  static readonly GLOBAL_SEARCH_GESTURE_MAX_DISTANCE = 700;

  /**
   * 全搜页面消失时长
   */
  static readonly DURATION_AUTO_DISAPPEAR = 400;

  /**
   * 低端机全搜曲线参数
   */
  static readonly Spring_Motion_Search_Blur = 0.281;

  /**
   * 低端机全搜曲线参数
   */
  static readonly Spring_Motion_Search_Blur_Damping = 1;
}

export enum GlobalSearchStatus {
  HIDE, //隐藏
  WAKING, //滑动唤醒过程
  SHOW, //前台显示
  UNFOCUSED, //显示后失去焦点
  BACK_OUT, // 手动下拉后上滑不显示全搜页面
  FOCUSED, // HiSearch for focus
}

export interface NegativePageChangeListener {
  /**
   * 负一屏是否显示
   *
   * @param isShow 是否显示
   */
  onNegativePageStatueChange(isShow: boolean): void;

  /**
   * 负一屏位置变化
   *
   * @param offset
   */
  onNegativeOffsetChange(offset: number): void;

  /**
   * 设置负一屏页面的可见性
   * @param isVisible true: 可见
   */
  setNegativeScreenVisible(isVisible: boolean): void;

  /**
   * 手动隐藏负一屏页面
   */
  hideNegativeScreen(): void;
}

export interface DesktopPageChangeListener {
  /**
   * DeskTop translateY with Global Search state change
   * @param translateY： DeskTop translateY
   */
  onGlobalSearchTranslateYChange(translateY: number): void;

  /**
   * 是否正在隐藏全搜事件
   * @param isHidingGlobalSearch 是否正在隐藏全搜
   */
  onIsHidingGlobalSearchChange(isHidingGlobalSearch: boolean): void;

  /**
   * Desktop enable changed
   *
   * @param enabled whether desktop is enabled
   */
  onDesktopEnableChanged(enabled: boolean, tag?: string): void;
}

export interface DesktopParamsListener {
  /**
   * 修改桌面缩放值
   *
   * @param scale 桌面缩放值
   */
  onDesktopAnimateScaleChanged(scale: number, msg: string): void;

  /**
   * 获取桌面缩放值
   *
   * @returns 桌面缩放值
   */
  getAnimateScale(): number;
}

export interface GlobalSearchPageChangeListener {
  /**
   * 全搜页面显示状态变化
   *
   * @param status 状态
   */
  onGlobalSearchStatusChange(status: GlobalSearchStatus): void;

  /**
   * 手动隐藏全搜页面
   *
   * @param isHideNegativeScreen 是否隐藏负一屏
   */
  hideGlobalSearch(isHideNegativeScreen?: boolean): void;

  /**
   * 离手时全搜页面进出位置和透明度变化
   *
   * @param translateY
   * @param opacity
   */
  onGlobalSearchTranslateChange(translateY: number, opacity: number): void;

  /**
   * 跟手时全搜页面进出位置变化
   *
   * @param translateY
   * @param opacity
   */
  onGlobalSearchTranslateYChange(translateY: number): void;

  /**
   * 是否正在隐藏全搜事件
   * @param isHidingGlobalSearch 是否正在隐藏全搜
   */
  onIsHidingGlobalSearchChange(isHidingGlobalSearch: boolean): void;

  /**
   * 跟手时全搜页面透明度变化
   *
   * @param translateY
   * @param opacity
   */
  onGlobalSearchOpacityChange(opacity: number): void;

}

export interface ProgressChangeListener {
  /**
   * progress of enter negative screen or global search
   * @param progress 0~1: enter progress
   */
  onProgressChange(progress: number): void;
}

export interface IntelligentCardUseAnimationCallBack {
  /**
   * 负一卡片是否显示完整
   *
   * @param isShow 是否显示
   */
  isIntelligentCardShowFull(info: string): boolean;
}

class OutSideWindowManager {
  private isShowNegativePage: boolean = false;
  private isDesktopEnabled: boolean = true;
  private globalSearchStatus: GlobalSearchStatus = GlobalSearchStatus.HIDE;
  private negativePageChangeListeners?: Map<string, NegativePageChangeListener>;
  private globalSearchPageChangeListeners?: Map<string, GlobalSearchPageChangeListener>;
  private negativeProgressListeners?: Map<string, ProgressChangeListener>;
  private globalSearchProgressListeners?: Map<string, ProgressChangeListener>;
  private desktopPageChangeListeners?: Map<string, DesktopPageChangeListener>;
  private desktopParamListeners?: Map<string, DesktopParamsListener>;
  private intelligentCardUseAnimationCallBack?: IntelligentCardUseAnimationCallBack;
  private globalSearchAnimationCount: number = 0;
  private negativeAnimationTime: number = 0;
  private isNegativeAnimateEnd: boolean = true;
  private intoNegativeTime: number = 0;
  private negativeOffset: number = 0;
  private intoSearchTime: number = 0;
  private isExitNegativeScreen : boolean = true;

  registerNegativePageChangeListener(key: string, listener: NegativePageChangeListener): void {
    if (ObjUtil.isInvalid(this.negativePageChangeListeners)) {
      this.negativePageChangeListeners = new Map();
    }
    this.negativePageChangeListeners.set(key, listener);
  }

  registerGlobalSearchPageChangeListener(key: string, listener: GlobalSearchPageChangeListener): void {
    if (ObjUtil.isInvalid(this.globalSearchPageChangeListeners)) {
      this.globalSearchPageChangeListeners = new Map();
    }
    this.globalSearchPageChangeListeners.set(key, listener);
  }

  unRegisterGlobalSearchPageChangeListener(key: string): void {
    if (this.globalSearchPageChangeListeners.get(key)) {
      this.globalSearchPageChangeListeners.delete(key);
    }
  }

  registerNegativeProgressListener(key: string, listener: ProgressChangeListener): void {
    if (ObjUtil.isInvalid(this.negativeProgressListeners)) {
      this.negativeProgressListeners = new Map();
    }
    this.negativeProgressListeners.set(key, listener);
  }

  registerGlobalSearchProgressListener(key: string, listener: ProgressChangeListener): void {
    if (ObjUtil.isInvalid(this.globalSearchProgressListeners)) {
      this.globalSearchProgressListeners = new Map();
    }
    this.globalSearchProgressListeners.set(key, listener);
  }

  unRegisterGlobalSearchProgressListener(key: string): void {
    if (this.globalSearchProgressListeners.has(key)) {
      this.globalSearchProgressListeners.delete(key);
    }
  }

  registerDesktopPageChangeListener(key: string, listener: DesktopPageChangeListener): void {
    if (ObjUtil.isInvalid(this.desktopPageChangeListeners)) {
      this.desktopPageChangeListeners = new Map();
    }
    this.desktopPageChangeListeners.set(key, listener);
  }

  registerDesktopParamListener(key: string, listener: DesktopParamsListener): void {
    if (ObjUtil.isInvalid(this.desktopParamListeners)) {
      this.desktopParamListeners = new Map();
    }
    this.desktopParamListeners.set(key, listener);
  }

  setDesktopAnimateScale(scale: number, msg: string): void {
    if (ObjUtil.isInvalid(this.desktopParamListeners)) {
      return;
    }
    logAA.showInfo(`setDesktopAnimateScale %{public}s`, scale);
    this.desktopParamListeners.forEach((listener: DesktopParamsListener) => {
      listener?.onDesktopAnimateScaleChanged(scale, msg);
    });
  }

  getDesktopAnimateScale(): number {
    let scale: number = 1;
    this.desktopParamListeners.forEach((listener: DesktopParamsListener) => {
      scale = listener?.getAnimateScale();
    });
    return scale;
  }

  setNegativeOffset(offset: number): void {
    logAA.showInfo(`setNegativeOffset ${offset}`);
    this.negativeOffset = offset;
    if (ObjUtil.isInvalid(this.negativePageChangeListeners)) {
      return;
    }
    this.negativePageChangeListeners.forEach((listener: NegativePageChangeListener) => {
      listener?.onNegativeOffsetChange(offset);
    });
  }

  getNegativeOffset(): number {
    return this.negativeOffset;
  }

  setNegativeDesktopProgress(progress: number): void {
    logAA.showInfo(`setNegativeDesktopOffset ${progress}`);
    if (ObjUtil.isInvalid(this.negativeProgressListeners)) {
      return;
    }
    this.negativeProgressListeners.forEach((listener: ProgressChangeListener) => {
      listener?.onProgressChange(progress);
    });
  }

  setShowNegative(isShow: boolean): void {
    this.isShowNegativePage = isShow;
    if (ObjUtil.isInvalid(this.negativePageChangeListeners)) {
      return;
    }
    logAA.showInfo(`setShowNegative isShow:${isShow}, listenerSize: ${this.negativePageChangeListeners.size}`);
    this.negativePageChangeListeners.forEach((listener: NegativePageChangeListener) => {
      listener?.onNegativePageStatueChange(isShow);
    });
  }

  setNegativeScreenVisible(isVisible: boolean): void {
    logAA.showInfo(`setNegativeScreenVisible isVisible: ${isVisible}`);
    this.negativePageChangeListeners.forEach((listener: NegativePageChangeListener) => {
      listener?.setNegativeScreenVisible(isVisible);
    });
    this.setDesktopEnabled(!isVisible, TAG);
  }

  hideNegativeScreen(): void {
    logAA.showInfo('hideNegativeScreen');
    this.negativePageChangeListeners.forEach((listener: NegativePageChangeListener) => {
      listener?.hideNegativeScreen();
    });
  }

  isShowNegative(): boolean {
    return this.isShowNegativePage;
  }

  setGlobalSearchTranslate(translateY: number, opacity: number): void {
    logAA.showInfo(TAG, `setGlobalSearchTranslate opacity: ${opacity}, translateY: ${translateY}`);
    if (ObjUtil.isInvalid(this.globalSearchPageChangeListeners)) {
      return;
    }
    this.globalSearchPageChangeListeners.forEach((listener: GlobalSearchPageChangeListener) => {
      listener?.onGlobalSearchTranslateChange(translateY, opacity);
    });
  }

  setGlobalSearchTranslateY(translateY: number): void {
    logAA.showInfo(TAG, `setGlobalSearchTranslateY translateY: ${translateY}`);
    if (ObjUtil.isInvalid(this.globalSearchPageChangeListeners)) {
      return;
    }
    this.globalSearchPageChangeListeners.forEach((listener: GlobalSearchPageChangeListener) => {
      listener?.onGlobalSearchTranslateYChange(translateY);
    });
  }

  setIsHidingGlobalSearch(isHidingGlobalSearch: boolean): void {
    logAA.showInfo(TAG, `setIsHidingGlobalSearch isHidingGlobalSearch: ${isHidingGlobalSearch}`);
    if (ObjUtil.isInvalid(this.desktopPageChangeListeners)) {
      logAA.showInfo(TAG, 'setIsHidingGlobalSearch failed, no listeners');
      return;
    }
    this.desktopPageChangeListeners.forEach((listener: DesktopPageChangeListener) => {
      listener?.onIsHidingGlobalSearchChange(isHidingGlobalSearch);
    });
  }

  setGlobalSearchOpacity(opacity: number): void {
    logAA.showInfo(TAG, `setGlobalSearchOpacity opacity: ${opacity}`);
    if (ObjUtil.isInvalid(this.globalSearchPageChangeListeners)) {
      return;
    }
    this.globalSearchPageChangeListeners.forEach((listener: GlobalSearchPageChangeListener) => {
      listener?.onGlobalSearchOpacityChange(opacity);
    });
  }

  setGlobalSearchDesktopProgress(progress: number): void {
    logAA.showInfo(TAG, `setGlobalSearchDesktopProgress ${progress}`);
    if (ObjUtil.isInvalid(this.globalSearchProgressListeners)) {
      return;
    }
    this.globalSearchProgressListeners.forEach((listener: ProgressChangeListener) => {
      listener?.onProgressChange(progress);
    });
  }

  setGlobalSearchDesktopTranslateY(translateY: number): void {
    logAA.showInfo(TAG, `setGlobalSearchDesktopTranslateY ${translateY}`);
    if (ObjUtil.isInvalid(this.desktopPageChangeListeners)) {
      return;
    }
    this.desktopPageChangeListeners.forEach((listener: DesktopPageChangeListener) => {
      listener?.onGlobalSearchTranslateYChange(translateY);
    });
  }

  setGlobalSearchStatus(status: GlobalSearchStatus): void {
    logAA.showInfo(TAG, `setGlobalSearchStatus status： ${status}`);
    this.globalSearchStatus = status;
    if (ObjUtil.isInvalid(this.globalSearchPageChangeListeners)) {
      return;
    }
    this.globalSearchPageChangeListeners.forEach((listener: GlobalSearchPageChangeListener) => {
      listener?.onGlobalSearchStatusChange(status);
    });
  }

  hideGlobalSearch(isHideNegativeScreen?: boolean): void {
    logAA.showInfo(TAG, `hideGlobalSearchWithAnim this.getGlobalSearchStatus: ${this.globalSearchStatus}`);
    this.globalSearchPageChangeListeners.forEach((listener: GlobalSearchPageChangeListener) => {
      listener?.hideGlobalSearch(isHideNegativeScreen);
    });
  }

  hideIntelligent(): void {
    logAA.showInfo(TAG, `hideIntelligent this.getGlobalSearchStatus: ${this.globalSearchStatus}`);
    this.negativePageChangeListeners.forEach((listener: NegativePageChangeListener) => {
      listener?.hideNegativeScreen();
    });
  }

  showGlobalSearchDirectly(): void {
    this.setGlobalSearchTranslate(0, 1);
    this.setGlobalSearchDesktopTranslateY(-GlobalSearchConstants.GLOBAL_SEARCH_START_TRANSLATE_Y_OFFSET);
    this.setGlobalSearchDesktopProgress(1);
  }

  hideGlobalSearchDirectly(): void {
    this.setGlobalSearchTranslate(GlobalSearchConstants.GLOBAL_SEARCH_START_TRANSLATE_Y_OFFSET, 0);
    this.setGlobalSearchDesktopTranslateY(0);
    this.setGlobalSearchDesktopProgress(0);
  }

  getGlobalSearchStatus(): GlobalSearchStatus {
    return this.globalSearchStatus;
  }

  isShowGlobalSearch(): boolean {
    logAA.showInfo(`globalSearchStatus: ${sOutSideWindowMgr.getGlobalSearchStatus()}`);
    return sOutSideWindowMgr.getGlobalSearchStatus() === GlobalSearchStatus.SHOW ||
      sOutSideWindowMgr.getGlobalSearchStatus() === GlobalSearchStatus.FOCUSED ||
      sOutSideWindowMgr.getGlobalSearchStatus() === GlobalSearchStatus.UNFOCUSED;
  }

  setDesktopEnabled(enabled: boolean, tag?: string): void {
    this.isDesktopEnabled = enabled;
    logAA.showInfo(TAG, `setDesktopEnabled ${enabled} from ${tag}`);
    if (ObjUtil.isInvalid(this.desktopPageChangeListeners)) {
      return;
    }
    this.desktopPageChangeListeners.forEach((listener: DesktopPageChangeListener) => {
      listener?.onDesktopEnableChanged(enabled, tag);
    });
  }

  setIntelligentCardUseAnimationCallBack(callback: IntelligentCardUseAnimationCallBack): void {
    this.intelligentCardUseAnimationCallBack = callback;
  }

  getDesktopEnabled(): boolean {
    return this.isDesktopEnabled;
  }

  getNegativeAnimationTime(): number {
    return this.negativeAnimationTime;
  }

  updateNegativeAnimationTime(): void {
    this.negativeAnimationTime = new Date().getTime();
  }

  getGlobalSearchAnimationCount(): number {
    return this.globalSearchAnimationCount;
  }

  addGlobalSearchAnimationCount(): void {
    this.globalSearchAnimationCount++;
  }

  clearGlobalSearchAnimationCount(): void {
    this.globalSearchAnimationCount = 0;
  }

  isIntelligentCardShowFull(info: string): boolean | undefined {
    return this.intelligentCardUseAnimationCallBack?.isIntelligentCardShowFull(info);
  }

  setNegativeAnimateEnd(isNegativeAnimateEnd: boolean): void {
    this.isNegativeAnimateEnd = isNegativeAnimateEnd;
  }

  getNegativeAnimateEnd(): boolean {
    return this.isNegativeAnimateEnd;
  }

  setIntoNegativeTime(): void {
    this.intoNegativeTime = new Date().getTime();
  }

  getIntoNegativeTime(): number {
    return this.intoNegativeTime;
  }

  setIntoSearchTime(): void {
    this.intoSearchTime = new Date().getTime();
  }

  getIntoSearchTime(): number {
    return this.intoSearchTime;
  }

  setIsExitNegativeScreen(exitNegativeScreen:boolean):void {
    this.isExitNegativeScreen = exitNegativeScreen;
  }

  getIsExitNegativeScreen():boolean {
    return this.isExitNegativeScreen;
  }
}

let sOutSideWindowMgr = SingletonHelper.getInstance(OutSideWindowManager, TAG);

export default sOutSideWindowMgr as OutSideWindowManager;
