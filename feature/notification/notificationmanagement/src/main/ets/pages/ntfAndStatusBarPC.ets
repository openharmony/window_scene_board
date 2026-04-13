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

import UIExtensionContentSession from '@ohos.app.ability.UIExtensionContentSession';
import { LogDomain, LogHelper } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/BasicCommon';
import { Trace } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/Trace';
import { NtfManagementTrace, PageConstants } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/constants';
import { DeviceHelper } from '@ohos/managementcomponent';
import { LengthMetrics } from '@ohos.arkui.node';
import { ContextManager } from '@ohos/managementcomponent/src/main/ets/com/ohos/manager/ContextManager';
import { navRouter } from '../pages/ntfAndStatusBarComponentsLoader';
import { EventManager, EvtBus } from '@ohos/managementcomponent';
import { NtfSettingJumpEvent } from '@ohos/managementcomponent/src/main/ets/com/ohos/event/NtfSettingEvent';
import { PageStorages } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/PageStorages';
import { KeyValPair, PageContext } from '@ohos/managementcomponent/src/main/ets/com/ohos/model/SystemUISettingSession';
import { NtfSearchController, ResultItemInfo, ResultItemInfoTask } from '../common/NtfSearchController';
import { NotificationConfigEvent, NotificationConfigEventType
} from '@ohos/managementcomponent/src/main/ets/com/ohos/common/BasicCommon';
import { NotificationConfigEntity } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/BasicCommon';
import { NtfSearchResultView } from './NtfSearchResultView';
import {
  NtfSettingSysEventReporter
} from '@ohos/managementcomponent/src/main/ets/com/ohos/common/NtfSettingSysEventReporter';
import {
  notificationSettingManager
} from '@ohos/managementcomponent/src/main/ets/com/ohos/manager/NotificationSettingManager';
import lazy { HiDfxEventUtil } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/HiDfxEventUtil';

const TAG = 'NotificationManagement-PC';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);
const TRANSPARENT_COLOR: string = '#00000000';
/* 2 表示BMS， 1 表示桌面 */
const SEARCH_SOURCE_CHANNEL = '2';

@Entry
@Component
struct NtfAndStatusBarPC {
  @State hideBackButton: boolean = false;
  @State isLoadedNavRouter: boolean = false;
  @State isPageLoaded: boolean = false;
  @State headName: Resource = $r('app.string.notification_and_status_bar_title');
  @State titleTranslate: number = ContextManager.windowWidthByVp / 2;
  @State backOpacity: number = 1;

  @Provide('pageInfos') pageInfos: NavPathStack = new NavPathStack();
  @StorageLink('navigationMode')
  @Watch('onNavModeChanged') navMode: number = AppStorage.get('navigationMode') ?? -1;
  @StorageLink('isLandscape') isLandscape: boolean = false;

  @BuilderParam emptyPageMap: (name: string, param: ESObject) => void;
  @BuilderParam pageMap: (name: string, param: ESObject) => void;
  /* 是否是直接拉起二级页面时顺带拉起主页面的场景 */
  private isLaunchBySecondPage: boolean = false;
  searchController: NtfSearchController = new NtfSearchController();
  @State historyMap : Map<string, number> = new Map();
  @State historyList: string[] = [];
  @State searchResultList: ResultItemInfo[] = [];
  @State isSearchProcessed: boolean = false;
  @State searchValue: string = '';
  private appMapping: Map<string, NotificationConfigEntity> = new Map();

  private isPageShow: boolean = false;
  viewModelRefresh: (() => void) | undefined = undefined;
  @State curScale: number = 1;
  private eventMgr: EventManager = EvtBus.createEventManager();
  private session: UIExtensionContentSession | undefined = undefined;
  @State @Watch('onInputSearchChange') isInputSearch: boolean = false;

  build() {
    Navigation(this.pageInfos) {
      this.NavigationTitle();
      this.buildSearchComponent();
      Column() {
        if (this.isSearchProcessed) {
          NtfSearchResultView({
            searchResultList: this.searchResultList,
            appMapping: this.appMapping,
            historyList: this.historyList,
            historyMap: this.historyMap,
            searchValue: this.searchValue
          })
        } else {
          this.NavigationRouter();
        }
      }
      .layoutWeight(1)
    }
    .navDestination(this.isPageLoaded ? this.pageMap : this.emptyPageMap)
    .mode(NavigationMode.Stack)
    .hideBackButton(true)
    .hideTitleBar(true)
    .titleMode(NavigationTitleMode.Mini)
    .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
  }

