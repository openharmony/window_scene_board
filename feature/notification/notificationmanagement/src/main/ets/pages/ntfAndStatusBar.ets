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
import type UIExtensionContentSession from '@ohos.app.ability.UIExtensionContentSession';
import { LogDomain, LogHelper } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/BasicCommon';
import { Trace } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/Trace';
import { NtfManagementTrace, PageConstants } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/constants';
import { DeviceHelper, EventManager, EvtBus } from '@ohos/managementcomponent';
import { LengthMetrics } from '@ohos.arkui.node';
import { ContextManager } from '@ohos/managementcomponent/src/main/ets/com/ohos/manager/ContextManager';
import { navRouter } from '../pages/ntfAndStatusBarComponentsLoader';
import { NtfSettingJumpEvent } from '@ohos/managementcomponent/src/main/ets/com/ohos/event/NtfSettingEvent';
import { PageStorages } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/PageStorages';
import { KeyValPair, PageContext } from '@ohos/managementcomponent/src/main/ets/com/ohos/model/SystemUISettingSession';
import { StatusBarModel } from '../model/StatusBarModel';
import NtfSettingUtil from '@ohos/managementcomponent/src/main/ets/com/ohos/common/NtfSettingUtil';
import { HdsNavDestination, HdsNavDestinationAttribute } from '@kit.UIDesignKit';
import { SysUIHdsNavigations } from '../common/SysUIHdsNavigations';
import curves from '@ohos.curves';
import lazy { initLazyModulesForNtfAndStatusBar } from '../common/LazyModuleLoader';
import lazy { initLazyModulesForNtfSettingPage } from '../common/LazyModulePageLoader';
import lazy { NtfSettingSysEventReporter } from
  '@ohos/managementcomponent/src/main/ets/com/ohos/common/NtfSettingSysEventReporter';
import Constants from '../common/constants';

const TAG = 'NotificationManagement-Main';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);
const TRANSPARENT_COLOR: string = '#00000000';

@Entry
@Component
export struct NtfAndStatusBar {
  @State transitionType: NavigationSystemTransitionType = NavigationSystemTransitionType.TITLE;
  @State hideBackButton: boolean = false;
  @State isLoadedNavRouter: boolean = false;
  @State isPageLoaded: boolean = false;
  @State titleTranslate: number = ContextManager.windowWidthByVp / 2;
  @State backOpacity: number = 1;
  @Consume('pageInfos') pageInfos: NavPathStack;
  @StorageLink('navigationMode')
  @Watch('onNavModeChanged') navMode: number = AppStorage.get('navigationMode') ?? -1;
  @StorageLink('isLandscape') isLandscape: boolean = false;

  @BuilderParam emptyPageMap: (name: string, param: ESObject) => void;
  @BuilderParam pageMap: (name: string, param: ESObject) => void;

  viewModelRefresh: (() => void) | undefined = undefined;
  @State curScale: number = 1;
  private eventMgr: EventManager = EvtBus.createEventManager();
  private session: UIExtensionContentSession | undefined = undefined;
  @State statusBarModel: StatusBarModel = StatusBarModel.get();
  @State transitionForSearchPage: TransitionEffect = TransitionEffect.IDENTITY;
  @StorageLink(Constants.TITLE_ANIMATION_DURATION_KEY) titleAnimationDuration?: number = undefined;

  private setTransitionForSearchPage(): void {
    this.transitionForSearchPage = TransitionEffect.OPACITY.combine(TransitionEffect.translate({ y: -56 }))
  }

  private clearTransitionForSearchPage(): void {
    this.transitionForSearchPage = TransitionEffect.IDENTITY;
  }

  build() {
    // HdsNavDestination() {
    NavDestination() {
      Row().height($r('app.float.page_title_height')).margin({ top: this.statusBarModel.height })
      this.buildSearchItem();
      this.NavigationRouter()
    }
    .transition(this.transitionForSearchPage)
    .hideTitleBar(false)
    // .titleBar(SysUIHdsNavigations.getTitleBarOptions($r('app.string.notification_and_status_bar_title'), undefined,
    //   this.titleAnimationDuration))
    .title($r('app.string.notification_and_status_bar_title'))
    .onShown(this.onDestinationShown)
    .hideBackButton(this.hideBackButton)
    .onBackPressed(this.onDestinationBackPressed)
    .systemTransition(this.transitionType)
    .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
  }

