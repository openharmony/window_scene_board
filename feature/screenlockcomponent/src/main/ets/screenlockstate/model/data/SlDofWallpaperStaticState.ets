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
import {
  DofWallpaperStaticStateType,
  SlMainStateType,
  WidgetStaticStateType
} from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { BaseState } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import { WidgetAnimState } from '@ohos/screenlockcommon/Index';
import { WidgetStaticState } from '@ohos/screenlockcommon/src/main/ets/bean/SlWidgetState';
import { IDofParam } from '@ohos/screenlockcommon/src/main/ets/wallpaper/ScreenLockWallpaperManager';

const TAG = 'SlDofWallpaperStaticState';

/**
 * 锁屏景深壁纸非UI状态变量管理
 */
export class SlDofWallpaperStaticState extends WidgetStaticState<DofWallpaperStaticStateType> {
  private animCtrl: WidgetAnimState = BaseState.wrap(WidgetAnimState, TAG);
  // 景深壁纸映射关系
  private dofScenesInfo: Map<string, IDofParam> = new Map();
  // 需要重新计算景深的type
  private needCalcDofType: string = '';
  // 是否需要刷新景深配置文件
  private needWriteConfigFile: boolean = true;
  // 景深计算时，阈值控制：切换tab等，样式以默认推荐为准，使用小阈值，controlMode为0；锁屏拖动时钟，使用大阈值，controlMode为1
  private calcControlMode: number = 0;

  constructor() {
    super(SlMainStateType.SL_DOF_WALLPAPER_STATIC_STATE);
  }

  protected initSetMethods(): void { // 复写 WidgetStaticState
    this.setMethods.set(DofWallpaperStaticStateType.DOF_TYPE_CONFIG, this.setMethodTypeConfig);
    this.setMethods.set(DofWallpaperStaticStateType.DOF_TYPE_CALC, this.setMethodTypeCalc);
    this.setMethods.set(DofWallpaperStaticStateType.NEED_WRITE_CONFIG_FILE, this.setMethodNeedWriteFile);
    this.setMethods.set(DofWallpaperStaticStateType.DOF_CALC_CONTROL_MODE, this.setMethodCalcControlMode);
  }

  protected initGetMethods(): void { // 复写 WidgetStaticState
    this.getMethods.set(WidgetStaticStateType.WIDGET_ANIM_CTRL, this.getMethodSlDofWallpaperAnimCtrl);
    this.getMethods.set(DofWallpaperStaticStateType.DOF_TYPE_CONFIG, this.getMethodTypeConfig);
    this.getMethods.set(DofWallpaperStaticStateType.DOF_TYPE_CALC, this.getMethodTypeCalc);
    this.getMethods.set(DofWallpaperStaticStateType.NEED_WRITE_CONFIG_FILE, this.getMethodNeedWriteFile);
    this.getMethods.set(DofWallpaperStaticStateType.DOF_CALC_CONTROL_MODE, this.getMethodCalcControlMode);
  }

  private getMethodSlDofWallpaperAnimCtrl(st: SlDofWallpaperStaticState): WidgetAnimState {
    return st.getSlDofWallpaperAnimCtrl();
  }

  public getSlDofWallpaperAnimCtrl(): WidgetAnimState {
    return this.animCtrl;
  };

  protected notifyStateChange(subType: DofWallpaperStaticStateType): void { // 通知状态切换
    this.slStateChangeListener?.onSlStateChange?.(SlMainStateType.SL_DOF_WALLPAPER_STATIC_STATE, subType);
  }

  private getMethodTypeConfig(st: SlDofWallpaperStaticState): Map<string, IDofParam> {
    return st.getDofTypeConfig();
  }

  private getDofTypeConfig(): Map<string, IDofParam> {
    return this.dofScenesInfo;
  }

  private setMethodTypeConfig(st: SlDofWallpaperStaticState, info: Map<string, IDofParam>): void {
    return st.setDofTypeConfig(info);
  }

  private setDofTypeConfig(info: Map<string, IDofParam>): void {
    if (this.dofScenesInfo !== info) {
      this.dofScenesInfo = info;
    }
    this.notifyStateChange(DofWallpaperStaticStateType.DOF_TYPE_CONFIG);
  }

  private getMethodTypeCalc(st: SlDofWallpaperStaticState): string {
    return st.getDofTypeCalc();
  }

  private getDofTypeCalc(): string {
    return this.needCalcDofType;
  }

  private setMethodTypeCalc(st: SlDofWallpaperStaticState, type: string): void {
    return st.setDofTypeCalc(type);
  }

  private setDofTypeCalc(type: string): void {
    if (this.needCalcDofType !== type) {
      this.needCalcDofType = type;
    }
    this.notifyStateChange(DofWallpaperStaticStateType.DOF_TYPE_CALC);
  }

  private getMethodCalcControlMode(st: SlDofWallpaperStaticState): boolean {
    return st.getNeedWriteConfigFile();
  }

  private getNeedWriteConfigFile(): boolean {
    return this.needWriteConfigFile;
  }

  private setMethodCalcControlMode(st: SlDofWallpaperStaticState, needWrite: boolean): void {
    return st.setNeedWriteConfigFile(needWrite);
  }

  private setNeedWriteConfigFile(needWrite: boolean): void {
    if (this.needWriteConfigFile !== needWrite) {
      this.needWriteConfigFile = needWrite;
    }
  }

  private getMethodNeedWriteFile(st: SlDofWallpaperStaticState): number {
    return st.getCalcControlMode();
  }

  private getCalcControlMode(): number {
    return this.calcControlMode;
  }

  private setMethodNeedWriteFile(st: SlDofWallpaperStaticState, calcControlMode: number): void {
    return st.setCalcControlMode(calcControlMode);
  }

  private setCalcControlMode(calcControlMode: number): void {
    if (this.calcControlMode !== calcControlMode) {
      this.calcControlMode = calcControlMode;
    }
  }
}