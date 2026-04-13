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

import { LogDomain, LogHelper, CommonUtils } from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { SlMainStateType, SlStaticStateType } from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { SizeBp, ScreenBp, SizeBpSplice } from '@ohos/screenlockcommon';
import { ISlState, SlObject, WidgetSize, GridAmount, DownPosition } from '@ohos/screenlockcommon/src/main/ets/interface/ISlState';
import { ISlStateChangeListener } from '@ohos/screenlockcommon/src/main/ets/interface/ISlStateChangeListener';
import display from '@ohos.display';
import { MeshConfig } from '@ohos/screenlockcommon/src/main/ets/meshsystem/MeshSystem';
import { WidgetAnimState } from '@ohos/screenlockcommon/Index';
import { BaseState } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import { UIContext } from '@ohos.arkui.UIContext';

const TAG = 'SlStaticState';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 锁屏页面非UI状态变量管理
 */
export class SlStaticState implements ISlState {
  public slStateChangeListener?: ISlStateChangeListener | undefined; // 复写ISlState
  private isPortrait: boolean = true; // 竖屏状态
  private isNotSmallFoldable: boolean = false; // 可折叠设备，非小折叠
  private isFoldExpanded: boolean = false; // 折叠状态展开
  private screenBp: ScreenBp = { screenWidth: 0, screenHeight: 0,
    widthBp: SizeBp.SM, heightBp: SizeBp.LG, bpSplice: SizeBpSplice.SL }; // 屏幕宽高断点，默认直板机竖屏断点
  private screenSize: WidgetSize = { width: 0, height: 0 }; // 锁屏面板大小，vp
  private maxGridAmount: GridAmount = { x: 0, y: 0 }; // 锁屏面板时钟区域可用栅格数
  private gridUnitSize: number = 0; // 栅格单位大小，vp
  private gridXMargin: number = 0; // 栅格起始点横向间距，vp
  private clockCollapseRegion: Rectangle = { y: 0, height: 0 }; // 时钟收起态显示范围
  private clockNoSignRegion: Rectangle = { y: 0, height: 0 }; // 时钟收起态无签名显示范围
  private setMethods: Map<SlStaticStateType, Function> = new Map(); // 状态赋值函数
  private getMethods: Map<SlStaticStateType, Function> = new Map(); // 状态取值函数
  private meshConfig: MeshConfig = new MeshConfig();
  private clockExpandMeshY: number = 4;
  private slMainAnimCtrl: WidgetAnimState = BaseState.wrap(WidgetAnimState, TAG);
  private isScreenLockHost: boolean = true; // 是否是锁屏主界面
  private isSecureAndLocked: boolean = false; // 是否是锁定状态
  private isLocked: boolean = true; // 是否锁屏状态
  private uiContext: UIContext | undefined;
  private slPanelDownGlobal: DownPosition = { positionY: -1, positionX: -1 }; // 锁屏面板全局触摸点坐标

  constructor() {
    this.initSetMethods();
    this.initGetMethods();
  }