  /**
   * 如果是从外部跳转到二级界面（如左滑通知卡片，更多通知跳转到通知管理），则不做一级界面的动效，直接将修改状态变量值，冗余动效会导致；
   * 如果是从外部跳转到一组界面（设置->通知和状态栏），则需要做动效修改标题变量；
   */
  private onDestinationShown = (): void => {
    this.transitionType = NavigationSystemTransitionType.DEFAULT;
    this.loadPageContent();
  }

  private onDestinationBackPressed = (): boolean => {
    log.showInfo('OnDestinationBackPressed. hideBack: %{public}s', this.hideBackButton);
    this.transitionType = NavigationSystemTransitionType.TITLE;
    if (!this.hideBackButton) {
      PageStorages.popContext();
    }
    return false;
  }

  @Builder
  buildSearchItem() {
    Stack() {
      if (this.isLoadedNavRouter) {
        Search({
          value: '',
          placeholder: $r('app.string.search_app'),
        })
          .placeholderFont({
            size: this.getScaledSize(14)
          })
          .width('100%')
          .height($r('app.float.appitem_notice_info_icon_width'))
          .enableKeyboardOnFocus(false)
          .defaultFocus(false)
          .focusable(false)
          .backgroundColor($r('sys.color.comp_background_tertiary'))
          .accessibilityLevel('no-hide-descendants')
          .geometryTransition('SEARCH_ONE_SHOT_TRANSITION_ID', { follow: true })
        // 蒙层，避免点击事件直接作用在Search控件拉起键盘
        Column() {
        }
        .accessibilityText(getContext(this)?.resourceManager.getStringSync($r('app.string.search_app').id))
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
        .onClick(this.clickSearch)
        .backgroundColor(Color.Transparent)
      }
    }
    .width('100%')
    .height($r('app.float.appitem_notice_info_height'))
    .margin({
      bottom: $r('app.float.ntf_status_bar_search_bottom')
    })
    .padding({
      left: $r('app.float.ntf_status_bar_search_item_padding'),
      right: $r('app.float.ntf_status_bar_search_item_padding')
    })
  }

  /**
   * Search组件暂时不支持maxFontScale属性, 这里是通过获取系统缩放倍数手动调整的临时方案. Search组件支持完善后可以删除
   * @returns
   */
  private getScaledSize(size: number): Length {
    return this.curScale * size + 'vp';
  }

  titleTextMarginStart = (): LengthMetrics => {
    if (this.hideBackButton) {
      return LengthMetrics.resource($r('app.float.title_text_margin_start'));
    }
    return LengthMetrics.vp(8);
  }

