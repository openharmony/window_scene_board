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

import { ScreenLockStateListener, ScreenLockState, screenLockInnerStateManager } from './ScreenLockInnerStateManager';
import { KeyGuardMode, KeyGuardPage } from '../bean/KeyGuardStatusEnum';
import { KeyguardStatusService } from '../manager/KeyguardStatusService';
import { CacheValue } from './GlobalStatusCache';

export interface DisplayModeChangeListener {
  onDisplayModeChange: (displayMode: number) => void;
}

/**
 * @deprecated
 */
export const NONE_EDIT_MODE: number = 0;
/**
 * @deprecated
 */
export const EDIT_GUIDE_MODE: number = 100;
/**
 * @deprecated
 */
export const EDIT_FULL_MODE: number = 101;
/**
 * @deprecated
 */
export const EDIT_CLOCK_MODE: number = 102;
/**
 * @deprecated
 */
export const EDIT_FORM_MODE_MAIN: number = 103;
/**
 * @deprecated
 */
export const EDIT_FORM_MODE_DETAIL: number = 104;
/**
 * @deprecated
 */
export const BOUNCER_MODE: number = 105;
/**
 * @deprecated
 */
export const EXIT_KEYGUARD: number = 106;
/**
 * @deprecated
 */
export const ENTER_OTHER_APP: number = 107;
/**
 * @deprecated
 */
export const EDIT_CLOCK_DRAG: number = 108;
/**
 * @deprecated
 */
export const EDIT_FORM_DRAG: number = 109;
/**
 * @deprecated
 */
export const ENTER_OTHER_APP_BORDER_SHOW: number = 110;
/**
 * @deprecated
 */
export const ENTER_OTHER_APP_BORDER_HIDE: number = 111;
/**
 * @deprecated
 */
export const NONE_EDIT_MODE_ARRAY: number[] = [NONE_EDIT_MODE, BOUNCER_MODE, EXIT_KEYGUARD];
/**
 * @deprecated
 */
const EDIT_STATE_ARRAY: number[] = [EDIT_GUIDE_MODE, EDIT_FULL_MODE, EDIT_CLOCK_MODE, EDIT_FORM_MODE_MAIN,
  EDIT_FORM_MODE_DETAIL, EDIT_CLOCK_DRAG, EDIT_FORM_DRAG, ENTER_OTHER_APP_BORDER_SHOW, ENTER_OTHER_APP_BORDER_HIDE];
/**
 * @deprecated
 */
const FULL_EDIT_MAP: Map<ScreenLockState, number> = new Map([
  [ScreenLockState.THEME_EDITOR_FULL, EDIT_FULL_MODE],
  [ScreenLockState.THEME_EDITOR_FULL_CLOCK, EDIT_CLOCK_MODE],
  [ScreenLockState.THEME_EDITOR_FULL_FORM, EDIT_FORM_MODE_MAIN],
  [ScreenLockState.THEME_EDITOR_FORM_DETAIL, EDIT_FORM_MODE_DETAIL],
  [ScreenLockState.THEME_EDITOR_CLOCK_DRAG, EDIT_CLOCK_DRAG],
  [ScreenLockState.THEME_EDITOR_FORM_DRAG, EDIT_FORM_DRAG]
]);
/**
 * @deprecated
 */
const FORM_EDIT_ARRAY: number[] = [EDIT_FORM_MODE_MAIN, EDIT_FORM_MODE_DETAIL, EDIT_FORM_DRAG];
/**
 * @deprecated
 */
const OTHER_APP_STATE: number[] = [ENTER_OTHER_APP];
/**
 * @deprecated
 */
export const EDIT_MODE: number[] = [EDIT_CLOCK_MODE, EDIT_FORM_MODE_DETAIL, EDIT_FORM_MODE_MAIN, EDIT_GUIDE_MODE];

/**
 * base view model
 *
 * @since 2024-03-17
 * @deprecated
 */