  private initSetMethods(): void { // 赋值函数统一管理
    this.setMethods.set(SlStaticStateType.PORTRAIT_STATE,
      (state: SlStaticState, isPortrait: boolean) => state?.setPortraitState(isPortrait));
    this.setMethods.set(SlStaticStateType.FOLDABLE_STATE,
      (state: SlStaticState, isFoldable: boolean) => state?.setFoldable(isFoldable));
    this.setMethods.set(SlStaticStateType.FOLD_EXPAND_STATE,
      (state: SlStaticState, status: display.FoldStatus) => state?.setFoldExpand(status));
    this.setMethods.set(SlStaticStateType.SCREEN_BP, this.setMethodScreenBp);
    this.setMethods.set(SlStaticStateType.SL_SIZE_STATE,
      (state: SlStaticState, size: WidgetSize) => state?.setScreenSize(size));
    this.setMethods.set(SlStaticStateType.SL_MAX_GRID_STATE,
      (state: SlStaticState, maxGrid: GridAmount) => state.setMaxGridAmount(maxGrid));
    this.setMethods.set(SlStaticStateType.SL_GRID_UNIT_STATE,
      (state: SlStaticState, gridUnit: number) => state.setGridUnitSize(gridUnit));
    this.setMethods.set(SlStaticStateType.SL_GRID_MARGIN_STATE,
      (state: SlStaticState, gridMargin: number) => state.setGridXMargin(gridMargin));
    this.setMethods.set(SlStaticStateType.CLOCK_COLLAPSE_SHOW_REGION,
      (state: SlStaticState, region: Rectangle) => state?.setClockCollapseShowRegion(region));
    this.setMethods.set(SlStaticStateType.CLOCK_NO_SIGN_SHOW_REGION,
      (state: SlStaticState, region: Rectangle) => state?.setClockNoSignShowRegion(region));
    this.setMethods.set(SlStaticStateType.MESH_CONFIG,
      (state: SlStaticState, meshConfig: MeshConfig) => state?.setMeshConfig(meshConfig));
    this.setMethods.set(SlStaticStateType.CLOCK_EXPAND_MESH_Y,
      (state: SlStaticState, clockExpandMeshY: number) => state?.setClockExpandMeshY(clockExpandMeshY));
    this.setMethods.set(SlStaticStateType.SL_HOST_STATE,
      (state: SlStaticState, isScreenLockHost: boolean) => state?.setSlHostState(isScreenLockHost));
    this.setMethods.set(SlStaticStateType.SL_SECURE_LOCKED_STATE,
      (state: SlStaticState, isSecureAndLocked: boolean) => state?.setSlSecureAndLockedState(isSecureAndLocked));
    this.setMethods.set(SlStaticStateType.SL_LOCK_STATE, this.setMethodLockState);
    this.setMethods.set(SlStaticStateType.SL_UI_CONTEXT,
    (state: SlStaticState, uiContext: UIContext) => state?.setUiContext(uiContext));
    this.setMethods.set(SlStaticStateType.SL_PANEL_DOWN_GLOBAL,
      (state: SlStaticState, sLockPanelDownGlobal: DownPosition) => state?.setSlPanelDownGlobal(sLockPanelDownGlobal));
  }

  private initGetMethods(): void { // 取值函数统一管理
    this.getMethods.set(SlStaticStateType.PORTRAIT_STATE, (st: SlStaticState): boolean => st.getPortraitState());
    this.getMethods.set(SlStaticStateType.FOLDABLE_STATE, (st: SlStaticState): boolean => st.isDeviceFoldable());
    this.getMethods.set(SlStaticStateType.FOLD_EXPAND_STATE,
      (st: SlStaticState, isSkipSmallFold: boolean): boolean => st.isDeviceExpanded(isSkipSmallFold));
    this.getMethods.set(SlStaticStateType.SCREEN_BP, this.getMethodScreenBp);
    this.getMethods.set(SlStaticStateType.SL_SIZE_STATE, (st: SlStaticState): WidgetSize => st.getScreenSize());
    this.getMethods.set(SlStaticStateType.SL_MAX_GRID_STATE, (st: SlStaticState): GridAmount => st.getMaxGridAmount());
    this.getMethods.set(SlStaticStateType.SL_GRID_UNIT_STATE, (st: SlStaticState): number => st.getGridUnitSize());
    this.getMethods.set(SlStaticStateType.SL_GRID_MARGIN_STATE, (st: SlStaticState): number => st.getGridXMargin());
    this.getMethods.set(SlStaticStateType.CLOCK_COLLAPSE_SHOW_REGION,
      (st: SlStaticState): Rectangle => st.getClockCollapseShowRegion());
    this.getMethods.set(SlStaticStateType.CLOCK_NO_SIGN_SHOW_REGION,
      (st: SlStaticState): Rectangle => st.getClockNoSignShowRegion());
    this.getMethods.set(SlStaticStateType.MESH_CONFIG, (st: SlStaticState): MeshConfig => st.getMeshConfig());
    this.getMethods.set(SlStaticStateType.CLOCK_EXPAND_MESH_Y, (st: SlStaticState): number => st.getClockExpandMeshY());
    this.getMethods.set(SlStaticStateType.SL_MAIN_ANIM_CTR,
      (st: SlStaticState): WidgetAnimState => st.getSlMainAnimCtrl());
    this.getMethods.set(SlStaticStateType.SL_HOST_STATE,
      (st: SlStaticState): boolean => st.getSlHostState());
    this.getMethods.set(SlStaticStateType.SL_SECURE_LOCKED_STATE,
      (st: SlStaticState): boolean => st.getSlSecureAndLockedState());
    this.getMethods.set(SlStaticStateType.SL_LOCK_STATE, this.getMethodLockState);
    this.getMethods.set(SlStaticStateType.SL_UI_CONTEXT,
      (st: SlStaticState): UIContext | undefined => st.getUiContext());
    this.getMethods.set(SlStaticStateType.SL_PANEL_DOWN_GLOBAL,
      (st: SlStaticState): DownPosition => st.getSlPanelDownGlobal());
  }

