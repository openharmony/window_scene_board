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

import { LogDomain, LogHelper } from '../../common/BasicCommon';
import { Trace } from '../../common/Trace';
import AppDataSource from '../../model/AppDataSource';
import ConfigData, { PageConstants } from '../../common/constants';
import AppItemComponent from './appItemComponent';
import { AppItem, AppLstComponentViewModel} from '../../vm/appLstComponentViewModel';
import { ContextManager } from '../../manager/ContextManager';
import { NtfManagementTrace, SegmentSelectedIndex } from '../../common/constants';
import { LengthMetrics } from '@kit.ArkUI';
import { NtfSettingJumpEvent as JumpEvt } from '../../event/NtfSettingEvent';
import { evtBus } from '../../common/EventBus';
import { KeyValPair } from '../../model/SystemUISettingSession';
import { SegmentButton, SegmentButtonItemTuple, SegmentButtonOptions } from '@ohos.arkui.advanced.SegmentButton'
import { MetaServiceListVM, MetaServiceStateVM } from '../../vm/MetaServiceListVM';
import { componentUtils } from '@kit.ArkUI';
import { DeviceHelper } from '../../common/DeviceHelper';
import { bundleResourceManager } from '@kit.AbilityKit';

const TAG = 'ManagementComponent-AppListIndexerTemplate';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

// 通知和状态栏页面，点击动态加载事件延迟发送，避免无按压效果问题
const DELAY_POST_DYNAMIC_IMPORT_EVENT = 5;

/**
 * 支持app按字母排序并显示索引的模板组件
 *
 * @since 2023-02-21
 */
@Component
export default struct AppListIndexerTemplate {
  @State lazyAppList: AppDataSource = new AppDataSource([]);
  @State hoverIdx: number = -1;
  @State isListHover: boolean = false;
  @BuilderParam headerBuilder?: Function | void | null;
  @Prop isAppListLoaded: boolean = false;
  @State lazyMetaServiceList: AppDataSource = new AppDataSource([]);
  @State metaServiceStateVM: MetaServiceStateVM = MetaServiceStateVM.get();
  private metaServiceListVM: MetaServiceListVM = new MetaServiceListVM();
  private scroller: Scroller = new Scroller();
  private model: AppLstComponentViewModel = AppLstComponentViewModel.get();
  @State metaContentHeight: Length = 'auto';
  @State emptyServerHeight: Length = 'auto';

  @Consume('pageInfos') pageInfos: NavPathStack;

  aboutToAppear() {
    log.showInfo(`aboutToAppear`);
    Trace.start(NtfManagementTrace.TRACE_LOAD_APP_LIST);
    this.model.appListInit(this.updateAppList);
    if (!DeviceHelper.isPC()) {
      this.metaServiceListVM.init(this.updateMetaList);
    }
  }

  aboutToDisappear() {
    this.model.applistDestroy();
    this.metaServiceListVM.destroy();
  }

  @Builder
  buildList() {
    List({ scroller: this.scroller }) {
      if (this.headerBuilder) {
        ListItem() {
          this.headerBuilder()
        }
        .id(`${TAG}.HeaderBuilder`)
      }
      if (this.isAppListLoaded) {
        this.buildAppList(this.lazyAppList)
      }
    }
    .onHover((isHover)=>{
      this.isListHover = isHover;
    })
    .scrollBar(BarState.Off)
    .width(ConfigData.WH_100_100)
    .align(Alignment.Top)
    .cachedCount(10)
    .zIndex(0)
    .edgeEffect(EdgeEffect.Spring)
    .layoutWeight(1)
    .border({
      color: Color.Transparent,
      width: $r('app.float.border_width'),
      radius: {
        topLeft: $r('app.float.border_radius'),
        topRight: $r('app.float.border_radius'),
        bottomLeft: 0,
        bottomRight: 0
      }
    })
  }

