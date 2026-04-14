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
import { baseStateMgr } from '@ohos/systemuiutils';
import { StateType } from '@ohos/systemuiutils';
import type {
  DarkModeState,
  DisplayRotationState,
  DisplaySizeState,
  ImmersiveBaseState
} from '@ohos/systemuiutils';
import type { IState } from '@ohos/systemuiutils';
import { SceneFlag } from '../../../base/common/SceneFlag';

/**
 * banner触控类型
 */
export enum BannerTriggerOper {
  TOUCH = 'touch',
  FINGER = 'finger',
  NULL = 'null'
}

/**
 * 按钮点击位置,0-3
 */
export enum ClickPosition {
  OTHER = 0,
  BANNER = 1,
}

/**
 * banner面板类型
 */
export enum BannerPanelType {
  /**
   * 默认，面板收起状态
   */
  TYPE_NONE,

  /**
   * 普通横幅弹框
   */
  TYPE_HEADS_UP,

  /**
   * 实况列表
   */
  TYPE_LIVE_LIST,

  /**
   * 临时动效胶囊列表
   */
  TYPE_CAPSULE_LIST,

  /**
   * 实况横幅弹框
   */
  TYPE_LIVE_HEADS_UP,
}

/**
 * banner面板外部触摸状态
 */
export class BannerOutsideState implements IState {
  /**
   * 触摸时面板类型
   */
  currentPanelType: BannerPanelType = BannerPanelType.TYPE_NONE;

  /**
   * 触摸坐标
   */
  touchX: number;

  /**
   * 触摸坐标
   */
  touchY: number;

  /**
   * 复写接口IState
   *
   * @returns 状态类型
   */
  getStateType(): StateType {
    return StateType.TYPE_BANNER_OUTSIDE;
  }

  /**
   * 扩展类型，区分触摸面板
   * 复写接口IState
   *
   * @returns 扩展类型
   */
  getExtendType(): number {
    return this.currentPanelType;
  }
}

/**
 * banner面板类型状态
 */
@Observed
export class BannerPanelTypeState implements IState {
  /**
   * banner面板类型
   */
  bannerPanelType: BannerPanelType = BannerPanelType.TYPE_NONE;

  /**
   * banner面板次要类型
   * 主要用于临时胶囊列表，可与其他类型共存
   */
  secondaryPanelType: BannerPanelType = BannerPanelType.TYPE_NONE;

  /**
   * 面板切换时触发场景
   */
  private typeScene?: SceneFlag;

  /**
   * 复写接口IState
   *
   * @returns 状态类型
   */
  getStateType(): StateType {
    return StateType.TYPE_BANNER_PANEL_TYPE;
  }

  /**
   * 设置面板切换时触发场景
   *
   * @param scene 触发场景
   */
  setTypeScene(scene?: SceneFlag): void {
    this.typeScene = scene;
  }

  /**
   * 是否目标触发场景
   *
   * @param scene 目标场景
   * @returns true匹配触发场景
   */
  isTypeScene(scene?: SceneFlag): boolean {
    return this.typeScene === scene;
  }

  /**
   * 当前是否横幅面板
   *
   * @returns true横幅面板
   */
  isPanelHeadsUp(): boolean {
    return this.bannerPanelType === BannerPanelType.TYPE_HEADS_UP;
  }

  /**
   * 当前是否实况横幅
   *
   * @returns true实况面板
   */
  isPanelLiveHeadsUp(): boolean {
    return this.bannerPanelType === BannerPanelType.TYPE_LIVE_HEADS_UP;
  }

  /**
   * 当前是否实况面板
   *
   * @returns true实况面板
   */
  isPanelLiveList(): boolean {
    return this.bannerPanelType === BannerPanelType.TYPE_LIVE_LIST;
  }

  /**
   * 当前临时胶囊列表是否显示
   *
   * @returns true显示胶囊列表
   */
  hasPanelCapsuleList(): boolean {
    return this.secondaryPanelType === BannerPanelType.TYPE_CAPSULE_LIST;
  }
}

/**
 * banner面板样式属性
 */
@Observed
export class BannerStyleState implements IState {
  /**
   * 面板样式类型
   */
  readonly styleType: BannerPanelType;

  /**
   * banner内容宽度，vp
   */
  itemWidth: number = 0;

  /**
   * banner内容容器宽度，vp
   */
  containerWidth: number = 0;

  /**
   * banner内容横向位移，vp
   * 横幅场景
   */
  itemTranX: number = 0;

  /**
   * banner整体竖向位移，vp
   * 横幅场景
   */
  bannerTranY: number = 0;

  /**
   * banner内容容器top间距，vp
   */
  containerMarginTop: number = 0;

  /**
   * banner内容容器bottom间距，vp
   */
  containerMarginBottom: number = 0;

  /**
   * banner内容容器left间距，vp
   */
  containerMarginLeft: number = 0;

  /**
   * banner内容容器right间距，vp
   */
  containerMarginRight: number = 0;

  /**
   * 构造
   *
   * @param styleType 样式类型
   */
  constructor(styleType: BannerPanelType) {
    this.styleType = styleType;
  }

  /**
   * 复写接口IState
   *
   * @returns 状态类型
   */
  getStateType(): StateType {
    return StateType.TYPE_BANNER_STYLE;
  }

  /**
   * 扩展类型，区分横幅、实况面板
   * 复写接口IState
   *
   * @returns 扩展类型
   */
  getExtendType(): number {
    return this.styleType;
  }
}

/**
 * 横幅、实况窗口状态管理
 */
@Observed
export class BannerState {
  /**
   * banner面板类型
   */
  bannerPanelType: BannerPanelTypeState = new BannerPanelTypeState();

