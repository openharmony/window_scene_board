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

import { HiSysDockEditType } from '@ohos/frameworkwrapper/src/main/ets/hisysevent/HiSysData';
import { ArrayUtils, CheckEmptyUtils, CommonUtils, LogDomain, LogHelper, RectInfo } from '@ohos/basicutils';
import { DeviceHelper, GlobalContext, localEventManager, } from '@ohos/frameworkwrapper';
import { desktopUtil, ItemUtils } from '@ohos/componenthelper';
import { SCBConstants } from '@ohos/commonconstants';
import {
  EventType,
  scbEventExclusiveManager,
  SCBSceneContainerSession,
  SCBSceneInfo,
  SCBSceneMode,
  SCBSceneSessionManager,
  SCBScreenProperty,
  SceneInfoAdapterUtil
} from '@ohos/windowscene';
import { DockItemInfo, ResidentLayoutCacheMgr } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { ViewManager } from '@ohos/launchercommon/src/main/ets/manager/ViewManager';
import { GestureDockConstants, GestureDockMode } from '../../../common/GestureDockConstants';
import { GestureDockUtil } from '../../../common/util/GestureDockUtil';
import { GestureDockItemInfo } from '../../model/GestureDockItemInfo';
import Display from '@ohos.display';
import display from '@ohos.display';
import { DockBarOutParam, DockBarParam, DockBarScrollerParam, } from '../viewdata/GestureDockBarParam';
import { GestureDockBarViewDataMgr } from '../viewdata/GestureDockBarViewDataMgr';
import { ScreenInfoUtil } from '../../../common/util/ScreenInfoUtil';
import { GestureDockEventIdUtil } from '../../../common/util/GestureDockEventIdUtil';
import GestureDockAppDataHandler from '../viewhandler/GestureDockAppDataHandler';
import GestureDockBarViewAnimate from '../viewanimate/GestureDockBarViewAnimate';
import { GestureDockDirection, GestureDockState } from '../../../dock/viewmodel/viewevent/GestureDockViewEventMgr';
import { GestureDockPreferenceMgr } from '../../../common/preference/GestureDockPreferenceMgr';
import { GestureDockBarViewEvent } from './GestureDockBarViewEvent';
import { GestureDockViewModel } from '../../../dock/viewmodel/GestureDockViewModel';
import { GestureDockAllAppsViewModel } from '../../../dockallapps/viewmodel/GestureDockAllAppsViewModel';
import type ServiceExtensionContext from 'application/ServiceExtensionContext';
import { SystemNavReporter } from '../../../common/util/SystemNavReporter';
import { GestureDockBarViewModel } from '../GestureDockBarViewModel';
import { GestureDockDataController } from '../../../dockallapps/viewmodel/viewdata/GestureDockDataController';


const TAG = 'GestureDockBarViewEventMgr';
const log = LogHelper.getLogHelper(LogDomain.GESTURE, TAG);

/**
 * GestureDockBarViewEventMgr
 */
export default class GestureDockBarViewEventMgr implements GestureDockBarViewEvent {
  public viewDataMgr: GestureDockBarViewDataMgr;
  private appDataHandler: GestureDockAppDataHandler;
  private viewAnimate: GestureDockBarViewAnimate;
  private dockBarParam: DockBarParam;
  private leftBarOutParam: DockBarOutParam;
  private rightBarOutParam: DockBarOutParam;
  private bottomGestureParams: DockBarOutParam;
  private dockBarScrollerParam: DockBarScrollerParam;
  private isAppFromRecentAppsOrDockApps: number = 0;
  private dockViewModel: GestureDockViewModel = GestureDockViewModel.getInstance();
  private dockAllAppsViewModel: GestureDockAllAppsViewModel = GestureDockAllAppsViewModel.getInstance();
  private desktopContext?: ServiceExtensionContext = GlobalContext.getContext();

  /**
   * 构造器
   *
   * @param GestureDockBarViewDataMgr
   */
  public constructor(viewDataMgr: GestureDockBarViewDataMgr) {
    this.viewDataMgr = viewDataMgr;
    this.dockBarParam = this.viewDataMgr.dockBarParam;
    this.leftBarOutParam = this.viewDataMgr.leftBarOutParam;
    this.rightBarOutParam = this.viewDataMgr.rightBarOutParam;
    this.bottomGestureParams = this.viewDataMgr.bottomGestureParams;
    this.dockBarScrollerParam = this.viewDataMgr.dockBarScrollerParam;

    this.viewAnimate = new GestureDockBarViewAnimate(this.viewDataMgr);
    this.appDataHandler = new GestureDockAppDataHandler(this.viewDataMgr);
  }