  build() {
    Stack({ alignContent: Alignment.TopEnd }) {
      Column() {
        this.buildList();
      }
      .padding({
        start: LengthMetrics.resource($r('app.float.app_list_indexer_padding_left_right')),
        end: LengthMetrics.resource($r('app.float.app_list_indexer_padding_left_right'))
      })

      // 自定滑动条
      this.scrollBar();
    }
    .onSizeChange((oldValue: SizeOptions, newValue: SizeOptions) => {
      if (newValue.height) {
        const newHeight = Number(newValue.height);
        const headerRect: componentUtils.ComponentInfo = componentUtils.getRectangleById(`${TAG}.HeaderBuilder`);
        const segmentButtonRect: componentUtils.ComponentInfo = componentUtils.getRectangleById(`${TAG}.SegmentButton`);
        const headerHeight = px2vp(headerRect.size.height);
        const segmentButtonHeight = px2vp(segmentButtonRect.size.height);

        const metaContentHeight = newHeight - headerHeight - segmentButtonHeight - ContextManager.aiBarHeightByVp;
        this.metaContentHeight = metaContentHeight > 300 ? metaContentHeight : 'auto';
        this.emptyServerHeight = newHeight - headerHeight - segmentButtonHeight;
        log.showInfo(`metaContentHeight: ${this.metaContentHeight} emptyServerHeight ${this.emptyServerHeight}`);
      }
    })
  }

  @Builder
  scrollBar() {
    ScrollBar({ scroller: this.scroller, direction: ScrollBarDirection.Vertical, state: BarState.Auto })
      .height('100%').margin({ bottom: ContextManager.aiBarHeightByVp })
  }

  @Builder
  buildAppList(list: AppDataSource) {
    ListItemGroup() {
      LazyForEach(list, (item: AppItem, index: number) => {
        this.buildAppListItem(item, index)
      }, (item: AppItem, index?: number) => String(item.key));
    }
    .backgroundColor($r('sys.color.comp_background_list_card'))
    .margin({ top: $r('app.float.applist_margin_t'), bottom: $r('app.float.app_list_indexer_template_bottom') })
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
    .onHover((isHover?: boolean) => {
      if (isHover === false) {
        this.hoverIdx = -1;
      }
    })
    this.buildAiBar();
  }

  @Builder
  buildAppListItem(item: AppItem, index: number) {
    ListItem() {
      AppItemComponent({
        item: item,
        appItemClick: this.appItemClick,
        isHover: this.hoverIdx === index && this.isListHover,
      })
    }
    .borderRadius($r('app.float.hovered_border_radius'))
    .onHover((isHover?: boolean) => {
      if (isHover) {
        this.hoverIdx = index;
      }
    })
  }

  @Builder
  buildAiBar() {
    Row().height(ContextManager.aiBarHeightByVp)
  }

  @Builder
  buildMetaList() {
    if (this.metaServiceStateVM.isLoadProcessVisible) {
      this.buildLoadingProcess();
    } else if (!this.metaServiceStateVM.isLoginAccount) {
      this.buildLoginService();
    } else if (this.lazyMetaServiceList.totalCount() == 0) {
      this.buildEmptyService();
    } else {
      this.buildAppList(this.lazyMetaServiceList);
    }
  }

