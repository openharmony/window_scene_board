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

import { CheckEmptyUtils, LogDomain, LogHelper, RectInfo, } from '@ohos/basicutils';
import {
  IconResourceManager,
  localEventManager,
  ResourceManager,
  viewMgrPolicy,
  ViewType
} from '@ohos/frameworkwrapper';
import {
  EventType,
  scbEventExclusiveManager,
  SCBSceneContainerSession,
  SCBSceneInfo,
  SCBSceneMode,
  SCBSceneSessionManager,
  SCBScreenProperty,
  SceneInfoAdapterUtil,
  ScenePanelState,
} from '@ohos/windowscene';
import { ViewManager } from '@ohos/launchercommon/src/main/ets/manager/ViewManager';
import { AllAppsStyleConfig } from '../../model/AllAppsStyleConfig';
import { GestureDockItemInfo } from '../../../dockbar/model/GestureDockItemInfo';
import { AppItemInfo, AppModel, CommonConstants, DockItemInfo } from '@ohos/launchercommon/src/main/ets/TsIndex';
import BundleManager from '@ohos.bundle.bundleManager';
import { GestureDockConstants, GestureDockMode } from '../../../common/GestureDockConstants';
import { AllAppsParam } from '../viewdata/GestureDockAllAppsParam';
import GestureDockAllAppsViewDataMgr from '../viewdata/GestureDockAllAppsViewDataMgr';
import { AllAppsStyleConfigMgr } from '../../model/AllAppsStyleConfigMgr';
import { HiSysDockEditType } from '@ohos/frameworkwrapper/src/main/ets/hisysevent/HiSysData';
import { AllAppsConstants } from '../../model/AllAppsConstants';
import { image } from '@kit.ImageKit';
import { GestureDockUtil } from '../../../common/util/GestureDockUtil';
import { GestureDockAllAppsViewEvent } from './GestureDockAllAppsViewEvent';
import { GestureDockViewModel } from '../../../dock/viewmodel/GestureDockViewModel';
import { GestureDockBarViewModel } from '../../../dockbar/viewmodel/GestureDockBarViewModel';
import { PinyinSort } from '@ohos/frameworkpinyin/src/main/ets/TsIndex';
import { SystemNavReporter } from '../../../common/util/SystemNavReporter';
import { GestureDockDataController } from '../viewdata/GestureDockDataController';
import { i18n } from '@kit.LocalizationKit';
import { GestureDockModeSortManager } from '../../../common/util/GestureDockModeSortManager';

const TAG = 'GestureDockAllAppsViewEventMgr';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.GESTURE, TAG);

/**
 * GestureDockAllAppsViewEventMgr
 */
export default class GestureDockAllAppsViewEventMgr implements GestureDockAllAppsViewEvent {
  public viewDataMgr: GestureDockAllAppsViewDataMgr;
  public allAppsParam: AllAppsParam;
  private mAppModel: AppModel;
  private mPinyinSort: PinyinSort;
  private gestureDockDataController:GestureDockDataController;

  /**
   * 构造器
   *
   * @param viewDataMgr
   */
  public constructor(viewDataMgr: GestureDockAllAppsViewDataMgr) {
    this.viewDataMgr = viewDataMgr;
    this.allAppsParam = this.viewDataMgr.allAppsParam;
    this.mAppModel = AppModel.getInstance();
    this.mPinyinSort = new PinyinSort();
    this.gestureDockDataController = GestureDockDataController.getInstance();
  }

  /**
   * onAboutToAppear
   *
   * @param screenProperty 屏幕属性
   */
  public aboutToAppear(screenProperty: SCBScreenProperty): void {
    this.initRecentAllApps(screenProperty.width);
    if (this.allAppsParam.recentAllApps.length > 0) {
      this.allAppsParam.layoutOptions.irregularIndexes?.push(this.allAppsParam.recentAllApps.length + 1);
    }
    this.initSupportFloatWindowList();
    this.updateAppNameFromCache(this.allAppsParam.supportFloatWindowList);
    this.updateAllAppInfoList();
    this.initStyleConfig(screenProperty);
    this.allAppsParam.blurImage = GestureDockViewModel.getInstance().getViewData()?.getBlurImage();
  }