  @Builder
  buildSearchComponent() {
    Row() {
      Search({
        value: this.searchValue,
        placeholder: $r('app.string.search_app'),
        controller: new SearchController()
      })
        .textFont({
          size: this.getScaledSize(16),
        })
        .placeholderFont({
          size: this.getScaledSize(16),
        })
        .defaultFocus(false)
        .backgroundColor($r('app.color.card_panel_bg'))
        .onSubmit((value: string) => {
          this.searchValue = value;
          if (value.trim().length === 0) {
            return;
          }
          // 提交搜索内容
          this.inputSearchValue(value, false);
        })
        .onChange((value: string) => {
          this.searchValue = value;
          if (value.trim().length === 0) {
            this.isSearchProcessed = false;
            this.searchResultList = [];
            return;
          }
          // 搜索框文本变动，也会提交搜索内容
          this.inputSearchValue(value);
        })
    }
    .width('100%')
    .height($r('app.float.appitem_notice_info_height'))
    .padding({
      left: $r('app.float.ntf_status_bar_search_item_padding'),
      right: $r('app.float.ntf_status_bar_search_item_padding')
    })
    .margin({ bottom: 4 })
  }

  private async inputSearchValue(value: string, needUpdateAppList: boolean = false): Promise<void> {
    NtfSettingSysEventReporter.notificationSearchApp({
      KEY_WORD: value
    });
    this.isInputSearch = true;
    if (!this.appMapping.size || needUpdateAppList) {
      this.appMapping.clear();
      (await notificationSettingManager.getAppList())
        .filter(it =>!it.settingIgnore)
        .forEach(it => this.appMapping.set(it.bundle, it))
    }

    this.searchController.inputChangeEvent(value, SEARCH_SOURCE_CHANNEL).then((resultInfo: ResultItemInfoTask) => {
      this.logSearchResult(resultInfo);
      // 快速输入的情况下，接口返回时序有问题，对比this.searchValue与resultList对应的搜索值，不同说明不是最新一次的输入，无需更新list
      if (this.searchValue !== resultInfo.searchKey) {
        log.showWarn('Latest searchValue  is different from searchKey');
        return;
      }
      if (this.searchValue.trim().length === 0) {
        log.showWarn(`search value size is zero, no need display result`);
        this.isSearchProcessed = false;
        this.searchResultList = [];
        return;
      }

      this.searchResultList = this.uniqueBy(resultInfo.resultList, (item) => {
        return `${item.bundleName}_${item.appIndex ?? 0}`;
      }).filter(item => {
        return (item.appName?.split('.').length <= 1) && this.appMapping.has(item.bundleName);
      }).map(it => {
        it.appName = this.appNameDeal(it.appName);
        return it;
      });

      log.showInfo(`search result list size is ${this.searchResultList.length}`);
      this.isSearchProcessed = true;
    });
  }

  private uniqueBy<T>(array: T[], keyGenerator: (item: T) => string): T[] {
    const ret: T[] = [];
    const uniqueKeySet: Set<string> = new Set();
    for (const item of array) {
      const itemKey = keyGenerator(item);
      if (uniqueKeySet.has(itemKey)) {
        log.showWarn('Exists same item by %{public}s', itemKey);
      } else {
        ret.push(item);
        uniqueKeySet.add(itemKey);
      }
    }
    return ret;
  }

  private logSearchResult(resultInfo: ResultItemInfoTask): void {
    if (resultInfo.resultList?.length === 0) {
      log.showWarn('Origin search return empty');
    } else {
      resultInfo.resultList.forEach(it => {
        log.showInfo('Origin search ret: %{public}s, %{public}s, %{public}d', it.bundleName, it.sourceChannel,
          it.appIndex);
      });
    }
  }

  private appNameDeal(appName: string): string {
    if (!appName) {
      return appName;
    }
    let result = appName;
    let replaceStrArray: string[] = ['<em>', '</em>'];
    for (let replaceStr of replaceStrArray) {
      result = result.replaceAll(replaceStr, '');
    }
    return result;
  }

