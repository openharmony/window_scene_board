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

import { Logger, LogDomain } from '@ohos/basicutils';
import { EvtBus } from '@ohos/frameworkwrapper';
import {

  ClockStaticStateType,
  ISlBaseStateChangeListener,
  ISlState,
  ISlStateChangeListener,
  OneMirrorStaticStateType,
  ScreenBp,
  SizeBpSplice,
  SlBindStateType,
  SlMainStateType,
  SlStaticStateType,
  SlSubStateType,
  slUiStateMgr,
  slWallpaperMgr,
  SLWallpaperType,
  SLWallpaperVisibleScene,
  StateChange,
  WProperty
} from '@ohos/screenlockcommon';
import { LimitSet, WidgetStyleStateV2 } from '@ohos/screenlockcommon/Index';
import {
  BaseObj,
  IBaseState,
  IBaseStateChangeListener,
  IStateTag,
  SlCardStaticStPt,
  SlStateBaseMgr,
  SlStateId,
  SlStateProperty,
  StateModeId,
  StateType,
  V2StateChange,
} from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import {
  FingerprintState,
  immersiveKgMgr,
  ImmersiveState,
  ImmersiveType,
  ImmersiveTypeScene
} from '@ohos/systemuicommon';
import { IImmComVm } from '../../../common/interface/IImmComVm';
import { IImmersiveNtfVmInjector } from '../../../common/interface/IImmersiveNtfVmInjector';
import { ISolidVisualControl } from '../../../common/interface/ISolidVisualControl';
import { IImmersiveState, immersiveStateMgr } from '../../../common/manager/ImmersiveStateManager';

// V2状态标示参数
export interface V2StateUnique extends IStateTag {
  stateId: SlStateId;
}

// V2状态属性
type V2Property = SlStateProperty | WProperty;

const TAG = 'BaseVmStyleMgr';
const log: Logger = Logger.getLogHelper(LogDomain.KG);

// 状态模式默认排序，纯色 > 禁用提亮 > AOD > 强提醒 > 深色背景 > 浅色背景 > 默认
const ST_MODE_ORDER: StateModeId[] = [
  StateModeId.SOLID,
  StateModeId.DIS_BRIGHT,
  StateModeId.AOD,
  StateModeId.REMIND,
  StateModeId.LIVE_FOLD,
  StateModeId.DARK,
  StateModeId.LIGHT,
  StateModeId.DEFAULT,
];

/**
 * 业务多样式状态管理基类
 */
export abstract class BaseVmStyleMgr {
  /**
   * 业务注入器
   */
  protected readonly vmInjector: IImmersiveNtfVmInjector;

  /**
   * 沉浸状态
   */
  protected readonly immersiveState: ImmersiveState = immersiveKgMgr.getImmersiveDisplayState();

  /**
   * 状态模式类型
   */
  protected stateModeId: StateModeId = StateModeId.DARK;

  /**
   * 事件注册统一管理器
   */
  protected readonly eventMgr = EvtBus.createEventManager();

  /**
   * V2状态拼接key
   *
   * @param stateType 标识
   * @param stateId 标识
   * @returns 拼接标识
   */
  protected getV2Key = (stateType: StateType, stateId: string): string => {
    return `${stateType}_${stateId}`;
  };

  /**
   * 同时满足状态模式集
   */
  protected readonly stModeSet: LimitSet<StateModeId> = new LimitSet();

  /**
   * 状态回调是否已绑定
   */
  private hasBindStateChange: boolean = false;

  /**
   * V2状态唯一标示映射关系
   */
  private readonly v2UniqueMap: Map<string, V2StateUnique> = new Map();

  /**
   * 锁屏V1状态切换监听器
   */
  private readonly onSlV1StateListener: ISlStateChangeListener = {
    onSlStateChange: (mainType, subType): void => {
      this.onSlV1StateChange(mainType, subType);
    }
  };

  /**
   * 锁屏V1监听状态集
   */
  private readonly slV1StateListeners: Map<SlMainStateType, ISlStateChangeListener> = new Map();

  /**
   * 锁屏V1状态切换刷新函数集
   */
  private readonly slV1StateChange: Map<SlMainStateType, Map<SlSubStateType, StateChange>> = new Map();

  /**
   * 锁屏V2状态切换监听器
   */
  private readonly onSlV2StateListener: ISlBaseStateChangeListener = {
    listenerName: 'BaseVmStyleMgr_v2_listener',
    onStateChange: (stateType, stateId, property) => {
      this.onSlV2StateChange(stateType, stateId, property);
    }
  };