  /**
   * 横幅状态样式
   */
  headsUpStyle: BannerStyleState = new BannerStyleState(BannerPanelType.TYPE_HEADS_UP);

  /**
   * 实况列表状态样式
   */
  liveListStyle: BannerStyleState = new BannerStyleState(BannerPanelType.TYPE_LIVE_LIST);

  /**
   * 深色模式状态
   */
  darkModeState: DarkModeState = baseStateMgr.getBaseState(StateType.TYPE_DARK_MODE) as DarkModeState;

  /**
   * 沉浸式状态
   */
  immersiveState: ImmersiveBaseState = baseStateMgr.getBaseState(StateType.TYPE_IMMERSIVE) as ImmersiveBaseState;

  /**
   * 屏幕旋转角度状态
   */
  displayRotationState: DisplayRotationState = baseStateMgr
    .getBaseState(StateType.TYPE_DISPLAY_ROTATION) as DisplayRotationState;

  /**
   * 屏幕宽高大小状态
   */
  displaySizeState: DisplaySizeState = baseStateMgr.getBaseState(StateType.TYPE_DISPLAY_SIZE) as DisplaySizeState;
}

const DEFAULT_ICON_TRAN_X = 12;
const DEFAULT_BANNER_HEIGHT = 66;
const DEFAULT_BANNER_WIDTH = 360;

export class BannerDeformState {
  /**
   * 横幅通知是否形变为悬浮窗
   */
  bannerToFloating: boolean = false;

  /**
   * 使用替换图标
   */
  useFakerIcon: boolean = false;

  /**
   * 横幅通知高度
   */
  bannerHeight: number = DEFAULT_BANNER_HEIGHT;

  /**
   * 横幅通知宽度
   */
  bannerWidth: number = DEFAULT_BANNER_WIDTH;

  /**
   * 横幅通知图标大小比例
   */
  bannerIconScale: number = 1;

  /**
   * 横幅通知横向位移
   */
  bannerTranX: number = 0;

  /**
   * 横幅通知纵向位移
   */
  bannerTranY: number = 0;

  /**
   * 横幅通知图标横向位移
   */
  bannerIconTranX: number = DEFAULT_ICON_TRAN_X;

  /**
   * 横幅通知图标纵向位移
   */
  bannerIconTranY: number = 0;

  /**
   * 横幅通知内容不透明度
   */
  bannerTextOpacity: number = 1;

  /**
   * 横幅通知蒙版不透明度
   */
  bannerMaskingOpacity: number = 0;

  /**
   * 横幅通知蒙版可见性
   */
  bannerMaskingVisibility: boolean = false;

  /**
   * 动效终点
   */
  endTranY: number = -1;

  /**
   * 横幅通知整体不透明度
   */
  bannerOpacity: number = 1;

  public equal(bannerDeformState: BannerDeformState): boolean {
    let stateFlag = this.useFakerIcon === bannerDeformState.useFakerIcon &&
      this.bannerToFloating === bannerDeformState.bannerToFloating;
    let sizeFlag = this.bannerHeight === bannerDeformState.bannerHeight &&
      this.bannerWidth === bannerDeformState.bannerWidth &&
      this.bannerIconScale === bannerDeformState.bannerIconScale;
    let translateFlag = this.bannerTranX === bannerDeformState.bannerTranX &&
      this.bannerTranY === bannerDeformState.bannerTranY &&
      this.bannerIconTranX === bannerDeformState.bannerIconTranX &&
      this.bannerIconTranY === bannerDeformState.bannerIconTranY;
    let opacityFlag = this.bannerTextOpacity === bannerDeformState.bannerTextOpacity &&
      this.bannerMaskingOpacity === bannerDeformState.bannerMaskingOpacity &&
      this.bannerMaskingVisibility === bannerDeformState.bannerMaskingVisibility &&
      this.bannerOpacity === bannerDeformState.bannerOpacity;

    return stateFlag && sizeFlag && translateFlag && opacityFlag;
  }

  public update(bannerDeformState: BannerDeformState): void {
    if (this.equal(bannerDeformState)) {
      return;
    }
    this.useFakerIcon = bannerDeformState.useFakerIcon;
    this.bannerToFloating = bannerDeformState.bannerToFloating;
    this.bannerHeight = bannerDeformState.bannerHeight;
    this.bannerWidth = bannerDeformState.bannerWidth;
    this.bannerIconScale = bannerDeformState.bannerIconScale;
    this.bannerTranX = bannerDeformState.bannerTranX;
    this.bannerTranY = bannerDeformState.bannerTranY;
    this.bannerIconTranX = bannerDeformState.bannerIconTranX;
    this.bannerIconTranY = bannerDeformState.bannerIconTranY;
    this.bannerTextOpacity = bannerDeformState.bannerTextOpacity;
    this.bannerMaskingOpacity = bannerDeformState.bannerMaskingOpacity;
    this.bannerMaskingVisibility = bannerDeformState.bannerMaskingVisibility;
    this.bannerOpacity = bannerDeformState.bannerOpacity;
  }

  public reset(): void {
    this.useFakerIcon = false;
    this.bannerToFloating = false;
    this.bannerHeight = 66;
    this.bannerWidth = 360;
    this.bannerIconScale = 1;
    this.bannerTranX = 0;
    this.bannerTranY = 0;
    this.bannerIconTranX = 12;
    this.bannerIconTranY = 0;
    this.bannerTextOpacity = 1;
    this.bannerMaskingOpacity = 0;
    this.bannerMaskingVisibility = false;
    this.bannerOpacity = 1;
  }
}