  private notifyStateChange(subType: SlStaticStateType): void { // 通知状态切换
    this.slStateChangeListener?.onSlStateChange?.(SlMainStateType.SL_STATIC_STATE, subType);
  }

  public getSlStateType(): SlMainStateType { // 复写ISlState
    return SlMainStateType.SL_STATIC_STATE;
  }

  public setSlState(subType: SlStaticStateType, value: SlObject): SlStaticState { // 复写ISlState
    this.setMethods.get(subType)?.(this, value);
    return this;
  }

  public getSlState(subType: SlStaticStateType, scene?: SlObject): SlObject { // 复写ISlState
    return this.getMethods.get(subType)?.(this, scene);
  }

  private setMethodLockState(state: SlStaticState, isLocked: boolean): void {
    state.setLockState(isLocked);
  }

  private getMethodLockState(st: SlStaticState): boolean {
    return st.getLockState();
  }

  private setMethodScreenBp(state: SlStaticState, bp: ScreenBp): void {
    state?.setScreenBp(bp);
  }

  private getMethodScreenBp(st: SlStaticState): ScreenBp {
    return st.getScreenBp();
  }

  public setPortraitState(isPortrait: boolean): void { // 设置竖屏状态
    if (this.isPortrait !== isPortrait) {
      this.isPortrait = isPortrait;
      this.notifyStateChange(SlStaticStateType.PORTRAIT_STATE);
    }
  }

  public getPortraitState(): boolean { // 获取竖屏状态
    return this.isPortrait;
  };

  public setFoldable(isFoldable: boolean): void { // 设置设备可折叠状态
    let isNotSmallFoldable = isFoldable && !DeviceHelper.isSmallFoldProduct(); // 排除小折叠
    if (this.isNotSmallFoldable !== isNotSmallFoldable) {
      this.isNotSmallFoldable = isNotSmallFoldable;
      this.notifyStateChange(SlStaticStateType.FOLDABLE_STATE);
    }
  }

  public isDeviceFoldable(): boolean { // 设备是否可折叠
    return this.isNotSmallFoldable;
  };

  public setFoldExpand(status: display.FoldStatus): void { // 设置设备展开状态
    let isExpanded = status === display.FoldStatus.FOLD_STATUS_EXPANDED ||
      status === display.FoldStatus.FOLD_STATUS_HALF_FOLDED; // 全展开或半展开
    if (this.isFoldExpanded !== isExpanded) {
      this.isFoldExpanded = isExpanded;
      this.notifyStateChange(SlStaticStateType.FOLD_EXPAND_STATE);
      log.showInfo(`setFoldExpand change: ${isExpanded}, ${this.isNotSmallFoldable}`);
    }
  }