  /**
   * 子状态V2状态切换监听器
   */
  private readonly onItemV2StateListener: IBaseStateChangeListener = {
    listenerName: 'BaseVmStyleMgr_item_v2_listener',
    onStateChange: (stateType, stateId, property) => {
      this.onItemV2StateChange(stateType, stateId, property);
    }
  };

  /**
   * 锁屏V2监听状态集
   */
  private readonly slV2StateListeners: Map<V2StateUnique, IBaseStateChangeListener> = new Map();

  /**
   * 锁屏V2状态切换刷新函数集
   */
  private readonly slV2StateChange: Map<V2StateUnique | undefined, Map<V2Property, V2StateChange>> = new Map();

  /**
   * 子状态V2状态集
   * IStateTag key -> IBaseState
   */
  private readonly itemV2States: Map<string, IBaseState> = new Map();

  /**
   * 子状态V2状态切换刷新函数集
   * IBaseState -> property -> 回调
   */
  private readonly itemV2StateChange: Map<IBaseState, Map<string, V2StateChange>> = new Map();

  /**
   * 沉浸状态切换监听
   */
  private onImmersiveStateChange = (state?: IImmersiveState): void => {
    this.refreshImmersiveState(state?.getImmersiveStateType());
  };

  /**
   * 构造时绑定V1状态切换函数
   */
  private bindV1StateChange(): void {
    this.getV1StateListenerTypes()?.forEach((mainType) => {
      this.slV1StateListeners.set(mainType, this.onSlV1StateListener);
      let changeMap = this.getV1StateChange(mainType);
      if (changeMap) {
        this.slV1StateChange.set(mainType, changeMap);
      }
    });
  }

  /**
   * 构造时绑定V2状态切换函数
   */
  private bindV2StateChange(): void {
    this.getV2StateListenerTypes()?.forEach((unique) => {
      let v2Key = this.getV2Key(unique.stateType, unique.stateId);
      let oldUnique = this.v2UniqueMap.get(v2Key);
      if (!oldUnique) {
        oldUnique = unique;
        this.v2UniqueMap.set(v2Key, unique);
      }
      this.slV2StateListeners.set(oldUnique, this.onSlV2StateListener);
      let changeMap = this.getV2StateChange(oldUnique);
      if (changeMap) {
        this.slV2StateChange.set(oldUnique, changeMap);
      }
    });
  }

  constructor(vmInjector: IImmersiveNtfVmInjector) {
    this.vmInjector = vmInjector;
  }

  /**
   * 初始化
   */
  init(): void {
    // 回调绑定
    if (!this.hasBindStateChange) {
      this.hasBindStateChange = true;
      this.bindV1StateChange();
      this.bindV2StateChange();
    }
    // 纯色控制器初始化
    this.getSolidVisualControl()?.solidInit();
    // 初始化刷新状态
    this.initRefreshState();
    // V1状态监听注册
    this.slV1StateListeners.forEach((listener, mainType) => {
      slUiStateMgr.registerSlStateChangeListener(listener, mainType);
    });
    // V2状态监听注册
    this.slV2StateListeners.forEach((listener, unique) => {
      SlStateBaseMgr.getMgr(this.vmInjector?.getStateMgr())?.registerStateListener(listener, unique);
    });
    // 沉浸态切换监听注册
    immersiveStateMgr.registerOnImmersiveStateChangeListener(this.onImmersiveStateChange);
  }

  /**
   * 销毁
   */
  destroy(): void {
    // 纯色控制器注销
    this.getSolidVisualControl()?.solidDestroy();
    // 清空状态模式管理
    this.stModeSet.clear();
    // V1状态监听注销
    this.slV1StateListeners.forEach((listener, mainType) => {
      slUiStateMgr.unregisterSlStateChangeListener(listener, mainType);
    });
    // V2状态监听注销
    this.slV2StateListeners.forEach((listener, unique) => {
      SlStateBaseMgr.getMgr(this.vmInjector?.getStateMgr())?.unregisterStateListener(listener, unique);
    });
    // 沉浸态切换监听注销
    immersiveStateMgr.unregisterOnImmersiveStateChangeListener(this.onImmersiveStateChange);
    // 事件注册统一注销
    this.eventMgr.offAll();
  }