  /**
   * allApps AboutToDisAppear
   */
  public aboutToDisappear(): void {
    this.resetAllAppsParam();
  }

  /**
   * 初始化allAppParams
   */
  public resetAllAppsParam(): void {
    let dockEvent = GestureDockViewModel.getInstance().getViewEvent();
    dockEvent?.hideAllApps();
    this.allAppsParam.isShowSearchResult = false;
    this.allAppsParam.searchBoxFocusable = false;
  }

  /**
   * 根据设备形态初始化allApps布局
   *
   * @param screenProperty
   */
  public initStyleConfig(screenProperty: SCBScreenProperty): void {
    this.allAppsParam.allAppsStyleConfig = AllAppsStyleConfigMgr.getStyleConfig();
    let searchWidth = this.viewDataMgr.getSearchBoxWidth(screenProperty.width);
    let contentWidth = this.viewDataMgr.getAllAppsContentWidth(screenProperty.width);
    let statusBarHeight = viewMgrPolicy.getViewController(ViewType.STATUS_BAR)?.getArea()?.height ?? 0;
    let contentsHeight = px2vp(screenProperty.height) - statusBarHeight - AllAppsConstants.SYS_STANDARD_HEIGHT;
    if (contentWidth < searchWidth * 2) {
      // 此时两行显示,需要多减掉一个高度
      contentsHeight -= AllAppsConstants.SYS_STANDARD_HEIGHT;
    }

    let dockBarViewData = GestureDockBarViewModel.getInstance().getViewData();
    // 底部挖孔
    if (dockBarViewData) {
      contentsHeight -= dockBarViewData.getBottomCutOutDistance();
      this.allAppsParam.contentsHeight = contentsHeight;
    }

    // 侧边padding计算
    this.allAppsParam.padding = this.viewDataMgr.getAllAppsPadding(screenProperty.width);
  }

  /**
   * 设置AllApps背景图片
   *
   * @param blurImage 模糊图片
   */
  public setAllAppsBlurImage(blurImage: image.PixelMap | undefined): void {
    this.allAppsParam.blurImage = blurImage;
  }

  /**
   * 释放AllApps图片内存
   */
  public releaseAllAppsBlurImage(): void {
    if (this.allAppsParam.blurImage) {
      GestureDockUtil.releaseSrc(this.allAppsParam.blurImage, TAG);
    }
    this.allAppsParam.blurImage = undefined;
  }

  /**
   * 开始allApps编辑
   */
  public startAllAppsEdit(): void {
    this.allAppsParam.gestureDockShowMode = GestureDockMode.EDIT;
  }

  /**
   * 结束allApps编辑
   */
  public finishAllAppsEdit(): void {
    this.allAppsParam.gestureDockShowMode = GestureDockMode.ALL_APPS;
  }

  /**
   * 搜索结果展示
   */
  public onSearchBoxClick(): void {
    if (scbEventExclusiveManager.isExclusive(EventType.GESTUREDOCK_EDITMODE_ALLITEM_CLICK)) {
      log.showInfo(`gesture dock item is dragged, searchBox can not click`);
      return;
    }
    this.requestFocus();
  }

  private requestFocus(): void {
    this.allAppsParam.searchBoxFocusable = true;
    focusControl.requestFocus(`GestureDockAllAppsView_Search_Row`);
  }

  /**
   * onSearchTextChange
   *
   * @param searchText
   */
  public onSearchTextChange(value: string): void {
    log.showInfo('text changed');
    if (this.allAppsParam.searchText === value) {
      log.info(TAG, 'searchText and query is same');
      return;
    }
    this.allAppsParam.searchText = value;
    this.search(value);
  }

  /**
   * onBlur
   */
  public onBlur(): void {
    this.allAppsParam.searchBoxFocusable = false;
  }