  public aboutToAppear(screenProperty: SCBScreenProperty): void {
    this.updateDockBarAppData();
    this.updateDockBarMaxHeight(screenProperty);
    this.setCutOutDistance();
    this.desktopContext?.eventHub.on(GestureDockConstants.GESTURE_DOCK_ADD_ITEM, this.onAddItemEvent);
    this.desktopContext?.eventHub.on(GestureDockConstants.GESTURE_DOCK_DELETE_ITEM, this.onDeleteDockApp);
    log.showInfo('aboutToAppear');
  }

  public aboutToDisappear(): void {
    this.desktopContext?.eventHub.off(GestureDockConstants.GESTURE_DOCK_ADD_ITEM, this.onAddItemEvent);
    this.desktopContext?.eventHub.off(GestureDockConstants.GESTURE_DOCK_DELETE_ITEM, this.onDeleteDockApp);
    log.showInfo('aboutToDisappear');
  }

  /**
   * dockBar重置位移动效
   *
   * @param originDirection 方向
   * @param isGestureDockAppear 侧边dock是否显示
   * @param resetDockPositionCallback 重置位移finish的回调
   * @param immediately 立即下发动效
   */
  public doRestPositionAnimate(originDirection: number, isGestureDockAppear: boolean,
    resetDockPositionCallback?: Function, immediately?: boolean): void {
    this.viewAnimate.dockBarRestPositionAnimate(originDirection, isGestureDockAppear,
      resetDockPositionCallback, immediately);
  }

  /**
   * allApps显示，做DockBar的位移动效
   */
  public doTranslateAnimateOnAllAppsShow(): void {
    this.viewAnimate.doTranslateAnimateOnAllAppsShow();
  }

  /**
   * 重置dockBar相关参数
   *
   * @param screenProperty 屏幕属性
   */
  public resetDockBarParams(screenProperty?: SCBScreenProperty): void {
    this.leftBarOutParam.translation = 0;
    this.leftBarOutParam.shadow = undefined;
    this.rightBarOutParam.translation = 0;
    this.rightBarOutParam.shadow = undefined;
    this.dockBarParam.blurRadius = GestureDockConstants.GESTURE_DOCK_BLUR_RADIUS;
    this.dockBarParam.backGroundColor = $r('app.color.gesture_dock_bg_color');
    this.updateDockBarMaxHeight(screenProperty);
  }

  /**
   * 更新dockBar最大高度
   *
   * @param screenProperty 屏幕属性
   */
  public updateDockBarMaxHeight(screenProperty?: SCBScreenProperty): void {
    if (screenProperty) {
      let recentPaddingCount = this.dockBarScrollerParam.isRecentAppShow ? GestureDockConstants.RECENT_COUNT_TWO :
      GestureDockConstants.RECENT_COUNT_ONE;
      let recentPaddingDistance = recentPaddingCount * GestureDockConstants.GESTURE_DOCK_ITEM_DISTANCE;
      let itemDistance = GestureDockConstants.GESTURE_DOCK_ICON_SIZE + GestureDockConstants.GESTURE_DOCK_ITEM_DISTANCE;
      let maxHeight = GestureDockConstants.GESTURE_DOCK_BAR_MAX_COUNT * itemDistance + recentPaddingDistance;
      let maxHeightHorizontal = GestureDockConstants.GESTURE_DOCK_BAR_MAX_COUNT_HORIZONTAL * itemDistance +
        recentPaddingDistance;
      if (DeviceHelper.isPhone() && !desktopUtil.isFoldExpandStatus()) {
        this.dockBarParam.maxHeight = ScreenInfoUtil.isVertical(screenProperty) ? maxHeight : maxHeightHorizontal;
        log.showInfo(`phone maxHeight is ${this.dockBarParam.maxHeight},screen rotation is ${screenProperty.rotation}`);
        return;
      }
      this.dockBarParam.maxHeight = maxHeight;
      log.showInfo(`maxHeight is ${this.dockBarParam.maxHeight}`);
    }
  }