export class BaseViewModel implements ScreenLockStateListener {
  protected layoutModel: ILayoutModel | undefined;
  protected viewData: BaseViewData | undefined;
  protected eventHandler: BaseEventHandler | undefined;
  protected prohibitModes: number[] = [];
  protected mDisplayModeChangeListener: DisplayModeChangeListener | null = null;
  protected currentMode: number = 0;

  private pageChangeCallBack: Callback<CacheValue> = (val: CacheValue) => {
    this.onPageChanged(val as KeyGuardPage);
  };

  private modeChangeCallback: Callback<CacheValue> = ((val: CacheValue) => {
    if (!this.isSupportMode() && this.viewData) {
      this.viewData.isEnable = false;
    }
    this.onModeChanged(val as KeyGuardMode);
  });

  public constructor() {
    this.initial();
  }

  /**
   * 页面绑定数据 布局数据 事件处理
   * @param viewData
   * @param layoutModel
   * @param eventHandler
   */
  public bindView(viewData: BaseViewData, layoutModel: ILayoutModel, eventHandler: BaseEventHandler): void {
    this.viewData = viewData;
    this.layoutModel = layoutModel;
    this.eventHandler = eventHandler;
  }

  /**
   * 获取布局参数
   * @returns
   */
  public getLayout(): ILayoutModel | undefined {
    return this.layoutModel;
  }

  /**
   * 获取页面数据
   * @returns
   */
  public getViewData(): BaseViewData | undefined {
    return this.viewData;
  }

  /**
   * 获取事件处理器
   * @returns
   */
  public getEventHandler(): BaseEventHandler | undefined {
    return this.eventHandler;
  }

  protected isSupportMode(): boolean {
    if (this.prohibitModes.length === 0) {
      return true;
    }
    for (let mode of this.prohibitModes) {
      if (KeyguardStatusService.isMode(mode)) {
        return false;
      }
    }
    return true;
  }

  public initProhibitModes(): number[] {
    return [];
  }

  public onPageChanged(page: KeyGuardPage): void {
  }

  public onModeChanged(mode: KeyGuardMode): void {
  }

  private initial(): void {
    // 自动注册页面切换 模式切换监听
    KeyguardStatusService.onPageChanged(this.pageChangeCallBack);
    KeyguardStatusService.onModeChanged(this.modeChangeCallback);

    // 初始化不支持的特殊模式
    this.prohibitModes = this.initProhibitModes();
  }

  /**
   * 初始化ViewModel
   *
   * @param displayModeChangeListener 显示模式变化回调
   */
  public initViewModel(displayModeChangeListener: DisplayModeChangeListener): void {
    this.mDisplayModeChangeListener = displayModeChangeListener;
    screenLockInnerStateManager.registerScreenLockState(this);
  }

  /**
   * 销毁ViewModel
   */
  public destroyViewModel(): void {
    this.mDisplayModeChangeListener = null;
    screenLockInnerStateManager.unregisterScreenLockState(this);
    // 自动注册页面切换 模式切换监听
    KeyguardStatusService.onPageChangedUnScribe(this.pageChangeCallBack);
    KeyguardStatusService.onModeChangedUnsubscribe(this.modeChangeCallback);
  }

  public onEnterHost(preState: ScreenLockState, isSaveConfig?: boolean): void {
    this.currentMode = NONE_EDIT_MODE;
  }

  public onEnterThemeEditor(preState: ScreenLockState): void {
    this.currentMode = EDIT_GUIDE_MODE;
  }

  public onEnterFullEditor(preState: ScreenLockState, fullState: ScreenLockState): void {
    this.currentMode = FULL_EDIT_MAP.get(fullState) ?? EDIT_FULL_MODE;
  }

  public onEnterBouncer(preState: ScreenLockState): void {
    this.currentMode = BOUNCER_MODE;
  }

  public onExitKeyguard(): void {
    this.currentMode = EXIT_KEYGUARD;
  }

  public onEnterOtherApp(): void {
    this.currentMode = ENTER_OTHER_APP;
  }

  public onEnterOtherAppBorderShow(): void {
    this.currentMode = ENTER_OTHER_APP_BORDER_SHOW;
  }