  /**
   * 沉浸态状态
   *
   * @returns 沉浸状态
   */
  getImmState(): ImmersiveState {
    return this.immersiveState;
  }

  /**
   * 指纹状态
   *
   * @returns 指纹状态
   */
  getFingerprintState(): FingerprintState {
    return immersiveKgMgr.getFingerprintState();
  }

  /**
   * 是否低指纹位
   *
   * @returns true低指纹
   */
  isLowFinger(): boolean {
    return this.getFingerprintState()?.isLowPosRecognition();
  }

  /**
   * 进入沉浸态前状态
   *
   * @returns 沉浸状态
   */
  getBeforeImmState(): ImmersiveState {
    return immersiveKgMgr.getBeforeImmersiveState();
  }

  /**
   * 设置沉浸状态默认值
   */
  setDefaultImmState(): void {
    immersiveKgMgr.setDefaultImmersiveType();
  }

  /**
   * 切换沉浸状态
   *
   * @param nextType 切换状态
   * @param scene 切换场景
   * @param isForceSendEvent 是否强制发送切换事件
   */
  switchImmState(nextType: ImmersiveType, scene?: ImmersiveTypeScene, isForceSendEvent: boolean = false): void {
    log.showInfo(TAG, `switchImmState type: ${nextType}, scene: ${scene}, send: ${isForceSendEvent}`);
    immersiveStateMgr.switchImmersiveState(nextType, isForceSendEvent, scene);
  }

  /**
   * 退出沉浸大卡态
   *
   * @param isAnim 是否动效过渡
   * @param isBackToCapsule 是否返回到胶囊态
   */
  exitImmState(isAnim: boolean = false, isBackToCapsule: boolean = false): void {
    log.showInfo(TAG, `exitImmState anim: ${isAnim}, cap: ${isBackToCapsule}`);
    immersiveStateMgr.exitImmersiveState(isAnim, isBackToCapsule);
  }

  /**
   * 动态设置小外屏默认进沉浸态（记忆能力）
   *
   * @param isDefaultImm true默认进沉浸态
   */
  public setOuterDefaultEnterImm(isDefaultImm: boolean): void {
    immersiveKgMgr.setOuterDefaultImmState(isDefaultImm);
  }

  /**
   * 判断小外屏状态
   *
   * @returns true小外屏
   */
  public isOuterScreen(): boolean {
    return this.getScreenBp()?.bpSplice === SizeBpSplice.SM;
  }

  /**
   * 是否AOD状态
   *
   * @returns 是否AOD状态
   */
  public isAOD(): boolean {
    let slOneMirrorSt = this.getV1State(SlMainStateType.SL_ONE_MIRROR_STATIC_STATE);
    return slOneMirrorSt?.getSlState(OneMirrorStaticStateType.PT_AOD_STATE) as boolean ?? false;
  }

  /**
   * 是否需要检测默认进入沉浸态
   *
   * @returns true检测默认进入沉浸态
   */
  public isCheckDefaultImm(): boolean {
    let slOneMirrorSt = this.getV1State(SlMainStateType.SL_ONE_MIRROR_STATIC_STATE);
    return slOneMirrorSt?.getSlState(OneMirrorStaticStateType.IS_DESKTOP_TO_SL) as boolean ?? false;
  }

  /**
   * 检测默认进沉浸态已完成
   */
  public checkDefaultImmComplete(): void {
    let slOneMirrorSt = this.getV1State(SlMainStateType.SL_ONE_MIRROR_STATIC_STATE);
    slOneMirrorSt?.setSlState(OneMirrorStaticStateType.IS_DESKTOP_TO_SL, false);
  }

  /**
   * 是否首次开机用户解锁状态
   *
   * @returns true 已解锁
   */
  public isOsAccountUnlocked(): boolean {
    let comBindSt = this.getV1State(SlMainStateType.SL_BIND_STATE);
    let isUnlocked = comBindSt?.getSlState(SlBindStateType.OS_ACCOUNT_UNLOCK_STATE) as boolean ?? false;
    return isUnlocked;
  }

  /**
   * 赋值当前显示沉浸大卡的标识
   *
   * @param groupKey 分组标识
   */
  public setCurImmData(groupKey?: string): void {
    // 统一由沉浸模块通用能力进行分发，避免状态不统一
    this.getImmComVm()?.setCurImmData(groupKey);
  }