  public isDeviceExpanded(isSkipSmallFold: boolean = false): boolean { // 设备是否展开状态
    if (isSkipSmallFold) {
      return this.isFoldExpanded;
    }
    return this.isNotSmallFoldable && this.isFoldExpanded;
  };

  public setScreenBp(bp?: ScreenBp): void { // 设置屏幕宽高断点
    let widthBp = bp?.widthBp ?? SizeBp.SM;
    let heightBp = bp?.heightBp ?? SizeBp.LG;
    this.screenBp.screenWidth = bp?.screenWidth ?? 0;
    this.screenBp.screenHeight = bp?.screenHeight ?? 0;
    if ((this.screenBp.widthBp !== widthBp || this.screenBp.heightBp !== heightBp) && bp) {
      this.screenBp = bp;
      this.notifyStateChange(SlStaticStateType.SCREEN_BP);
      log.showInfo(`setScreenBp change: ${widthBp}, ${heightBp}`);
    }
  }

  public getScreenBp(): ScreenBp { // 屏幕宽高断点
    return this.screenBp;
  }

  public setScreenSize(size: WidgetSize): void { // 设置锁屏面板大小
    let width = size?.width ?? 0;
    let height = size?.height ?? 0;
    if (this.screenSize.width !== width || this.screenSize.height !== height) {
      this.screenSize.width = width;
      this.screenSize.height = height;
      this.notifyStateChange(SlStaticStateType.SL_SIZE_STATE);
      log.showInfo(`setScreenSize change: ${width}, ${height}`);
    }
  }

  public getScreenSize(): WidgetSize { // 锁屏面板大小
    return this.screenSize;
  };

  public setMaxGridAmount(maxGrid: GridAmount): void { // 设置锁屏面板最大可用栅格大小
    let x = maxGrid?.x ?? 0;
    let y = maxGrid?.y ?? 0;
    if (this.maxGridAmount.x !== x || this.maxGridAmount.y !== y) {
      this.maxGridAmount.x = x;
      this.maxGridAmount.y = y;
      this.notifyStateChange(SlStaticStateType.SL_MAX_GRID_STATE);
      log.showInfo(`setMaxGridAmount change: ${x}, ${y}`);
    }
  }

  public getMaxGridAmount(): GridAmount { // 锁屏面板最大可用栅格大小
    return this.maxGridAmount;
  };

  public setGridUnitSize(gridUnit: number): void { // 设置栅格单位大小
    if (this.gridUnitSize !== gridUnit) {
      this.gridUnitSize = gridUnit;
      this.notifyStateChange(SlStaticStateType.SL_GRID_UNIT_STATE);
      log.showInfo(`setGridUnitSize change: ${gridUnit}`);
    }
  }

  public getGridUnitSize(): number { // 栅格单位大小
    return this.gridUnitSize;
  };

  public setGridXMargin(gridMargin: number): void { // 设置起始栅格偏移间距
    if (this.gridXMargin !== gridMargin) {
      this.gridXMargin = gridMargin;
      this.notifyStateChange(SlStaticStateType.SL_GRID_MARGIN_STATE);
      log.showInfo(`setGridXMargin change: ${gridMargin}`);
    }
  }

  public getGridXMargin(): number { // 起始栅格偏移间距
    return this.gridXMargin;
  };

  public setClockCollapseShowRegion(region: Rectangle): void { // 设置时钟收起态显示区域
    if (!CommonUtils.isInvalid(region) && this.isDiffRectangle(this.clockCollapseRegion, region)) {
      this.clockCollapseRegion.y = region.y;
      this.clockCollapseRegion.height = region.height;
      this.notifyStateChange(SlStaticStateType.CLOCK_COLLAPSE_SHOW_REGION);
    }
  }

  public getClockCollapseShowRegion(): Rectangle { // 时钟收起态显示区域
    return this.clockCollapseRegion;
  }

