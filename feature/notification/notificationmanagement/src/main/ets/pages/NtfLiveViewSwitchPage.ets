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

import {
  LogDomain,
  LogHelper,
  LogWithHa,
  NotificationConfigEvent
} from '@ohos/managementcomponent/src/main/ets/com/ohos/common/BasicCommon';
import { PageStorages } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/PageStorages';
import { ResourceUtil } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/ResourceUtil';
import { SegmentButton } from '@ohos.arkui.advanced.SegmentButton';
import AppLiveViewItemComponent from './AppLiveViewItemComponent';
import AppLiveViewDataSource from '../model/AppDataSource';
import { LengthMetrics } from '@kit.ArkUI';
import { LiveViewEmptyComponent } from './LiveViewEmptyComponent';
import { EmptyState, NtfLiveViewViewData as ViewModel } from '../vm/NtfLiveViewViewData';
import HeadComponent from '@ohos/managementcomponent/src/main/ets/com/ohos/view/component/headComponent';
import ConfigData from '../common/constants';
import { AppItem } from '@ohos/managementcomponent/src/main/ets/com/ohos/vm/appLstComponentViewModel';
import NtfSettingUtil from '@ohos/managementcomponent/src/main/ets/com/ohos/common/NtfSettingUtil';
import { HdsNavDestination, HdsNavDestinationAttribute } from '@kit.UIDesignKit';
import { SysUIHdsNavigations } from '../common/SysUIHdsNavigations';
import { DeviceHelper } from '@ohos/managementcomponent';
import LiveViewDistributeComponent from './LiveViewDistributeComponent';
import { SettingExceptionCode } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/SettingExceptionCode';
import {
  getDistributedDeviceList
} from '@ohos/windowsceneinterfaces/src/main/ets/interfaces/stub/StubNotificationDistribution';
import {
  notificationSettingManager
} from '@ohos/managementcomponent/src/main/ets/com/ohos/manager/NotificationSettingManager';

const TAG = 'NotificationManagement-LiveViewSetting';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);
/* 全场景开关条目出现事件的key */
const LIVE_VIEW_DISTRIBUTION_BUTTON_EVENT = 'notification.event.DISTRIBUTED_DEVICE_TYPES_CHANGE';

@Entry
@Component
export struct NtfLiveViewSwitchPage {
  @State @Watch('tabIndexChanged') selectedIndex: number[] = [0];
  @State isCurrentApp: boolean = true;
  @State hideBackButton: boolean = false;
  @StorageLink('navigationMode') @Watch('onNavModeChanged') navMode: number = AppStorage.get('navigationMode') ?? -1;
  @StorageLink('isLandscape') isLandscape: boolean = false;
  private isFromNtfAndStatusBar: boolean = true;
  @State viewModel: ViewModel = new ViewModel();
  @State emptyState: EmptyState = this.viewModel.emptyState;
  @State transitionType: NavigationSystemTransitionType = NavigationSystemTransitionType.DEFAULT;
  ntfSettingUtil: NtfSettingUtil = new NtfSettingUtil();
  private scroller: Scroller = new Scroller();
  /**
   * 是否展示协同开关
   */
  @State isDistributionSetBefore: boolean = false;
  /**
   * 是否订阅了协同事件
   */
  private isSubscribed = false;

  aboutToAppear(): void {
    this.isFromNtfAndStatusBar = PageStorages.getPageContext()?.isFromHome ?? true;
    log.showInfo(`isFromNtfAndStatusBar: ${this.isFromNtfAndStatusBar}`);
    if (!this.isFromNtfAndStatusBar) {
      this.navMode = this.ntfSettingUtil.navModeInit();
    }
    this.hideBackButton = this.navMode === NavigationMode.Split;

    this.hasDistributionSet().then(result => {
      this.isDistributionSetBefore = result;
      if (!result) {
        notificationSettingManager.subscribeDistributionChangeEvent(this.onDistributionButtonChange);
        this.isSubscribed = true;
      }
    });

    this.viewModel.init();
    this.setDestinationEntryType();
  }

  aboutToDisappear(): void {
    this.viewModel.destroy();
    if (this.isSubscribed) {
      notificationSettingManager.unsubscribeChangeEvent(this.onDistributionButtonChange);
    }
  }