  /**
   * 展示搜索结果
   *
   * @param value 搜索关键字
   */
  private search(value: string): void {
    if (value) {
      this.allAppsParam.searchResultList =
        this.allAppsParam.supportFloatWindowList.filter(item =>
        i18n.Transliterator.getInstance('Any-Latn;Latin-Ascii')
          .transform(item.appName.toString())
          .replaceAll(AllAppsConstants.WHITESPACE, '')
          .toLowerCase()
          .indexOf(i18n.Transliterator.getInstance('Any-Latn;Latin-Ascii')
            .transform(value.toString())
            .replaceAll(AllAppsConstants.WHITESPACE, '')
            .trim()
            .toLowerCase()) !== -1);
      this.allAppsParam.isShowSearchResult = true;
      log.showInfo(`searchResultListLen: ${this.allAppsParam.searchResultList.length}`);
      return;
    }
    this.allAppsParam.isShowSearchResult = false;
  }

  /**
   * allApps搜索结果展示
   */
  public onSearchResultListAppear(): void {
    let dockViewData = GestureDockViewModel.getInstance().getViewData();
    let dockBarEvent = GestureDockBarViewModel.getInstance().getViewEvent();
    if (dockViewData?.getGestureDockShowMode() === GestureDockMode.EDIT) {
      dockBarEvent?.dockEditStarted();
    }
  }

  /**
   * 返回按钮点击
   */
  public onArrowLeftClick(): void {
    if (scbEventExclusiveManager.isExclusive(EventType.GESTUREDOCK_EDITMODE_ALLITEM_CLICK)) {
      log.showInfo(`gesture dock item is dragged, arrow left can not click`);
      return;
    }
    if (this.allAppsParam.searchBoxFocusable) {
      this.allAppsParam.searchBoxFocusable = false;
      return;
    }

    let dockEvent = GestureDockViewModel.getInstance().getViewEvent();
    let dockViewData = GestureDockViewModel.getInstance().getViewData();
    let dockBarEvent = GestureDockBarViewModel.getInstance().getViewEvent();
    if (dockViewData?.getGestureDockShowMode() === GestureDockMode.EDIT) {
      SystemNavReporter.reportExitDockEdit(HiSysDockEditType.EDIT);
      dockBarEvent?.dockEditFinished();
      return;
    }
    if (this.allAppsParam.isShowSearchResult) {
      this.allAppsParam.isShowSearchResult = false;
      this.allAppsParam.searchText = '';
      return;
    }
    if (!this.allAppsParam.searchBoxFocusable && !this.allAppsParam.isShowSearchResult) {
      if (dockViewData?.getGestureDockShowMode() !== GestureDockMode.ALL_APPS) {
        return;
      }
      dockEvent?.hideAllApps();
      SystemNavReporter.reportExitDockEdit(HiSysDockEditType.ALL_APPS);
      dockEvent?.doTranslateAnimateOnAllAppsShow();
    }
  }

  /**
   * onAppItemClick
   *
   * @param event 点击事件
   * @param item DockItemInfo
   * @param gestureDockApp 最近任务区/常驻区
   */
  public onAppItemClick(event: ClickEvent | undefined, item: DockItemInfo, gestureDockApp: number): void {
    log.showInfo(`onGestureDockAllAppsItemClick`);
    if (item.bundleName && item.moduleName && item.abilityName) {
      log.showInfo(`onItemClick startSceneFromIcon`);
      // 关闭卡片中心，避免遮挡
      ViewManager.getInstance().closeFormServiceAndManagerView();
      let parameters: Record<string, Object> = {
        'expectWindowMode': SCBSceneMode.FLOATING,
        'isStartFromAppDock': true,
        'dockAppDirection': GestureDockViewModel.getInstance().getViewData()?.getGestureDockDirection() ?? 0,
        'isAppFromRecentAppsOrDockApps': gestureDockApp,
      }
      let sceneInfo = GestureDockUtil.buildSceneInfoByAppItem(item, parameters);
      sceneInfo.expectWindowMode = SCBSceneMode.FLOATING;
      SCBSceneSessionManager.getInstance().startSceneFromIcon(sceneInfo);
      SCBSceneSessionManager.getInstance().execAdditionalCallersCallback();
    }
  }

