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
import { ViewType } from '../manager/view/ViewManagerPolicy';
import { default as ViewManagerPolicy } from '../manager/view/ViewManagerPolicy';
import { DropDownEvent, TargetPanel, WindowEvent } from '../eventbus/events/Events';
import { EvtBus } from '../eventbus/EventBus';
import { HiSysDataShowHide } from '../hisysevent/HiSysData';
import { LogDomain, LogHelper, ThreadUtil } from '@ohos/basicutils';
import { HiDfxEventUtil } from '../hisysevent/HiDfxEventUtil';
import { WindowConstants } from '@ohos/commonconstants';
import { ProxySource } from '../base/ProxyObject';

const TAG = 'DropDownPanelManagerWrapper';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

export class DropdownViewEvent {
  public static eventTypeName = 'DropdownViewEvent';

  public isShow = false;

  constructor(isShow: boolean) {
    this.isShow = isShow;
  }
}

export class DropDownPanelManagerWrapper {
  private static instance: DropDownPanelManagerWrapper;

  /**
   * 下拉事件代理
   */
  public readonly dropDownEventProxy: ProxySource<DropDownEvent>;
  /**
   * 下拉事件
   */
  private readonly dropDownEvent: DropDownEvent;

  public static getInstance(): DropDownPanelManagerWrapper {
    if (this.instance == null) {
      this.instance = new DropDownPanelManagerWrapper();
    }
    return this.instance;
  }

  constructor() {
    this.dropDownEventProxy = new ProxySource(DropDownEvent.create());
    this.dropDownEvent = AppStorage.setAndRef('dropDownEvent2', this.dropDownEventProxy.value).get();
  }

  /**
   * 无动画收起目标面板
   *
   * @param target 目标面板
   */
  hideWindowDirectly(): void {
    // 主线场景 需要面板是否显示。子线程通过adapter调用，在adapter中判断
    if (ThreadUtil.isMainThread && !ViewManagerPolicy.isViewShowing(ViewType.DROPDOWN)) {
      return;
    }

    log.showDebug('hideWindowDirectly');
    this.postWindowEvent(WindowConstants.WINDOW_NAME_DROPDOWN, WindowEvent.EVENT_TYPE_HIDE,
      WindowEvent.EVENT_STATE_START);
    EvtBus.post(DropdownViewEvent, new DropdownViewEvent(false));
    this.dropDownEvent.reset();
  }

  postWindowEvent(windowName: string, eventType: number, eventState: number): void {
    let event = new WindowEvent();
    event.windowName = windowName;
    event.eventType = eventType;
    event.eventState = eventState;
    EvtBus.post(WindowEvent, event);
  }

  /**
   * 无动画展开目标面板
   *
   * @param target 目标面板
   */
  showWindowDirectly(target: TargetPanel): void {
    log.showInfo(`showWindowDirectly target = ${target}`);
    if (target === TargetPanel.NONE) {
      return;
    }
    this.postWindowEvent(WindowConstants.WINDOW_NAME_DROPDOWN, WindowEvent.EVENT_TYPE_SHOW, WindowEvent.EVENT_STATE_START);
    EvtBus.post(DropdownViewEvent, new DropdownViewEvent(true));
    this.dropDownEvent.progress = 1;
    this.setTargetPanel(target);
  }

  /**
   * 设置目标面板
   *
   * @param target 目标面板
   */
  setTargetPanel(target: TargetPanel): void {
    log.showInfo(`setTargetPanel: ${target}`);
    if (this.dropDownEvent.target !== target) {
      this.dropDownEvent.target = target;
      if (target === TargetPanel.NOTIFICATION_PANEL) {
        HiDfxEventUtil.reportNotificationPanelShowHide(HiSysDataShowHide.SHOW);
      } else if (target === TargetPanel.CONTROL_CENTER_PANEL) {
        HiDfxEventUtil.reportControlCenterShowHide(HiSysDataShowHide.SHOW);
      }
    }
  }

  getDropDownEvent(): DropDownEvent {
    return this.dropDownEvent;
  }
}