  /**
   * 更新侧边dock应用数据
   */
  public updateDockBarAppData(): void {
    log.showInfo('updateDockBarAppData');
    let dockViewData = this.dockViewModel.getViewData();
    log.showInfo(`updateDockBarAppData:${dockViewData}`);
    if (dockViewData) {
      this.viewDataMgr.dockBarScrollerParam.recentApps = dockViewData.getRecentApps();
      this.appDataHandler.filterRecentItemInfosBySupportDockApps();
      this.appDataHandler.removeRecentItemInfosInResident();
      this.appDataHandler.filterResidentItemInfosBySupportDockApps();
    }
  }

  /**
   * allApps是否展示变化
   *
   * @param isShowAllApps allApps是否显示
   */
  public onAllAppsShowChange(isShowAllApps: boolean): void {
    this.viewDataMgr.dockBarScrollerParam.dividerColor = isShowAllApps ? GestureDockConstants.COLOR_TEXT_SECONDARY :
    GestureDockConstants.DIVIDER_COLOR;
  }

  /**
   * dockBar滑动
   *
   * @param direction 左/右dock
   * @param yOffset y偏移量
   */
  public onGestureDockScroll(direction: number, yOffset: number): void {
    this.viewDataMgr.endOffset = yOffset;
    this.viewDataMgr.scrollTranslate = direction === GestureDockDirection.GESTURE_DOCK_LEFT ?
    this.viewDataMgr.leftScroller.currentOffset().yOffset : this.viewDataMgr.rightScroller.currentOffset().yOffset;

  }

  /**
   * dockBar的allApps按钮点击
   *
   * @param screenId 屏幕id
   */
  public onAllAppsIconClick(): void {
    let dockEvent = this.dockViewModel.getViewEvent();
    dockEvent?.showAllApps();
  }

  /**
   * dockBar编辑item点击
   */
  public onDockEditIconClick(): void {
    SystemNavReporter.reportEnterDockEdit(HiSysDockEditType.EDIT);
    this.dockEditStarted();
  }

  /**
   * dockBar编辑模式确认按钮点击
   */
  public onDockEditCheckMarkIconClick(): void {
    if (scbEventExclusiveManager.isExclusive(EventType.GESTUREDOCK_EDITMODE_ALLITEM_CLICK)) {
      log.showInfo(`gesture dock item is dragged, checkmark button can not click`);
      return;
    }
    SystemNavReporter.reportExitDockEdit(HiSysDockEditType.EDIT);
    this.dockEditFinished();
  }

  /**
   * 重置侧边Dock栏的最大高度
   */
  public onResetDockMaxHeight(): void {
    let recentPaddingCount = this.dockBarScrollerParam.isRecentAppShow ? GestureDockConstants.RECENT_COUNT_TWO :
    GestureDockConstants.RECENT_COUNT_ONE;
    this.dockBarParam.resetDockMaxHeight(recentPaddingCount);
  }

  /**
   * 显示模式变化回调
   *
   * @param currColorMode 显示模式
   */
  public onColorModeChange(currColorMode: number): void {
    log.showInfo(`updateBrightness colorMode=${currColorMode}`);
    this.viewDataMgr.colorShowMode = currColorMode;
    if (currColorMode === GestureDockConstants.DARK_COLOR_MODE) {
      // 1、深色模式 brightness设置1.1
      this.dockBarParam.brightness = SCBConstants.BACK_PLANE_BRIGHTNESS_UP_TEN_PERCENT;
    } else {
      this.dockBarParam.brightness = SCBConstants.BACK_PLANE_BRIGHTNESS_DEFAULT;
    }
    log.showInfo(`updateBrightness this.gestureDockParam.brightness=${this.dockBarParam.brightness}`);
  }

  /**
   * 编辑添加侧边dock应用
   *
   * @param item 待添加item信息
   */
  public onAddItemEvent = (item: GestureDockItemInfo): Promise<void> => this.addDockItem(item);