  tabIndexChanged() {
    this.isCurrentApp = !this.isCurrentApp;
  }

  onNavModeChanged() {
    log.showInfo(`navigationMode is ${this.navMode}`);
    this.hideBackButton = this.navMode === NavigationMode.Split;
  }

  async hasDistributionSet(): Promise<boolean> {
    try {
      const result = await getDistributedDeviceList();
      log.showInfo(`first liveview distribute, ${result.length}`)
      return result.length !== 0;
    } catch (e) {
      LogWithHa.error(log, `get distribution state error ${e}`,
        SettingExceptionCode.GET_FIRST_DISTRIBUTION_STATE_FAIL, e);
      return false;
    }
  }

  private onDistributionButtonChange = (event: NotificationConfigEvent): void => {
    if (event[0] === LIVE_VIEW_DISTRIBUTION_BUTTON_EVENT) {
      // 监听到首次协同事件后，显示开关条目，并将监听解注册，转移至NotificationDistributeComponent监听开关按钮变化
      this.isSubscribed = false;
      notificationSettingManager.unsubscribeChangeEvent(this.onDistributionButtonChange);
      this.isDistributionSetBefore = true;
    }
  }

  build() {
    if (DeviceHelper.isPhoneOrPad()) {
      // HdsNavDestination() {
      NavDestination() {
        Row().height($r('app.float.page_title_height')).margin({ top: this.viewModel.statusBarModel.height })
        this.LiveViewSettingDetail();
      }
      .hideBackButton(this.hideBackButton && !this.isFromNtfAndStatusBar)
      // .titleBar(SysUIHdsNavigations.getTitleBarOptions(this.viewModel.headName))
      .title(this.viewModel.headName)
      .systemTransition(this.transitionType)
      .onBackPressed(this.onDestinationBackPressed)
      .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
    } else if (this.isFromNtfAndStatusBar) {
      NavDestination() {
        this.LiveViewSettingDetail();
      }
      .title(ResourceUtil.getStringSync(this.viewModel.headName) ?? '')
      .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
      .padding({ top: this.viewModel.statusBarModel.height })
    } else {
      this.LiveViewSettingDetail();
    }
  }

  private onDestinationBackPressed = (): boolean => {
    log.showInfo('OnDestinationBackPressed. %{public}s %{public}s', this.isFromNtfAndStatusBar, this.hideBackButton);
    if (!this.isFromNtfAndStatusBar && !this.hideBackButton) {
      PageStorages.popContext();
    }
    return false;
  }

  private setDestinationEntryType(): void {
    if (!DeviceHelper.isPhoneOrPad()) {
      return;
    } else if (this.isFromNtfAndStatusBar) {
      this.transitionType = NavigationSystemTransitionType.DEFAULT;
    } else {
      this.transitionType = NavigationSystemTransitionType.TITLE;
    }
  }

  @Builder
  LiveViewSettingDetail() {
    Column() {
      Column() {
        if (!this.isFromNtfAndStatusBar && !DeviceHelper.isPhoneOrPad()) {
          HeadComponent({ headName: this.viewModel.headName, hideBackButton: this.hideBackButton })
        }

        if (DeviceHelper.isPad() && this.isDistributionSetBefore) {
          Column() {
            LiveViewDistributeComponent();
          }
          .margin({
            top: $r('app.float.page_notice_title_margin_t'),
            bottom: $r('app.float.page_NtfMoreSetting_title_margin')
          })
        }

        LiveViewEmptyComponent({
          isCurrentApp: this.isCurrentApp,
        })
          .layoutWeight(1)
          .visibility(this.emptyState.isAppListEmpty ? Visibility.Visible :
          Visibility.None)

        GridContainer({
          columns: 'auto',
          sizeType: SizeType.Auto,
          gutter: vp2px(1) === 2 ? '12vp' : '0vp',
          margin: vp2px(1) === 2 ? '24vp' : '0vp'
        }) {
          this.buildLiveViewSettingList();
        }
        .width(ConfigData.WH_100_100)
        .height(ConfigData.WH_100_100)
        .layoutWeight(1)
        .visibility(this.emptyState.isServiceListEmpty ? Visibility.Visible : Visibility.None)
      }
      .padding({
        left: $r('app.float.page_notice_info_label_margin'),
        right: $r('app.float.page_notice_info_label_margin')
      })
      .width(ConfigData.WH_100_100)
    }
    .layoutWeight(1)
    .width(ConfigData.WH_100_100)
    .padding({ left: this.isLandscape ? $r('app.float.page_notice_and_status_bar_padding') : 0 })
    .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
  }