  /**
   * 目标数据当前是否沉浸态显示
   *
   * @param groupKey 目标数据标识
   * @returns true沉浸态显示
   */
  public isCurImmCard(groupKey?: string): boolean {
    if (!groupKey) {
      return false;
    }
    // 非沉浸态
    if (!this.immersiveState.isShowCard()) {
      return false;
    }
    let curGroupKey = this.getCurImmCard();
    return curGroupKey === groupKey;
  }

  /**
   * 当前沉浸态数据标识
   *
   * @returns 标识
   */
  public getCurImmCard(): string | undefined {
    let cardSt = this.getV2State({ stateType: StateType.STATIC, stateId: SlStateId.SL_CARD_STATE });
    let curGroupKey = cardSt?.getStateValue(SlCardStaticStPt.PT_GROUP_KEY_OF_SHOWING) as string;
    return curGroupKey;
  }

  /**
   * 沉浸模块通用业务管理器
   *
   * @returns 通用业务
   */
  public getImmComVm(): IImmComVm | undefined {
    return this.vmInjector?.getImmComVm();
  }

  /**
   * V1状态需要监听的类型集
   *
   * @returns 类型集
   */
  protected abstract getV1StateListenerTypes(): SlMainStateType[];

  /**
   * V1状态切换回调设置
   *
   * @param mainType 状态标示
   * @returns 属性-回调映射集
   */
  protected abstract getV1StateChange(mainType: SlMainStateType): Map<SlSubStateType, StateChange> | undefined;

  /**
   * V2状态需要监听的类型集
   *
   * @returns 类型集
   */
  protected abstract getV2StateListenerTypes(): V2StateUnique[];

  /**
   * V2状态切换回调设置
   *
   * @param unique 状态标示
   * @param changeMap 属性-回调映射集
   */
  protected abstract getV2StateChange(unique: V2StateUnique): Map<V2Property, V2StateChange> | undefined;

  /**
   * 沉浸状态切换回调
   *
   * @param immType 当前沉浸状态
   */
  protected abstract onImmersiveTypeChange(immType: ImmersiveType): void;

  /**
   * 各业务纯色模式控制器
   *
   * @returns 纯色模式控制器
   */
  protected getSolidVisualControl(): ISolidVisualControl | undefined {
    return undefined;
  }

  /**
   * 刷新纯色模式配置样式
   *
   * @param rootCfgStyle 根配置样式
   */
  protected updateSolidCfgStyle(rootCfgStyle?: WidgetStyleStateV2): void {
    // 未开启纯色模式，不涉及
    if (!this.getSolidVisualControl()?.isSolidEnable()) {
      return;
    }
    let solidStyle = rootCfgStyle?.getChildState(StateModeId.SOLID);
    // 刷新纯色模式样式
    this.refreshSolidStyle(solidStyle);
  }

  /**
   * 各业务状态模式优先级
   *
   * @returns 优先级
   */
  protected getStModeOrder(): StateModeId[] {
    // 默认优先级
    return ST_MODE_ORDER;
  }

  /**
   * 加入状态模式
   *
   * @param id 模式ID
   */
  protected addStModeId(id: StateModeId): void {
    this.stModeSet.add(id);
  }

  /**
   * 移除状态模式
   *
   * @param id 模式ID
   */
  protected removeStModeId(id: StateModeId): void {
    this.stModeSet.delete(id);
  }

  /**
   * 对应模式下样式状态
   *
   * @param rootStyle 根样式状态
   * @returns 对应模式下样式
   */
  protected getStateModeStyle(rootStyle?: WidgetStyleStateV2): WidgetStyleStateV2 | undefined {
    let modeStyle = rootStyle?.getChildState(this.stateModeId);
    // 无值时取默认，无默认时取root
    return (modeStyle ?? rootStyle?.getChildState(StateModeId.DEFAULT)) ?? rootStyle;
  }

  /**
   * 样式属性赋值
   *
   * @param pt 属性标识
   * @param tarStyle 赋值样式
   * @param rootCfgStyle 配置样式
   * @returns 链式
   */
  protected setStyleProperty(pt: WProperty, tarStyle?: WidgetStyleStateV2, rootCfgStyle?: WidgetStyleStateV2):
    BaseVmStyleMgr {
    let value = this.getStyleModeValue(pt, rootCfgStyle);
    // null按配置undefined处理
    tarStyle?.setStateValue(pt, value === null ? undefined : value);
    return this;
  }