  private async addDockItem(item: GestureDockItemInfo): Promise<void> {
    log.showInfo(`addDockItem bundleName: ${item?.bundleName}, appIndex: ${item?.appIndex}`);
    let residentApps = AppStorage.get('gestureDockList') as GestureDockItemInfo[];
    let index = residentApps.findIndex((item1) => {
      return CheckEmptyUtils.isEmpty(item1.bundleName);
    })
    if (index === GestureDockConstants.INVALID_VALUE) {
      GestureDockUtil.showToast();
      return;
    }
    let appInfo = residentApps.find(item1 => GestureDockUtil.areTwoAppItemsSame(item, item1));
    if (appInfo) {
      log.showInfo(`dockApp contains bundleName: ${item.bundleName}, appIndex: ${item.appIndex}`);
      return;
    }
    let itemInfo: GestureDockItemInfo = new GestureDockItemInfo();
    itemInfo.bundleName = item.bundleName;
    itemInfo.abilityName = item.abilityName;
    itemInfo.appIndex = item.appIndex;
    itemInfo.editable = false;
    itemInfo.visible = true;
    itemInfo.intent = item.intent;
    let dockItemInfo: DockItemInfo = new DockItemInfo();
    if (item.isActionItem) {
      dockItemInfo = await GestureDockDataController.getInstance().createDockAppInfo(item, index);
    } else {
      dockItemInfo = await ResidentLayoutCacheMgr.getInstance().createDockAppInfo(itemInfo, index) as DockItemInfo;
    }
    let gestureDockItemInfo = dockItemInfo as GestureDockItemInfo;
    log.showInfo(`addDockItem bundleName is ${gestureDockItemInfo.bundleName}, appIndex is ${gestureDockItemInfo.appIndex}`);

    residentApps.splice(index, 1, gestureDockItemInfo);
    AppStorage.setOrCreate('gestureDockList', residentApps);
    GestureDockPreferenceMgr.getInstance().updateDockAppsPreference(residentApps);
    this.scrollToAddDockItemIndex(index);
    // 触发侧边栏变化
    let eventId = GestureDockEventIdUtil.getAllAppsGrayEventId(item);
    localEventManager.sendLocalEventSticky(eventId, item?.bundleName);
  }

  /**
   * 编辑移除侧边dock应用
   *
   * @param index 侧边dock下标
   */
  public onDeleteDockApp = (index: number) => {
    if (index < 0) {
      log.showError('index is invalid, return');
      return;
    }
    let residentApps = AppStorage.get('gestureDockList') as GestureDockItemInfo[];
    let deleteItem = residentApps[index];
    log.showInfo(`delete,totalCount is ${residentApps.length},index is ${index}`);
    SystemNavReporter.reportDeleteAppFromDock(deleteItem.bundleName);
    this.viewDataMgr.endOffset = 0;
    this.viewAnimate.doDeleteAppAnimation(index);
    this.scrollToDeleteItemIndex(index);
    // gestureDockList变化后主动找下一个焦点
    try {
      residentApps = AppStorage.get('gestureDockList') as GestureDockItemInfo[];
      let residentAppsList: GestureDockItemInfo[] =
        residentApps?.filter(item => !CheckEmptyUtils.isEmpty(item.bundleName));
      if (residentApps.length === 0) {
        return;
      }
      let nextItemIndex =
        ((index >= residentAppsList.length) ? index - 1 : index);
      let nextItem: GestureDockItemInfo = residentApps[nextItemIndex];
      log.showInfo(`listLength is ${residentAppsList.length},nextItemIndex is ${nextItemIndex}`);
      log.showInfo(`focus: GestureDockAppItemView_${nextItem.bundleName + nextItem.moduleName + nextItem.abilityName}`);
      focusControl.requestFocus(`GestureDockAppItemView_${nextItem.bundleName + nextItem.moduleName +
      nextItem.abilityName}`);
    } catch (error) {
      log.showError(`deleteCustomFocus ${error}`);
    }
    // 触发侧边栏变化
    let eventId = GestureDockEventIdUtil.getAllAppsGrayEventId(deleteItem);
    localEventManager.sendLocalEventSticky(eventId, deleteItem?.bundleName);
  };

  /**
   * 初始化dockBar参数
   */
  public initDockBarParam(): void {
    this.viewDataMgr.scrollTranslate = 0;
    let height = ItemUtils.getRectById('GestureDockBarView').height;
    if (height) {
      this.dockBarParam.blendRatio = GestureDockConstants.GESTURE_DOCK_ITEM_DISTANCE / height;
    } else {
      this.dockBarParam.blendRatio = GestureDockConstants.BLEND_MODE_DEFAULT_RATIO;
    }
  }