  @Builder
  buildEmptyService() {
    Column() {
      Column() {
        Image($r('app.media.empty_service'))
          .width('120vp')
          .height('120vp')
          .draggable(false)
        Text($r('app.string.empty_service'))
          .fontColor($r('sys.color.font_secondary'))
          .fontSize('14fp')
          .fontWeight(FontWeight.Regular)
          .fontFamily('HarmonyHeiTi')
          .maxFontScale(2)
      }
      .justifyContent(FlexAlign.Center)
    }
    .justifyContent(FlexAlign.Center)
    .emptyServerStyles()
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
        .maxFontScale(2)
    }
    .justifyContent(FlexAlign.Center)
    .metaContentStyles()
  }

  @Builder
  buildLoginService() {
    Flex({
      direction: FlexDirection.Column,
      justifyContent: FlexAlign.SpaceBetween,
      alignItems: ItemAlign.Center,
    }) {
      Column() {
        Image($r('app.media.empty_balloons'))
          .width('120vp')
          .height('120vp')
          .draggable(false)
        Text($r('app.string.need_login_service_tips'))
          .fontColor($r('sys.color.font_secondary'))
          .fontSize('14fp')
          .fontWeight(FontWeight.Regular)
          .fontFamily('HarmonyHeiTi')
          .maxFontScale(2)
      }
      .justifyContent(FlexAlign.Center)
      .flexGrow(1)
      .margin({ bottom: 12 })

      Button($r('app.string.login_button'), {
        controlSize: ControlSize.NORMAL,
        buttonStyle: ButtonStyleMode.NORMAL,
      })
        .id(`${TAG}.buildLoginServiceButton`)
        .width('100%')
        .onClick(this.metaServiceListVM.onClickToLoginAccount)
        .maxFontScale(2)
    }
    .metaContentStyles()
  }

  @Styles
  metaContentStyles() {
    .height(this.metaContentHeight)
    .animation({
      duration: 500,
      curve: Curve.Friction,
    })
    .width('100%')
    .padding({ top: $r('app.float.applist_margin_t'), bottom: 28 })
  }

  @Styles
  emptyServerStyles() {
    .height(this.emptyServerHeight)
    .animation({
      duration: 500,
      curve: Curve.Friction,
    })
    .width('100%')
  }

  updateAppList = (appList: AppItem[]): void => {
    log.showInfo(`updateAppList appList size:${appList.length}`);
    let newAppList: AppItem[] = []
    appList.forEach((appInfo) => {
      let newAppInfo = appInfo
      if (appInfo.appIcon === undefined) {
        let bundleResInfo = bundleResourceManager.getBundleResourceInfo(appInfo.appBundleName,
          bundleResourceManager.ResourceFlag.GET_RESOURCE_INFO_WITH_ICON,  appInfo.appIndex);
        newAppInfo.appIcon = bundleResInfo.icon
      }
      newAppList.push(newAppInfo)
    })
    this.lazyAppList.refreshData(newAppList);
    Trace.end(NtfManagementTrace.TRACE_LOAD_APP_LIST);
    log.showInfo(`updateAppList appList end`);
  }

  updateMetaList = (appList: AppItem[]): void => {
    log.showInfo(`updateMetaList metaList size:${appList.length}`);
    this.lazyMetaServiceList.refreshData(appList);
    log.showInfo(`updateMetaList metaList end`);
  }

  private async appItemClickReport(appBundleName: string, appUid: number, bundleType: number): Promise<void> {
    try {
      const lazyLoader = await import('../../common/NtfSettingSysEventReporter');
      lazyLoader?.NtfSettingSysEventReporter?.notificationSettingClickEvent(appBundleName, appUid, bundleType);
    } catch (error) {
      log.error(`appItemClickReport error: `, error);
    }
  }

  private async switchSelectedIndexReport(selectedIndex: number): Promise<void> {
    try {
      const lazyLoader = await import('../../common/NtfSettingSysEventReporter');
      lazyLoader?.NtfSettingSysEventReporter?.switchAppOrMetaServicePage({
        BUNDLE_TYPE: selectedIndex,
      });
    } catch (error) {
      log.error(`switchSelectIndexReport error: `, error);
    }
  }

  private appItemClick = (item: AppItem): void => {
    log.showInfo(`onClick ${item.appBundleName}_${item.appUid}`);
    setTimeout(() => {
      const bundleParam: KeyValPair = {};
      bundleParam.item = item;
      bundleParam.pageInfos = this.pageInfos;
      if (item.isMetaService) { // 元服务跳转到元服务设置页面
        evtBus.post(JumpEvt,
          new JumpEvt(JumpEvt.SETTING_PAGE_JUMP, PageConstants.META_SERVICE_MGMT_VIEW_NAME, bundleParam));
      } else {
        evtBus.post(JumpEvt, new JumpEvt(JumpEvt.PAGE_JUMP, PageConstants.NTF_MGMT_VIEW_NAME, bundleParam));
      }
    }, DELAY_POST_DYNAMIC_IMPORT_EVENT);
    // 用户点击进入应用设置界面打点
    this.appItemClickReport(item.appBundleName, item.appUid, item.isMetaService ? 1 : 0);
  }
}