  /**
   * 初始化时刷新状态
   */
  protected initRefreshState(): void {
    // 默认类型常驻
    this.addStModeId(StateModeId.DEFAULT);
    // 同时添加默认类型
    this.addStModeId(this.stateModeId);
    // 纯色模式开启校验
    if (this.getSolidVisualControl()?.isSolidEnable()) {
      this.addStModeId(StateModeId.SOLID);
    }
    // 禁用提亮模式校验
    if (this.getSolidVisualControl()?.isDisableBright()) {
      this.addStModeId(StateModeId.DIS_BRIGHT);
    }
    // V1状态初始化回调
    this.slV1StateChange.forEach((subMap, mainType) => {
      subMap.forEach((stateChange, subType) => {
        this.onSlV1StateChange(mainType, subType);
      });
    });
    // V2状态初始化回调
    this.slV2StateChange.forEach((subMap, unique) => {
      subMap.forEach((stateChange, property) => {
        if (unique) {
          this.onSlV2StateChange(unique.stateType, unique.stateId, property);
        }
      });
    });
    // 初始化沉浸状态
    this.refreshImmersiveState(this.immersiveState.immersiveType);
  }

  /**
   * 取值V1状态实例
   *
   * @param mainType 状态类型
   * @returns 状态实例
   */
  protected getV1State(mainType: SlMainStateType): ISlState | undefined {
    return slUiStateMgr.getSlState(mainType);
  }

  /**
   * 取值V2状态实例
   *
   * @param unique 标识
   * @returns 状态实例
   */
  protected getV2State(unique: V2StateUnique): IBaseState | undefined {
    return SlStateBaseMgr.getMgr(this.vmInjector?.getStateMgr())?.getState(unique.stateType, unique.stateId);
  }

  /**
   * 取值屏幕断点
   *
   * @returns 屏幕断点
   */
  protected getScreenBp(): ScreenBp | undefined {
    let staticSt = this.getV1State(SlMainStateType.SL_STATIC_STATE);
    return staticSt?.getSlState(SlStaticStateType.SCREEN_BP) as ScreenBp;
  }

  /**
   * 时钟收起样式占用高度
   *
   * @param isNoSign true取不含签名的高度
   * @returns 时钟高度
   */
  protected getClockHeight(isNoSign: boolean = false): number {
    let staticSt = this.getV1State(SlMainStateType.SL_STATIC_STATE);
    let stType = isNoSign ? SlStaticStateType.CLOCK_NO_SIGN_SHOW_REGION : SlStaticStateType.CLOCK_COLLAPSE_SHOW_REGION;
    let clockRegion = staticSt?.getSlState(stType) as Rectangle;
    return (clockRegion?.height as number) ?? 0;
  }

  /**
   * 时钟是否可见，不可见时为三方主题
   *
   * @returns true时钟可见
   */
  protected isClockVisible(): boolean {
    let clockSt = this.getV1State(SlMainStateType.SL_CLOCK_WG_STATIC_STATE);
    return (clockSt?.getSlState(ClockStaticStateType.CLOCK_VISIBLE_STATE) as boolean) ?? true;
  }

  /**
   * 注册V2子状态属性切换监听器
   *
   * @param v2State 子状态
   * @param property 属性标识
   * @param listener 监听器
   */
  protected registerItemV2StListener(v2State: IBaseState, property: string, listener: V2StateChange): void {
    let key = this.getV2Key(v2State?.getStateType(), v2State?.getStateId());
    this.itemV2States.set(key, v2State);
    let listeners = this.itemV2StateChange.get(v2State);
    if (!listeners) {
      listeners = new Map();
      this.itemV2StateChange.set(v2State, listeners);
    }
    listeners.set(property, listener);
    v2State?.registerStateChangeListener?.(this.onItemV2StateListener);
  }

  /**
   * 注销V2子状态属性切换监听器
   *
   * @param v2State 子状态
   * @param property 属性集标识
   */
  protected unregisterItemV2StListener(v2State: IBaseState, ...property: string[]): void {
    let key = this.getV2Key(v2State?.getStateType(), v2State?.getStateId());
    let listeners = this.itemV2StateChange.get(v2State);
    if (listeners) {
      property?.forEach((pt) => listeners?.delete(pt));
    }
    // 监听器清空，则注销状态监听
    if (listeners === undefined || listeners.size === 0) {
      v2State?.unregisterStateChangeListener?.(this.onItemV2StateListener);
      this.itemV2States.delete(key);
    }
  }