  /**
   * dockBarItem点击
   *
   * @param event 点击事件
   * @param item 点击的item
   * @param dockType 最近任务/常驻区
   */
  public onItemClick(event: ClickEvent | undefined, item: DockItemInfo, direction: number, dockType: number) {
    ViewManager.getInstance().closeFormServiceAndManagerView();

    let gestureDockViewData = this.dockViewModel.getViewData();
    log.showInfo(`dock onItemClick. event: ${event}, item: ${item}, dockType: ${dockType}`);
    if (!gestureDockViewData || gestureDockViewData.getGestureDockShowMode() === GestureDockMode.EDIT) {
      return;
    }
    // 自由多窗模式,已经打开的应用,点击图标,抬升到最上层
    if (SCBSceneSessionManager.getInstance().isPcMode()) {
      let persistentId = GestureDockConstants.INVALID_VALUE;
      let screenId = GestureDockConstants.INVALID_VALUE;
      let containerSessionArray = SCBSceneSessionManager.getInstance().getContainerSessionList();
      for (let container of containerSessionArray) {
        if (container.primarySession?.sceneInfo.bundleName === item.bundleName) {
          persistentId = container.primarySession.persistentId;
          screenId = container.primarySession.screenId;
          break;
        }
        if (container.secondarySession?.sceneInfo.bundleName === item.bundleName) {
          persistentId = container.secondarySession.persistentId;
          screenId = container.secondarySession.screenId;
          break;
        }
      }
      if (persistentId !== GestureDockConstants.INVALID_VALUE && screenId !== GestureDockConstants.INVALID_VALUE) {
        log.showInfo(`app is active, raise scene to top.`);
        SCBSceneSessionManager.getInstance().startSceneFromRecent(screenId, persistentId);
      }
      log.showInfo(`onGrayItemClick skipClickEvent.`);
      return;
    }

    if (item.bundleName && item.moduleName && item.abilityName) {
      log.showInfo(`onItemClick startSceneFromIcon`)
      this.isAppFromRecentAppsOrDockApps = dockType;
      let parameters: Record<string, Object> = {
        'expectWindowMode': SCBSceneMode.FLOATING,
        'isStartFromAppDock': true,
        'dockAppDirection': this.dockViewModel.getViewData()?.getGestureDockDirection() ?? 0,
        'isAppFromRecentAppsOrDockApps': this.isAppFromRecentAppsOrDockApps,
      }
      let sceneInfo = GestureDockUtil.buildSceneInfoByAppItem(item, parameters);
      sceneInfo.expectWindowMode = SCBSceneMode.FLOATING;
      SCBSceneSessionManager.getInstance().startSceneFromOther(sceneInfo);
    }
    SCBSceneSessionManager.getInstance().execAdditionalCallersCallback();
  }

  public getDockTranslate(isLeftDock: boolean): number {
    let dockBarViewData = GestureDockBarViewModel.getInstance().getViewData();
    return dockBarViewData?.getTranslation(isLeftDock) ?? 0;
  }