  public onEnterOtherAppBorderHide(): void {
    this.currentMode = ENTER_OTHER_APP_BORDER_HIDE;
  }

  public isInEditMode(mode: number = this.currentMode): boolean {
    return EDIT_STATE_ARRAY.includes(mode);
  }

  public isInOtherApp(mode: number = this.currentMode): boolean {
    return OTHER_APP_STATE.includes(mode);
  }

  public isInFormEdit(mode: number = this.currentMode): boolean {
    return FORM_EDIT_ARRAY.includes(mode);
  }
}

/**
 * @deprecated
 */
export class BaseViewData {
  private _isShow: boolean = true;
  private _isEnable: boolean = true;

  public set isShow(value: boolean) {
    this._isShow = value;
  }

  public get isShow(): boolean {
    return this._isShow;
  }

  public set isEnable(value: boolean) {
    this._isEnable = value;
  }

  public get isEnable(): boolean {
    return this._isEnable;
  }
}

/**
 * @deprecated
 */
export interface ILayoutModel {
  size?: SizeOptions;
  offset?: Position;
  opacity?: number;
  padding?: Padding | Length;
  margin?: Margin | Length;
  align?: Alignment;
  visibility?: Visibility;
  layoutWeight?: number | string;
}

/**
 * @deprecated
 */
export enum GestureStage {
  ON_ACTION,
  ON_ACTION_START,
  ON_ACTION_UPDATE,
  ON_ACTION_END,
  ON_ACTION_CANCEL,
}

/**
 * @deprecated
 */
export abstract class BaseEventHandler {
  public layoutModel: ILayoutModel;
  public viewData: BaseViewData;

  public constructor(layoutModel: ILayoutModel, viewData: BaseViewData) {
    this.layoutModel = layoutModel;
    this.viewData = viewData;
  }

  /**
   * 常规事件处理
   * @param event
   */
  public handleEvent(event: BaseEvent | KeyEvent | DragEvent | boolean): void {
    if (event as ClickEvent) {
      this.onClickHandle(event as ClickEvent);
    } else if (event as DragEvent) {
      this.onDragHandle(event as DragEvent);
    } else if (event as TouchEvent) {
      this.onTouchHandle(event as TouchEvent);
    } else if (event as KeyEvent) {
      this.onKeyHandle(event as KeyEvent);
    } else if (typeof event === 'boolean') {
      this.onHoverHandle(event as boolean);
    }
  }

  /**
   * 点击事件处理
   * @param event
   */
  public onClickHandle(event: ClickEvent): void {
  }

  /**
   * 拖拽事件处理
   * @param event
   */
  public onDragHandle(event: DragEvent): void {
  }

  /**
   * 触摸事件处理
   * @param event
   */
  public onTouchHandle(event: TouchEvent): void {
  }

  /**
   * 鼠标点击事件处理
   * @param event
   */
  public onMouseHandle(event: MouseEvent): void {
  }

  /**
   * 鼠标悬浮处理
   * @param isHover
   */
  public onHoverHandle(isHover: boolean): void {
  }

  /**
   * 按键处理
   * @param event
   */
  public onKeyHandle(event: KeyEvent): void {
  }

  /**
   * 点击手势
   * @param event
   * @param stage
   */
  public onTapGesture(event: GestureEvent, stage: GestureStage): void {
  }

  /**
   * 长按手势
   * @param event
   * @param stage
   */
  public onLongPressGesture(event: GestureEvent, stage: GestureStage): void {
  }

  /**
   * 拖动手势
   * @param event
   * @param stage
   */
  public onPanGesture(event: GestureEvent, stage: GestureStage): void {
  }

  /**
   * 捏合手势
   * @param event
   * @param stage
   */
  public onPinGesture(event: GestureEvent, stage: GestureStage): void {
  }

  /**
   * 旋转手势
   * @param event
   * @param stage
   */
  public onRotationGesture(event: GestureEvent, stage: GestureStage): void {
  }

  /**
   * 滑动手势
   */
  public onSwipeGesture(event: GestureEvent, stage: GestureStage): void {
  }
}