  @Builder
  NavigationRouter() {
    GridContainer({
      columns: 12,
      sizeType: SizeType.Auto,
      gutter: vp2px(1) === 2 ? '12vp' : '0vp',
      margin: vp2px(1) === 2 ? '24vp' : '0vp'
    }) {
      if (this.isLoadedNavRouter) {
        Row() {
          navRouter({ isAppListLoaded: this.isLoadedNavRouter });
        }
        .padding({ left: this.isLandscape ? $r('app.float.page_notice_and_status_bar_padding') : 0 })
        .alignItems(VerticalAlign.Top)
        .width('100%')
        .height('100%');
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
    .layoutWeight(1)
  }

  onNavModeChanged() {
    this.hideBackButton = this.navMode === NavigationMode.Split;
    log.showInfo('navigationMode is [%{public}d]', this.navMode);
  }

  private loadPageContent() {
    log.showInfo(`loadPageContent viewModelRefresh: ${this.viewModelRefresh}, isLoadedNavRouter: ${this.isLoadedNavRouter}`);
    if (this.viewModelRefresh) {
      this.viewModelRefresh();
    }
    if (!this.isLoadedNavRouter) {
      // 通知延时实现先加载首帧，再加载其他耗时加载逻辑（包括SO的加载）
      const timer = setTimeout(() => {
        this.initLazyModules();
        clearTimeout(timer);
      }, 10);
    }
  }

  private async initLazyModules(callback?: () => void): Promise<void> {
    Trace.start('InitNtfAndStatusBarLazyModules');
    try {
      const result = initLazyModulesForNtfAndStatusBar();
      result.viewModel.ViewModelInit();
      this.viewModelRefresh = () => {
        result.viewModel.checkMigrate();
      };
      this.curScale = result.fontScaleManager.getSysFontScaleState().getFontScale();
      this.isLoadedNavRouter = true;
      callback?.();
      log.showInfo('Init lazy modules success');
    } catch (e) {
      log.error('Init lazy modules error:', e);
    }
    Trace.end('InitNtfAndStatusBarLazyModules');
  }

  private onNtfSettingJumpEvent = (event: NtfSettingJumpEvent): void => {
    log.showInfo('OnNtfSettingJumpEvent for %{public}s', event?.pageName);
    this.clearTransitionForSearchPage();
    this.pushPathHandle(event.pageName, true, event?.param);
  };

  private async pushPathHandle(pageName: string, animated: boolean = true, pageParam?: KeyValPair,
    isEntry?: boolean): Promise<void> {
    try {
      if (!this.isPageLoaded) {
        const result = initLazyModulesForNtfSettingPage();
        this.pageMap = result.pageMap;
        this.isPageLoaded = true;
      }
      this.pageInfos.pushPath({ name: pageName, param: pageParam, isEntry }, animated);
    } catch (error) {
      log.showInfo(`Ntf setting jump second page error: ` + error);
    }
  }

  aboutToAppear() {
    Trace.end(NtfManagementTrace.TRACE_PROCESS_INIT);
    // 配置 Navigation.navDestination 时不能用 undefined ，于是在此初始化一个空实现
    this.emptyPageMap = () => {
    }

    const pageContext = PageStorages.getPageContext();
    // 如果从设置获取navigationMode失败，则按设备种类、屏幕状态给navigationMode赋值
    if (this.navMode === -1 || pageContext?.bundleInfo) {
      this.navMode = (DeviceHelper.isPC() || DeviceHelper.isPad()) ? NavigationMode.Split : NavigationMode.Stack;
      if (DeviceHelper.isFold() &&
        !(DeviceHelper.isSmallFoldProduct())) {
        this.navMode =
          DeviceHelper.isFoldExpanded() || NtfSettingUtil.isXTFoldExpandedMode() ? NavigationMode.Split :
            NavigationMode.Stack;
      }
    }
    this.hideBackButton = this.navMode === NavigationMode.Split;
    this.eventMgr.on(NtfSettingJumpEvent, this.onNtfSettingJumpEvent);
    log.showInfo(`aboutToAppear hideBackButton: ${this.hideBackButton}, navMode: ${this.navMode}`);
    this.pushPage(pageContext);
    this.session = PageStorages.getPageContext()?.session;
    this.session?.setWindowBackgroundColor(TRANSPARENT_COLOR);
  }

  private async pushPage(pageContext?: PageContext): Promise<void> {
    this.clearTransitionForSearchPage();
    if (pageContext?.bundleInfo) {
      log.showInfo('PushPage NtfMgmtView');
      await this.initLazyModules();
      const pageParam: KeyValPair = {};
      pageParam.item = pageContext.bundleInfo;
      pageParam.pageInfos = this.pageInfos;
      const pageName: string = pageContext.isMetaService ? PageConstants.META_SERVICE_MGMT_VIEW_NAME :
        PageConstants.NTF_MGMT_VIEW_NAME;
      this.transitionType = NavigationSystemTransitionType.DEFAULT;
      this.pushPathHandle(pageName, true, pageParam, true);
      return;
    }

    if (pageContext?.subPageName) {
      log.showInfo('PushPage %{public}s', pageContext.subPageName);
      await this.initLazyModules();
      this.pushPathHandle(pageContext.subPageName, false, undefined, true);
    }
  }

  aboutToDisappear() {
    log.showInfo('aboutToDisappear');
  }

  onBackPress() {
    log.showInfo('OnBackPress');
  }

  private clickSearch = async (): Promise<void> => {
    log.showInfo('Click search');
    this.setTransitionForSearchPage();
    this.getUIContext().animateTo({
      // 进入搜索页动效曲线
      curve: curves.interpolatingSpring(0, 1, 342, 38)
    }, () => {
      this.pushPathHandle(PageConstants.NTF_SEARCH_NAME, false);
    })
    NtfSettingSysEventReporter.notificationClickSearch();
    log.showInfo('Report click search');
  }
}