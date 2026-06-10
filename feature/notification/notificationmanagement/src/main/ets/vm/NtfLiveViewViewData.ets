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

import { notificationManager } from '@kit.NotificationKit';
import {
  LogDomain,
  LogHelper,
  NotificationConfigEntity,
  NotificationConfigEvent,
  NotificationConfigEventType
} from '@ohos/managementcomponent/src/main/ets/com/ohos/common/BasicCommon';
import {
  notificationSettingManager
} from '@ohos/managementcomponent/src/main/ets/com/ohos/manager/NotificationSettingManager';
import { liveViewAppFilter } from './LiveViewAppFilter';
import { commonEventManager } from '@kit.BasicServicesKit';
import AppLiveViewDataSource from '../model/AppDataSource';
import { SegmentButtonItemTuple, SegmentButtonOptions } from '@kit.ArkUI';
import { StatusBarModel } from '../model/StatusBarModel';
import { AppItem, AppLstComponentViewModel,
  StateValue } from '@ohos/managementcomponent/src/main/ets/com/ohos/vm/appLstComponentViewModel';

const TAG = 'ManagementComponent-NtfLiveViewViewData';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

export class NtfLiveViewViewData {
  private appLiveViewItemList: AppItem[] = [];
  private serviceLiveViewItemList: AppItem[] = [];
  private commonEventSubscriber?: commonEventManager.CommonEventSubscriber;
  private _headName: Resource = $r('app.string.live_view_title');
  private _selectOptions: SegmentButtonOptions = SegmentButtonOptions.capsule({
    buttons: [
      { text: $r('app.string.live_view_apps') },
      { text: $r('app.string.live_view_services') }
    ] as SegmentButtonItemTuple,
    multiply: false,
    selectedFontColor: $r('sys.color.font_primary'),
    selectedBackgroundColor: $r('sys.color.ohos_id_color_foreground_contrary_disable'),
    textPadding: {
      top: 5,
      right: 10,
      bottom: 5,
      left: 10
    },
  });
  public scroller: Scroller = new Scroller();
  public statusBarModel: StatusBarModel = StatusBarModel.get();
  public lazyAppList: AppLiveViewDataSource = new AppLiveViewDataSource([]);
  public lazyServiceList: AppLiveViewDataSource = new AppLiveViewDataSource([]);
  public emptyState: EmptyState = new EmptyState();
  private model: AppLstComponentViewModel = AppLstComponentViewModel.get();
  public isLoadProcessVisible: boolean = true;

  async init(): Promise<void> {
    this.isLoadProcessVisible = true;
    this.refresh();
    this.subscribeSlotChangeEvent();
    notificationSettingManager.subscribeChangeEvent(this.onNotificationConfigChange);
    await this.model.liveViewListInit(this.updateLiveviewApps);
    this.isLoadProcessVisible = false;
  }

  public updateLiveviewApps = async (appList: AppItem[]): Promise<void> => {
    log.showInfo(`updateAppList appList size:${appList.length}`);
    this.appLiveViewItemList = await liveViewAppFilter.getLiveViewApp(appList);
    this.updateAppList(this.appLiveViewItemList);
  }

  private updateAppList(appList: AppItem[]): void {
    log.showInfo(`updateAppList`);

    this.lazyAppList.refreshData(appList);
    this.emptyState.isAppListEmpty = this.lazyAppList.totalCount() === 0;
  }

  private updateServiceList(serviceList: AppItem[]): void {
    log.showInfo(`updateServiceList`);

    this.lazyServiceList.refreshData(serviceList);
    this.emptyState.isServiceListEmpty = this.lazyServiceList.totalCount() === 0;
  }

  public get headName(): Resource {
    return this._headName;
  }

  public get selectOptions(): SegmentButtonOptions {
    return this._selectOptions;
  }

  destroy(): void {
    this.unsubscribeCommonEvent();
    notificationSettingManager.unsubscribeChangeEvent(this.onNotificationConfigChange);
    this.model.liveviewlistDestroy();
  }

  private async subscribeSlotChangeEvent(): Promise<void> {
    try {
      this.commonEventSubscriber = await commonEventManager.createSubscriber({
        events: ['usual.event.SLOT_CHANGE']
      });
      commonEventManager.subscribe(this.commonEventSubscriber, async (err, event) => {
        if (err) {
          log.error(`Receive usual.event.SLOT_CHANGE error: ${err?.code} ${err?.message}`);
          return;
        }

        // 收到实况通知广播时，若实况开关未显示，则需要刷新界面显示开关，如果已显示，则刷新开关状态
        if (event.bundleName) {
          let status = await notificationManager.isNotificationSlotEnabled(
            { bundle: event.bundleName, uid: event?.parameters?.uid },
            notificationManager.SlotType.LIVE_VIEW
          );
          const uid: number | undefined = event.parameters?.uid;
          let item = this.serviceLiveViewItemList.find((item) => item.appUid === uid);
          if (!item) {
            return;
          }
          item.appLiveViewSwitch = new StateValue(status);
        }
      });
      log.info(`Subscribe usual.event.SLOT_CHANGE success`);
    } catch (e) {
      log.error(`Subscribe usual.event.SLOT_CHANGE error: ${e?.message}`);
    }
  }

  /**
   * 销毁公共事件订阅
   */
  protected unsubscribeCommonEvent(): void {
    commonEventManager.unsubscribe(this.commonEventSubscriber);
  }

  private async refresh(): Promise<void> {
    let serviceEntityList = await notificationSettingManager.getServiceList();
    let serviceList = serviceEntityList.map((serviceEntity) => this.model.convertItem(serviceEntity));

    this.serviceLiveViewItemList = await liveViewAppFilter.getLiveViewApp(serviceList);
    this.updateServiceList(this.serviceLiveViewItemList);
  }

  private onNotificationConfigChange = (event: NotificationConfigEvent): void => {
    log.showInfo(`Recieve event ${event.type}, refresh all`);
    if (event.type === NotificationConfigEventType.DELETE_ITEM) {
      log.showInfo(`Recieve delete item event for ${event.uid}`);
      this.serviceLiveViewItemList = this.serviceLiveViewItemList.filter((item) => item.appUid !== event.uid);
      this.updateServiceList(this.serviceLiveViewItemList);
    } else if (event.type === NotificationConfigEventType.UPDATE_RESOURCE ||
      event.type === NotificationConfigEventType.ADD_ITEM ||
      event.type === NotificationConfigEventType.CHANGE_IGNORE) {
      log.showInfo(`Recieve event ${event.type}, refresh all`);
      this.refresh();
    }
  };
}

@Observed
export class EmptyState {
  public isAppListEmpty: boolean = false;
  public isServiceListEmpty: boolean = false;
}