  private updateWant(sceneInfo: SCBSceneInfo, gestureDockApp: number): void {
    let dockViewData = GestureDockViewModel.getInstance().getViewData();
    if (!dockViewData) {
      return;
    }
    let want = sceneInfo.want;
    if (CheckEmptyUtils.isEmpty(want)) {
      sceneInfo.want = {
        bundleName: sceneInfo.bundleName,
        abilityName: sceneInfo.abilityName,
        moduleName: sceneInfo.moduleName,
        parameters: {
          'expectWindowMode': SCBSceneMode.FLOATING,
          'isStartFromAppDock': true,
          'dockAppDirection': dockViewData.getGestureDockDirection(),
          'isAppFromRecentAppsOrDockApps': gestureDockApp,
        }
      };
    } else {
      sceneInfo.want.parameters = {
        'expectWindowMode': SCBSceneMode.FLOATING,
        'isStartFromAppDock': true,
        'dockAppDirection': dockViewData.getGestureDockDirection(),
        'isAppFromRecentAppsOrDockApps': gestureDockApp,
      };
    }
  }

  /**
   * 监听AllApps状态变化
   * @param isShowAllApps
   */
  public onAllAppsShowChange(isShowAllApps: boolean): void {
    if (isShowAllApps) {
      this.allAppsParam.gestureDockShowMode = GestureDockMode.ALL_APPS;
    }
  }

  /**
   * onBlankAreaClick
   */
  public onBlankAreaClick(): void {
    // 点击空白处，收起输入法
    this.allAppsParam.searchBoxFocusable = false;
  }

  /**
   * allApps宫格视图展示
   */
  public onAllAppsGridAppear(): void {
    let dockViewData = GestureDockViewModel.getInstance().getViewData();
    if (dockViewData?.getGestureDockShowMode() === GestureDockMode.EDIT) {
      let dockBarEvent = GestureDockBarViewModel.getInstance().getViewEvent();
      dockBarEvent?.dockEditStarted();
    }
  }

  /**
   * 支持悬浮窗list
   *
   * @param mCallback
   */
  private initSupportFloatWindowList(): void {
    let appList = this.gestureDockDataController.getAllAppsList();
    let supportFloatWindowList: AppItemInfo[] = [];
    appList?.forEach((item: AppItemInfo) => {
      let queryKey = item.bundleName + item.moduleName + item.abilityName;
      let supportModes = SCBSceneSessionManager.getInstance().getAbilityWindowSupportInfo(queryKey);
      // 过滤支持悬浮窗的app
      if (supportModes?.indexOf(BundleManager.SupportWindowMode.FLOATING) > -1 ||
        SCBSceneSessionManager.getInstance().isInMultiWindowForceSupportList(item.bundleName)) {
        if (supportFloatWindowList.some(item => item.bundleName + item.moduleName + item.abilityName === queryKey)) {
          return;
        }
        supportFloatWindowList.push(item);
      } else {
        log.showInfo(`app is not support floatwindow, bundleName:${item.bundleName}`);
      }
    })
    log.showInfo(`support floatwindow, length:${supportFloatWindowList.length}`);
    this.allAppsParam.supportFloatWindowList = supportFloatWindowList as GestureDockItemInfo[];
  }

  /**
   * LazyForEach刷新数据源
   */
  public updateAllAppInfoList(): void {
    this.viewDataMgr.allAppsDataSource.refreshData(this.allAppsParam.supportFloatWindowList);
  }

  /**
   * 更新appName
   *
   * @param floatWindowAppsList
   * @returns GestureDockItemInfo[]
   */
  private updateAppNameFromCache(floatWindowAppsList: GestureDockItemInfo[]): GestureDockItemInfo[] {
    log.showInfo(`updateAppNameFromCache`);
    try {
      floatWindowAppsList.forEach((appItem: GestureDockItemInfo) => {
        let appName: string = IconResourceManager.getInstance().getAppNameByCache(appItem.appLabelId,
          appItem.bundleName, appItem.moduleName, '');
        if (appName) {
          appItem.appName = appName;
        } else {
          appItem.appName =
            ResourceManager.getInstance()
              .getAbilityAppName(appItem.bundleName, appItem.moduleName, appItem.abilityName);
        }
      });
    } catch (err) {
      log.showError('updateAppNameFromCache error ' + err);
    }
    floatWindowAppsList?.sort((a, b): number => {
      return GestureDockModeSortManager.getInstance().compare(a.appName, b.appName);
    });
    return floatWindowAppsList;
  }