  @Builder
  buildLiveViewSettingList() {
    if (this.viewModel.isLoadProcessVisible) {
      this.buildLoadingProcess();
    } else {
      this.buildLiveViewSettingItemList();
    }
  }

  @Builder
  buildLoadingProcess() {
    Column() {
      LoadingProgress()
        .width(72)
        .height(72)
        .alignSelf(ItemAlign.Center)
      Text($r('app.string.app_list_loading_message'))
        .margin({ top: $r('sys.float.padding_level8') })
    }
    .width('100%')
    .height(this.viewModel.isLoadProcessVisible ? '60%' : 0)
    .justifyContent(FlexAlign.Center)
  }

  @Builder
  buildLiveViewSettingItemList() {
    Scroll(this.scroller) {
      Column() {
        this.buildList();
      }
      .padding({
        top: LengthMetrics.resource($r('app.float.app_list_indexer_padding_top')),
      }).width(ConfigData.WH_100_100)
    }
    .border({
      color: Color.Transparent,
      radius: {
        topLeft: $r('app.float.border_radius'),
        topRight: $r('app.float.border_radius'),
        bottomLeft: 0,
        bottomRight: 0
      }
    })
    .edgeEffect(EdgeEffect.Spring)
  }

  @Builder
  scrollBar() {
    ScrollBar({ scroller: this.viewModel.scroller, direction: ScrollBarDirection.Vertical, state: BarState.Auto })
      .height(ConfigData.WH_100_100).margin({ bottom: 0 })
  }

  @Builder
  buildList() {
    List({ scroller: this.viewModel.scroller }) {
      this.buildAppList()
    }
    .scrollBar(BarState.Off)
    .width(ConfigData.WH_100_100)
    .align(Alignment.Top)
    .cachedCount(10)
    .zIndex(0)
    .edgeEffect(EdgeEffect.Spring)
    .layoutWeight(1)
  }

  @Builder
  buildAppList() {
    ListItemGroup() {
      LazyForEach(this.viewModel.lazyAppList, (item: AppItem, index: number) => {
        this.buildAppListItem(item, index)
      }, (item: AppItem, index?: number) => String(item.key));
    }
    .listItemStyle(this.viewModel.lazyAppList)
    .visibility(!this.emptyState.isAppListEmpty ?
    Visibility.Visible : Visibility.None)
  }

  @Builder
  buildAppListItem(item: AppItem, index: number) {
    ListItem() {
      AppLiveViewItemComponent({ item: item })
    }
    .borderRadius($r('app.float.hovered_border_radius'))
    .padding({
      left: $r('app.float.hover_Comp_margin_padding'),
      right: $r('app.float.hover_Comp_margin_padding')
    })
    .accessibilityDescription(item.appTitle)
  }
}

@Extend(ListItemGroup)
function listItemStyle(list: AppLiveViewDataSource) {
  .backgroundColor($r('sys.color.comp_background_list_card'))
  .margin({ bottom: $r('app.float.app_list_indexer_template_bottom') })
  .borderRadius($r('app.float.border_radius'))
  .padding({
    top: list.totalCount() > 0 ? $r('app.float.hover_item_padding_or_margin') : 0,
    bottom: list.totalCount() > 0 ? $r('app.float.hover_item_padding_or_margin') : 0,
    left: $r('app.float.hover_item_padding_or_margin'),
    right: $r('app.float.hover_item_padding_or_margin')
  })
  .divider({
    strokeWidth: '1px',
    color: $r('sys.color.comp_divider'),
    startMargin: $r('app.float.app_list_indexer_template_divider'),
    endMargin: $r('app.float.hover_item_padding_or_margin')
  })
}