  /**
   * Search组件暂时不支持maxFontScale属性, 这里是通过获取系统缩放倍数手动调整的临时方案. Search组件支持完善后可以删除
   * @returns
   */
  private getScaledSize(size: number): Length {
    return this.curScale * size + 'vp';
  }

  @Builder
  NavigationRouter() {
    Column() {
      GridContainer({
        columns: 12,
        sizeType: SizeType.Auto,
        gutter: vp2px(1) === 2 ? '12vp' : '0vp',
        margin: vp2px(1) === 2 ? '24vp' : '0vp'
      }) {
        Row() {
          navRouter({ isAppListLoaded: this.isLoadedNavRouter });
        }
        .padding({ left: this.isLandscape ? $r('app.float.page_notice_and_status_bar_padding') : 0 })
        .alignItems(VerticalAlign.Top)
        .width('100%')
        .height('100%');
      }
      .width('100%')
      .height('100%');
    }
    .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
    .width('100%')
    .layoutWeight(1)
  }

  titleTextMarginStart = (): LengthMetrics => {
    if (this.hideBackButton) {
      return LengthMetrics.resource($r('app.float.title_text_margin_start'));
    }
    return LengthMetrics.vp(8);
  }

  @Builder
  NavigationTitle() {
    Row() {
      if (!this.hideBackButton) {
        this.BackButton();
      }
      Text(this.headName)
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .fontSize(this.hideBackButton ? $r('app.float.ntf_status_bar_title_font_size') : '20vp')
        .fontWeight(FontWeight.Bold)
        .fontFamily('HarmonyHeiTi-Medium')
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .margin({
          start: this.titleTextMarginStart()
        });
    }
    .width('100%')
    .height($r('app.float.page_title_height'))
    .alignItems(VerticalAlign.Center)
    .translate({ x: this.hideBackButton ? null : this.titleTranslate })
    .margin({ top: ContextManager.ntfAndStatusBarTopPadding })
  }

  @Builder
  BackButton() {
    Stack({ alignContent: Alignment.Center }) {
      SymbolGlyph($r('sys.symbol.chevron_backward'))
        .width($r('app.float.appitem_header_icon_width'))
        .height($r('app.float.appitem_header_icon_height'))
        .draggable(false)
        .fontColor([$r('sys.color.ohos_fa_icon_primary')])
        .fontSize($r('app.float.appitem_header_icon_height'))
    }
    .hoverEffect(HoverEffect.Highlight)
    .opacity(this.backOpacity)
    .width($r('app.float.nav_back_image_bg_width_height'))
    .height($r('app.float.nav_back_image_bg_width_height'))
    .onClick(() => {
      try {
        this.session?.sendData({ 'action': 'pop' });
      } catch (error) {
        log.error('registerCallBack error message:' + error?.message);
      }
    })
    .stateStyles({
      normal: this.normalStyles,
      pressed: this.pressedStyles,
    })
    .margin({ start: LengthMetrics.resource($r('app.float.divider_margin_l')) })
    .align(Alignment.Center)
    .accessibilityText(getContext(this)?.resourceManager.getStringSync($r('app.string.psd_back_accessible').id))
  }

  @Styles
  normalStyles() {
    .backgroundColor(Color.Transparent)
    .borderRadius($r('app.float.nav_back_image_bg_radius'))
  }
  @Styles
  pressedStyles() {
    .backgroundColor($r('sys.color.ohos_id_color_click_effect'))
    .borderRadius($r('app.float.nav_back_image_bg_radius'))
  }

  onNavModeChanged() {
    this.hideBackButton = this.navMode === NavigationMode.Split;
    this.titleAnimation();
    log.showInfo('navigationMode is [%{public}d]', this.navMode);
  }

  titleAnimation() {
    if (this.hideBackButton || !this.isPageShow) {
      return;
    }
    this.backOpacity = 0;
    animateTo({ duration: 200, curve: Curve.Sharp }, () => {
      this.titleTranslate = 0;
      this.backOpacity = 1;
    });
  }