  /**
   * 逐层退出allApps
   *
   * @returns isAllAppsAnimateFinish
   */
  public isAllAppsAnimateFinish(): boolean {
    if (this.allAppsParam?.searchBoxFocusable) {
      this.allAppsParam.searchBoxFocusable = false;
      return false;
    }

    let dockEvent = GestureDockViewModel.getInstance().getViewEvent();
    let dockViewData = GestureDockViewModel.getInstance().getViewData();
    if (dockViewData?.isShowAllApps()) {
      dockEvent?.hideAllApps();
      this.allAppsParam.isShowSearchResult = false;
      dockEvent?.doTranslateAnimateOnAllAppsShow();
      return false;
    }
    return true;
  }

  /**
   * 初始化recentAllApps数据
   * @param screenWidth screenWidth
   */
  private initRecentAllApps(screenWidth: number): void {
    let allAppsStyleConfig: AllAppsStyleConfig = AllAppsStyleConfigMgr.getStyleConfig();
    let gutter = this.viewDataMgr.getColumnGutter(screenWidth);
    let itemWidth: number = gutter + allAppsStyleConfig?.itemWidth;
    let contentWidth: number = this.viewDataMgr.getAllAppsContentWidth(screenWidth);
    let lineCount = Math.floor((contentWidth + gutter) / itemWidth);
    let dockViewData = GestureDockViewModel.getInstance().getViewData();
    if (dockViewData) {
      let recentApps = dockViewData.getRecentApps();
      let recentAllApps: GestureDockItemInfo[] = recentApps.slice(0, lineCount * 2);
      this.allAppsParam.recentAllApps = recentAllApps;
    }
  }

  /**
   * allapps图标置灰回调
   *
   * @param sceneContainerSession
   * @param isGrayAppIcon
   */
  public onGrayAllAppsAppIconCallBack(sceneContainerSession: SCBSceneContainerSession, isGrayAppIcon: boolean): void {
    let primaryBundleName = sceneContainerSession.primarySession?.sceneInfo.bundleName;
    let primaryAppIndex = sceneContainerSession.primarySession?.sceneInfo.appIndex;
    let primaryPersistentId = sceneContainerSession.primarySession?.sceneInfo.persistentId;
    let secondaryBundleName = sceneContainerSession.secondarySession?.sceneInfo.bundleName;
    let secondaryAppIndex = sceneContainerSession.secondarySession?.sceneInfo.appIndex;
    let scenePanelState = AppStorage.get<number>('scenePanelState');
    if (scenePanelState === ScenePanelState.RECENT) {
      log.showDebug(`scenePanelState is RECENT, return`);
      return;
    }
    for (const recentApp of this.allAppsParam.recentAllApps) {
      if (primaryBundleName === recentApp.bundleName && primaryAppIndex === recentApp.appIndex) {
        localEventManager.sendLocalEventSticky(`gray_${GestureDockConstants.GESTURE_DOCK_ALL_APPS +
          primaryBundleName + primaryAppIndex}`, isGrayAppIcon);
      } else if (secondaryBundleName === recentApp.bundleName && secondaryAppIndex === recentApp.appIndex) {
        localEventManager.sendLocalEventSticky(`gray_${GestureDockConstants.GESTURE_DOCK_ALL_APPS +
          secondaryBundleName + secondaryAppIndex}`, isGrayAppIcon);
      }
    }
    for (const floatingApp of this.allAppsParam.supportFloatWindowList) {
      if (floatingApp.bundleName === null) {
        continue;
      }
      if (primaryBundleName === floatingApp.bundleName && primaryAppIndex === floatingApp.appIndex) {
        localEventManager.sendLocalEventSticky(`gray_${GestureDockConstants.GESTURE_DOCK_ALL_APPS +
          primaryBundleName + primaryAppIndex}`, isGrayAppIcon);
      } else if (secondaryBundleName === floatingApp.bundleName && secondaryAppIndex === floatingApp.appIndex) {
        localEventManager.sendLocalEventSticky(`gray_${GestureDockConstants.GESTURE_DOCK_ALL_APPS +
          secondaryBundleName + secondaryAppIndex}`, isGrayAppIcon);
      }
    }
  }

  /**
   * allApps圆角
   * @param radius 圆角
   */
  public setBorderRadius(radius: number): void {
    this.allAppsParam.borderRadius = radius;
  }
}