  public setClockNoSignShowRegion(region: Rectangle): void { // 设置时钟收起态无签名显示区域
    if (!CommonUtils.isInvalid(region) && this.isDiffRectangle(this.clockNoSignRegion, region)) {
      this.clockNoSignRegion.y = region.y;
      this.clockNoSignRegion.height = region.height;
      this.notifyStateChange(SlStaticStateType.CLOCK_NO_SIGN_SHOW_REGION);
    }
  }

  public getClockNoSignShowRegion(): Rectangle { // 时钟收起态无签名显示区域
    return this.clockNoSignRegion;
  }

  private isDiffRectangle(first: Rectangle, second: Rectangle) {
    return (first?.y !== second?.y) || (first?.height !== second?.height);
  }

  public setMeshConfig(meshConfig: MeshConfig): void { // 设置网格配置
    if (!CommonUtils.isInvalid(meshConfig) && ((this.meshConfig.meshHeight !== meshConfig.meshHeight) ||
      (this.meshConfig.maxScreenLockMesh !== meshConfig.maxScreenLockMesh))) {
      this.meshConfig.meshHeight = meshConfig.meshHeight;
      this.meshConfig.maxScreenLockMesh = meshConfig.maxScreenLockMesh;
      this.notifyStateChange(SlStaticStateType.MESH_CONFIG);
    }
  }

  public getMeshConfig(): MeshConfig { // 获取网格配置
    return this.meshConfig;
  };

  public setClockExpandMeshY(clockExpandMeshY: number): void { // 设置时钟展开态y轴网格值
    if (this.clockExpandMeshY !== clockExpandMeshY) {
      this.clockExpandMeshY = clockExpandMeshY;
      this.notifyStateChange(SlStaticStateType.CLOCK_EXPAND_MESH_Y);
    }
  }

  public getClockExpandMeshY(): number { // 时钟展开态y轴网格值
    return this.clockExpandMeshY;
  };

  public getSlMainAnimCtrl(): WidgetAnimState { // 锁屏主界面动效管理
    return this.slMainAnimCtrl;
  };

  public setSlPanelDownGlobal(slPanelDownGlobal: DownPosition): void {
    this.slPanelDownGlobal = slPanelDownGlobal;
    this.notifyStateChange(SlStaticStateType.SL_PANEL_DOWN_GLOBAL);
  }

  public getSlPanelDownGlobal(): DownPosition {
    return this.slPanelDownGlobal;
  }

  public setSlHostState(isScreenLockHost: boolean): void {
    if (this.isScreenLockHost !== isScreenLockHost) {
      this.isScreenLockHost = isScreenLockHost;
      this.notifyStateChange(SlStaticStateType.SL_HOST_STATE);
    }
  }

  public getSlHostState(): boolean {
    return this.isScreenLockHost;
  }

  public setSlSecureAndLockedState(isSecureAndLocked: boolean): void {
    if (this.isSecureAndLocked !== isSecureAndLocked) {
      this.isSecureAndLocked = isSecureAndLocked;
      this.notifyStateChange(SlStaticStateType.SL_SECURE_LOCKED_STATE);
    }
  }

  public getSlSecureAndLockedState(): boolean {
    return this.isSecureAndLocked;
  }

  public setLockState(isLocked: boolean): void { // 设置屏幕锁定状态
    if (this.isLocked !== isLocked) {
      this.isLocked = isLocked;
      this.notifyStateChange(SlStaticStateType.SL_LOCK_STATE);
    }
  }

  public getLockState(): boolean { // 获取屏幕锁定状态
    return this.isLocked;
  };

  public setUiContext(uiContext: UIContext): void { // 设置UIContext
    if (this.uiContext !== uiContext) {
      this.uiContext = uiContext;
      this.notifyStateChange(SlStaticStateType.SL_UI_CONTEXT);
    }
  }

  public getUiContext(): UIContext | undefined { // 获取UIContext
    return this.uiContext;
  };
}