  onPageShow() {
    log.showInfo(`onPageShow viewModelRefresh: ${this.viewModelRefresh}, isLoadedNavRouter: ${this.isLoadedNavRouter}`);
    this.isPageShow = true;
    this.setTitleState();
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

  /**
   * 如果是从外部跳转到二级界面（如左滑通知卡片，更多通知跳转到通知管理），则不做一级界面的动效，直接将修改状态变量值，冗余动效会导致；
   * 如果是从外部跳转到一组界面（设置->通知和状态栏），则需要做动效修改标题变量；
   */
  private setTitleState(): void {
    if (this.isLaunchBySecondPage) {
      this.titleTranslate = 0;
      this.backOpacity = 1;
    } else {
      this.titleAnimation();
    }
  }

  private async initLazyModules(callback?: () => void): Promise<void> {
    Trace.start('InitNtfAndStatusBarLazyModules');
    try {
      const mod = await import('../common/LazyModuleLoader');
      const result = mod.initLazyModulesForNtfAndStatusBar();
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
    this.pushPathHandle(event.pageName, true, event?.param);
  };

  private async pushPathHandle(pageName: string, animated: boolean = true, pageParam?: KeyValPair,
    isEntry?: boolean): Promise<void> {
    try {
      if (!this.isPageLoaded) {
        const pageLoader = await import('../common/LazyModulePageLoader');
        const result = pageLoader.initLazyModulesForNtfSettingPage();
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
    }
    this.hideBackButton = this.navMode === NavigationMode.Split;
    this.eventMgr.on(NtfSettingJumpEvent, this.onNtfSettingJumpEvent);
    log.showInfo(`aboutToAppear hideBackButton: ${this.hideBackButton}, navMode: ${this.navMode}`);

    this.pushPage(pageContext);
    this.session = PageStorages.getPageContext()?.session;
    this.session?.setWindowBackgroundColor(TRANSPARENT_COLOR);
    this.searchController.init();
    notificationSettingManager.subscribeChangeEvent(this.onNtfConfigChange);
  }

  private async pushPage(pageContext?: PageContext): Promise<void> {
    if (pageContext?.bundleInfo) {
      log.showInfo('PushPage NtfMgmtView');
      this.isLaunchBySecondPage = true;
      await this.initLazyModules();
      const pageParam: KeyValPair = {};
      pageParam.item = pageContext.bundleInfo;
      pageParam.pageInfos = this.pageInfos;
      this.pushPathHandle(PageConstants.NTF_MGMT_VIEW_NAME, false, pageParam, true);
      return;
    }

    if (pageContext?.subPageName) {
      log.showInfo('PushPage %{public}s', pageContext.subPageName);
      this.isLaunchBySecondPage = true;
      await this.initLazyModules();
      this.pushPathHandle(pageContext.subPageName, false, undefined, true);
    }
  }

  aboutToDisappear() {
    notificationSettingManager.unsubscribeChangeEvent(this.onNtfConfigChange);
    log.showInfo('aboutToDisappear');
  }

  private onNtfConfigChange = (event: NotificationConfigEvent): void => {
    if (event.type === NotificationConfigEventType.ADD_ITEM ||
      event.type === NotificationConfigEventType.DELETE_ITEM) {
      this.inputSearchValue(this.searchValue, true);
    }
  };

  onBackPress() {
    log.showInfo('OnBackPress');
    this.reportLeveNtfAndStatusBar();
  }

  private reportLeveNtfAndStatusBar() {
    const LEAVE_PAGE: number = HiDfxEventUtil.LEAVE_PAGE;
    const NTF_MANAGE_PAGE: string = HiDfxEventUtil.NTF_MANAGE_PAGE;
    HiDfxEventUtil.reportNotificationManagement(LEAVE_PAGE, NTF_MANAGE_PAGE);
  }

  /**
   * 原先点击搜索框跳转时做的通知管理模块初始化，PC检测搜索框输入时也要处理
   */
  async onInputSearchChange() {
    if (!this.isInputSearch) {
      return;
    }
    try {
      if (!this.isPageLoaded) {
        const pageLoader = await import('../common/LazyModulePageLoader');
        const result = pageLoader.initLazyModulesForNtfSettingPage();
        this.pageMap = result.pageMap;
        this.isPageLoaded = true;
      }
      log.showInfo(`Ntf setting modules load finish`)
    } catch (error) {
      log.showError(`Ntf setting modules load error: ` + error);
    }
  }
}