  private updateWant(sceneInfo: SCBSceneInfo, direction: number): void {
    let dockViewData = this.dockViewModel.getViewData();
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
          'isAppFromRecentAppsOrDockApps': this.isAppFromRecentAppsOrDockApps,
        }
      };
    } else {
      sceneInfo.want.parameters = {
        'expectWindowMode': SCBSceneMode.FLOATING,
        'isStartFromAppDock': true,
        'dockAppDirection': dockViewData.getGestureDockDirection(),
        'isAppFromRecentAppsOrDockApps': this.isAppFromRecentAppsOrDockApps,
      };
    }
  }

  /**
   * dockBar呼出
   * @param animationType 启动类型
   */
  public showDockBar(animationType: number): void {
    GestureDockUtil.hideTextInput();
    this.dockBarParam.isLeft = animationType === GestureDockDirection.GESTURE_DOCK_LEFT;
    this.viewAnimate.gestureDockAppearAnimate(animationType);
  }

  /**
   * dock编辑开始
   */
  public dockEditStarted(): void {
    this.dockViewModel.getViewEvent()?.startAllAppsEdit();
    this.dockAllAppsViewModel.getViewEvent()?.startAllAppsEdit();
    let residentApps: GestureDockItemInfo[] | undefined = AppStorage.get('gestureDockList');
    if (!residentApps) {
      return;
    }
    let remainCount = GestureDockConstants.MAX_CUSTOM_COUNT - residentApps.length;
    log.showInfo(`remainCount is ${remainCount}`);
    for (let index = 0; index < remainCount; index++) {
      residentApps.push(new GestureDockItemInfo());
    }
    AppStorage.setOrCreate('gestureDockList', residentApps);
    log.showInfo(`dockApps length is ${residentApps.length}`);
    // 通知透明度变化
    GlobalContext.getContext()?.eventHub.emit(GestureDockConstants.UPDATE_ITEM_OPACITY);
  }

  /**
   * dock编辑结束
   */
  public dockEditFinished(): void {
    this.dockViewModel.getViewEvent()?.finishAllAppsEdit();
    this.dockAllAppsViewModel.getViewEvent()?.finishAllAppsEdit();
    SystemNavReporter.reportEnterDockEdit(HiSysDockEditType.ALL_APPS);
    let deleteCount = 0;
    let residentApps: GestureDockItemInfo[] | undefined = AppStorage.get('gestureDockList');
    if (!residentApps) {
      return;
    }
    for (let index = 0; index < residentApps.length; index++) {
      if (CheckEmptyUtils.isEmpty(residentApps[index].bundleName)) {
        deleteCount++;
      }
    }
    log.showInfo(`deleteCount is ${deleteCount}`);
    residentApps.splice(GestureDockConstants.MAX_CUSTOM_COUNT - deleteCount, deleteCount);
    AppStorage.setOrCreate('gestureDockList', residentApps);
    GestureDockPreferenceMgr.getInstance().updateDockAppsPreference(residentApps);
    // 通知透明度变化
    GlobalContext.getContext()?.eventHub.emit(GestureDockConstants.UPDATE_ITEM_OPACITY);
  }

  /**
   * 获取屏幕的挖孔信息
   *
   * @param screenProperty
   */
  public setCutOutDistance(): void {
    // 获取屏幕挖孔
    try {
      let display = Display.getDefaultDisplaySync();
      if (CommonUtils.isInvalid(display)) {
        log.showWarn(`getScreenCutOutInfo display is invalid.`);
        return;
      }
      display.getCutoutInfo().then((info) => {
        this.leftBarOutParam.cutOutDistance = 0;
        this.rightBarOutParam.cutOutDistance = 0;
        this.bottomGestureParams.cutOutDistance = 0;
        let boundRects: Array<display.Rect> | undefined = info?.boundingRects;
        if (ArrayUtils.isEmpty(boundRects)) {
          this.leftBarOutParam.cutOutDistance = 0;
          this.rightBarOutParam.cutOutDistance = 0;
          log.showInfo(`getScreenCutOutInfo boundRects is empty.`);
          return;
        }
        log.showInfo(`getScreenCutOutInfo cutout: left: ${boundRects[0].left}, top: ${boundRects[0].top}, \
          height: ${boundRects[0].height}, width: ${boundRects[0].width}`);
        if (ScreenInfoUtil.isCutOutLeft(boundRects[0], display)) {
          this.leftBarOutParam.cutOutDistance = px2vp(boundRects[0].left + boundRects[0].width);
        } else if (ScreenInfoUtil.isCutOutRight(boundRects[0], display)) {
          this.rightBarOutParam.cutOutDistance = px2vp(display.width - boundRects[0].left);
        } else if (ScreenInfoUtil.isCutOutBottom(boundRects[0], display)) {
          this.bottomGestureParams.cutOutDistance = px2vp(display.height - boundRects[0].top);
        }
      });
    } catch (error) {
      log.error('error', error);
    }
  }

  /**
   * 滑动到新增的元素的位置
   *
   * @param index
   */
  public scrollToAddDockItemIndex(index: number): void {
    let singleItemDistance =
      GestureDockConstants.GESTURE_DOCK_ICON_SIZE + GestureDockConstants.GESTURE_DOCK_ITEM_DISTANCE;
    let recentDistance: number = 0;
    if (this.dockBarScrollerParam.recentApps.length > 0) {
      recentDistance = Math.min(this.dockBarScrollerParam.recentApps.length,
        GestureDockConstants.GESTURE_DOCK_MAX_RECENT) *
        singleItemDistance + GestureDockConstants.GESTURE_DOCK_ITEM_DISTANCE;
    }
    let moveDistance = (index + 1) * singleItemDistance + recentDistance;
    let dockMaxHight = this.dockBarParam.maxHeight;
    let direction = this.dockViewModel.getViewData()?.getGestureDockDirection();
    let scroller = this.viewDataMgr.getScroller(direction === GestureDockState.GESTURE_DOCK_LEFT_OUT);
    log.showInfo(`scrollToAddDockItemIndex direction: ${direction}, currentOffset: ${scroller.currentOffset().yOffset}, \
      yOffset: ${moveDistance}, index: ${index}, recentDistance:${recentDistance}, maxHeight:${dockMaxHight}`);
    if (moveDistance >= scroller.currentOffset().yOffset + dockMaxHight) {
      // 与设备体验对齐，每次到底多向下滑出1个
      scroller.scrollTo({
        xOffset: 0, yOffset: moveDistance - dockMaxHight + GestureDockConstants.GESTURE_DOCK_ITEM_DISTANCE +
          singleItemDistance
      });
    }
    if (moveDistance < scroller.currentOffset().yOffset + singleItemDistance) {
      scroller.scrollTo({
        xOffset: 0, yOffset: moveDistance - singleItemDistance
      });
    }
  }

  /**
   * 滑动到删除元素的上一个位置
   *
   * @param index
   */
  public scrollToDeleteItemIndex(index: number): void {
    let residentApps = AppStorage.get('gestureDockList') as GestureDockItemInfo[];
    let emptyItemIndex = residentApps.findIndex((item1) => {
      return CheckEmptyUtils.isEmpty(item1.bundleName);
    });
    log.showInfo(`scrollToDeleteItemIndex emptyItemIndex: ${emptyItemIndex}, index: ${index}, `);
    if (index === emptyItemIndex) {
      let singleItemSize =
        GestureDockConstants.GESTURE_DOCK_ICON_SIZE + GestureDockConstants.GESTURE_DOCK_ITEM_DISTANCE;
      let recentDistance: number = 0;
      if (this.dockBarScrollerParam.recentApps.length > 0) {
        recentDistance = Math.min(this.dockBarScrollerParam.recentApps.length,
          GestureDockConstants.GESTURE_DOCK_MAX_RECENT) * singleItemSize +
        GestureDockConstants.GESTURE_DOCK_ITEM_DISTANCE;
      }
      let moveDistance = (index - 1) * singleItemSize + recentDistance;
      let direction = this.dockViewModel.getViewData()?.getGestureDockDirection();
      let scroller = this.viewDataMgr.getScroller(direction === GestureDockState.GESTURE_DOCK_LEFT_OUT);
      log.showInfo(`scrollToDeleteItemIndex currentOffset: ${scroller.currentOffset()
        .yOffset}, yOffset: ${moveDistance}, index: ${index}, `);
      if (moveDistance < scroller.currentOffset().yOffset) {
        let scrollDistance = Math.max(scroller.currentOffset().yOffset - singleItemSize, 0);
        scroller.scrollTo({
          xOffset: 0, yOffset: scrollDistance
        });
      }
    }
  }

  /**
   * dock位移动效
   *
   * @param translation
   * @param isLeftDock
   */
  public doDockTranslate(translation: number, isLeftDock?: boolean): void {
    let isLeft = isLeftDock ?? (
      this.dockViewModel.getViewData()?.getGestureDockDirection() === GestureDockState.GESTURE_DOCK_LEFT_OUT);
    if (isLeft) {
      this.leftBarOutParam.translation = translation;
    } else {
      this.rightBarOutParam.translation = translation;
    }
  }

  /**
   * 返回最近侧边栏最近任务区真实显示的数据
   *
   * @returns GestureDockItemInfo[]
   */
  public getRecentApps(): GestureDockItemInfo[] {
    if (this.dockBarScrollerParam.isRecentAppShow) {
      return this.dockBarScrollerParam.recentApps.slice(0, GestureDockConstants.GESTURE_DOCK_MAX_RECENT);
    }
    return [];
  }
}