  /**
   * 刷新沉浸态壁纸
   *
   * @param isEnterImm true进入沉浸态
   */
  protected updateImmWallpaper(isEnterImm: boolean = false): void {
    if (isEnterImm) {
      slWallpaperMgr.enterSlWallpaperScene(SLWallpaperType.TYPE_IMMERSIVE_STYLE,
        SLWallpaperVisibleScene.SCENE_IMMERSIVE_CARD);
      return;
    }
    // 三方主题，时钟不可见时，壁纸隐藏由时钟动效完成后复位
    if (this.isClockVisible()) {
      slWallpaperMgr.exitSlWallpaperScene(SLWallpaperType.TYPE_IMMERSIVE_STYLE,
        SLWallpaperVisibleScene.SCENE_IMMERSIVE_CARD);
    }
  }

  /**
   * 样式不同模式下取值
   *
   * @param pt 属性标识
   * @param rootCfgStyle 根配置样式
   * @returns 属性值
   */
  private getStyleModeValue(pt: WProperty, rootCfgStyle?: WidgetStyleStateV2): BaseObj | undefined | null {
    // 无对应配置
    if (!rootCfgStyle) {
      return undefined;
    }
    let tarProperty: BaseObj | undefined | null = undefined;
    // 按优先级取值
    this.getStModeOrder().find((modeId) => {
      // 无效模式，直接跳过
      if (!this.stModeSet.has(modeId)) {
        return false;
      }
      // 对应状态模式下样式正常取值，允许嵌套取值
      let modeCfgStyle = rootCfgStyle?.getChildState(modeId);
      // 优先查找Child有效值
      let modePt = this.getStyleModeValue(pt, modeCfgStyle);
      if (modePt !== undefined) {
        tarProperty = modePt;
        return true;
      }
      // 允许null配置，区分默认undefined
      tarProperty = modeCfgStyle?.getStateValue(pt) ?? modeCfgStyle?.getPtNullValue(pt);
      return tarProperty !== undefined;
    });
    // 已取到值，直接返回
    if (tarProperty !== undefined) {
      return tarProperty;
    }
    // 最后root样式兜底
    return rootCfgStyle?.getStateValue(pt);
  }

  /**
   * 刷新纯色模式颜色
   *
   * @param solidStyle 纯色模式样式
   */
  private refreshSolidStyle(solidStyle?: WidgetStyleStateV2): void {
    if (!solidStyle) {
      return;
    }
    if (solidStyle.getStateId() !== StateModeId.SOLID) {
      return;
    }
    // 刷新纯色颜色
    this.getSolidVisualControl()?.updateSolidColor(solidStyle);
  }

  /**
   * 刷新沉浸状态回调
   *
   * @param stateType 状态类型
   */
  private refreshImmersiveState(stateType?: ImmersiveType): void {
    // 沉浸状态切换回调
    if (stateType !== undefined && stateType !== ImmersiveType.TYPE_WIDTH_DISPLAY_STATE) {
      this.onImmersiveTypeChange(stateType);
    }
  }

  /**
   * 锁屏V1状态变化回调处理
   *
   * @param mainType 主类型
   * @param subType 属性类型
   */
  private onSlV1StateChange(mainType: SlMainStateType, subType?: SlSubStateType): void {
    let state = this.getV1State(mainType);
    if (subType) {
      this.slV1StateChange.get(mainType)?.get(subType)?.(state);
    }
  }

  /**
   * 锁屏V2状态变化回调处理
   *
   * @param stateType 状态类型
   * @param stateId 状态ID
   * @param property 属性名
   */
  private onSlV2StateChange(stateType: StateType, stateId: SlStateId, property?: V2Property): void {
    let state = this.getV2State({ stateType: stateType, stateId: stateId });
    let unique = this.v2UniqueMap.get(this.getV2Key(stateType, stateId));
    if (property) {
      this.slV2StateChange.get(unique)?.get(property)?.(state);
    }
  }

  /**
   * 子状态V2状态变化回调处理
   *
   * @param stateType 状态类型
   * @param stateId 状态ID
   * @param property 属性名
   */
  private onItemV2StateChange(stateType: StateType, stateId: string, property?: string): void {
    if (!property) {
      return;
    }
    let key = this.getV2Key(stateType, stateId);
    let v2State = this.itemV2States.get(key);
    if (v2State) {
      this.itemV2StateChange.get(v2State)?.get(property)?.(v2State);
    }
  }
}