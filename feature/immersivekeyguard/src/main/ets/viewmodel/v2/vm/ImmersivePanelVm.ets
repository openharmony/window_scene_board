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
import { WDefault } from '@ohos/screenlockcommon';
import { IBaseState } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import { NotificationBaseVm } from '@ohos/systemuicommon/newIndex';
import { IImmersiveNtfVmInjector } from '../../../common/interface/IImmersiveNtfVmInjector';
import { IImmersivePanelVm } from '../../../common/interface/IImmersivePanelVm';
import { SlStateHelper } from '../../../model/helper/SlStateHelper';
import { DownPosition } from '@ohos/screenlockcommon/src/main/ets/interface/ISlState';

const TAG = 'ImmersivePanelVm';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

const DEFAULT_PANEL_NAME = 'immersive_panel_default';

/**
 * 沉浸面板业务管理，列表、胶囊、大图通用业务
 */
@ObservedV2
export class ImmersivePanelVm extends NotificationBaseVm implements IImmersivePanelVm {
  // 面板标示
  protected readonly panelName: string = DEFAULT_PANEL_NAME;
  // 状态辅助工具
  private stateHelper: SlStateHelper;
  // 面板可见性
  @Trace public isVisible: boolean = true;
  // 条目卡片宽度
  @Trace public cardWidth: number = WDefault.MIN_VALUE;
  // 面板透明度
  @Trace public opacity: number = WDefault.MAX_VALUE;
  // 面板缩放度
  @Trace public scale: number = WDefault.MAX_VALUE;
  // 面板布局参数，锁屏面板不涉及
  @Trace public layoutOptions: FlexOptions = {};
  // 面板横屏布局样式，锁屏面板不涉及
  @Trace public isLandscapeLayout: boolean = false;
  // 面板显隐回调
  @Trace public onPanelVisibleChange: (isVisible: boolean) => void = (isVisible: boolean) => {
    if (this.isVisible !== isVisible) {
      this.isVisible = isVisible;
      log.showInfo(`onPanelVisibleChange: ${isVisible}`);
    }
  };

  // 锁屏模块通用静态状态
  @Trace private slComStaticSt?: IBaseState;

  // 锁屏模块通用UI绑定状态
  @Trace private slComBindSt?: IBaseState;

  /**
   * 面板触摸down点，全局Y轴点，-1无触摸
   */
  @Trace public panelDownWindowY: number = -1;
  /**
   * 面板触摸down点，全局Y轴点，-1无触摸
   */
  @Trace public panelDownWindowX: number = -1;
  /**
   * 是否可响应事件
   */
  @Trace public isResponsive: boolean = true;

  // 复写，不具体使用
  public onPanHorizontalStart = (event: GestureEvent): void => {};
  public onPanHorizontalMove = (event: GestureEvent): void => {};
  public onPanHorizontalEnd = (event: GestureEvent): void => {};
  public onPanHorizontalCancel = (): void => {};

  constructor(vmInjector: IImmersiveNtfVmInjector) {
    super(vmInjector);
    this.stateHelper = SlStateHelper.getInstance(vmInjector.getStateMgr());
  }

  public getSlComStaticState(): IBaseState | undefined {
    if (!this.slComStaticSt) {
      this.slComStaticSt = this.stateHelper?.getComStaticState();
    }
    return this.slComStaticSt;
  }

  public getSlComBindState(): IBaseState | undefined {
    if (!this.slComBindSt) {
      this.slComBindSt = this.stateHelper?.getComBindState();
    }
    return this.slComBindSt;
  }

  /**
   * 设置锁屏面板触摸点
   *
   * @param downPosition 触摸点
   */
  public setPanelGlobalDownPosition(downPosition: DownPosition): void {
    if (this.panelDownWindowX != downPosition.positionX) {
      this.panelDownWindowX = downPosition.positionX;
    }
    if (this.panelDownWindowY != downPosition.positionY) {
      this.panelDownWindowY = downPosition.positionY;
    }
  }
}