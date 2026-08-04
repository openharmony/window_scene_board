/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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

import { LogDomain, LogHelper, CheckEmptyUtils, CommonUtils } from '@ohos/basicutils';
import { SCBSceneSessionManager,
  ResUtils,
  SCBSceneContainerSession,
  SCBScreenProperty,
  SessionLabelListener,
  SCBSystemSceneSession,
  windowMgr,
  INVALID_SCREEN_ID
} from '@ohos/windowscene';
import {
  GlobalContext,
  ResourceManager,
  viewMgrPolicy,
  ViewType,
  ViewArea,
  ViewCallback,
  localEventManager,
  IconResourceManager
} from '@ohos/frameworkwrapper';
import {
  EventConstants,
  ShortcutViewModel,
  StyleConstants,
  DockItemInfo,
  CommonConstants,
  AppModel,
  DockContinuableInfo,
  HiSysContinueFuncResult,
  SCBHiSysEventUtil
} from '@ohos/launchercommon/src/main/ets/TsIndex';
import { RecentBundleMissionInfo } from '@ohos/launchercommon';
import { PopupViewController } from '../common/PopupViewController';
import { PcTouchOutSideMgr, TouchOutsideListener } from '../manager/PcTouchOutSideMgr';
import animator from '@ohos.animator';
import image from '@ohos.multimedia.image';
import { WindowConstants } from '@ohos/commonconstants/src/main/ets/TsIndex';
import { LazyDataSource } from '@ohos/launchercommon/Index';
import SmartDockModel from '@ohos/smartdock/src/main/ets/default/model/SmartDockModel';
import { SnapshotInfo } from '@ohos/launchercommon';
import { FixedDockResource } from '../common/constants/FixedDockConstants';
import { PreviewImageLabelName } from './PreviewImageLabelName';
import { PcDockHiSysEventMgr } from '../manager/PcDockHiSysEventMgr';
import { curves, MeasureUtils } from '@kit.ArkUI';
import { PcDockPopupMgr } from '../manager/PcDockPopupMgr';
import { PCDockUtils } from '../utils/PCDockUtils';
import componentUtils from '@ohos.arkui.componentUtils';
import { ItemUtils } from '@ohos/componenthelper';
import { resourceManager } from '@kit.LocalizationKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { PcDockStyleConfig, PcSmartDockStyleManager } from '../common/PcSmartDockStyleManager';
import SmartDockConstants from '@ohos/smartdock/src/main/ets/default/common/constants/SmartDockConstants';

let moveToFrontDelayTimer: number | null = null;
let showTipsDelayTimer: number | null = null;
const TAG = 'ScrollerComponent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, 'PCDock-' + TAG);
const HOVER_OUT_POPUP_DELAY = 300;
const POPUP_TIP_SHOW_DELAY = 700;
const CONTINUE_ABILITY = 'continueAbility';

function clearMoveToFrontDelayTimer(): void {
  if (moveToFrontDelayTimer) {
    clearTimeout(moveToFrontDelayTimer);
    moveToFrontDelayTimer = null;
  }
}

@Component
export struct FixedScrollerComponent {
  persistentId: number = 0;
  @Link screenProp: SCBScreenProperty;
  private isMainScreen: boolean = this.screenProp.screenId === SCBSceneSessionManager.getInstance().mainScreenId;
  private viewType: ViewType = this.isMainScreen ? ViewType.POPUP_PANEL : ViewType.POPUP_PANEL_EXT;
  private windowName: string = this.isMainScreen ? WindowConstants.WINDOW_NAME_DOCK_POPUP_PANEL :
    WindowConstants.WINDOW_NAME_DOCK_EXT_POPUP_PANEL;
  private touchOutsideSession: SCBSystemSceneSession | null = null;
  @State popupPanelCtrl: PopupViewController = new PopupViewController(this.viewType, this.screenProp.screenId);
  private popupMgr: PcDockPopupMgr = PcDockPopupMgr.getInstance();
  @State mPopItem: DockItemInfo = new DockItemInfo();
  private mViewCallback: ViewCallback = {
    onShow: () => { this.onViewShow(); },
    onHide: () => { this.onViewHide(); }
  };
  private updateData: Function = (show: boolean, bundleName: number, callback: Callback<void>): void => {
    log.showInfo(`updateData ${show}, ${bundleName}`);
    callback();
    if (!show) {
      this.popupMgr.hide(this.screenProp.screenId, 0, true);
    }
  };
  private mSmartDockModel: SmartDockModel = SmartDockModel.getInstance();
  @State mCurrentBoxWidth: number = 0;
  private mMaxBoxWidth: number = 0;
  private mScroller: Scroller = new Scroller();
  private ratio: number = 1;
  private uiContextMeasure: MeasureUtils = this.getUIContext().getMeasureUtils();
  @State hoverFlag: boolean = false;
  @State isDragging: boolean = false;
  @StorageLink('snapshotList') @Watch('onSnapshotListChange') mSnapshotList: SnapshotInfo[] = [];
  // 折叠PC 磁吸态的时候，popup的屏幕高度需要取B面的高度
  @StorageProp('foldPopupPanelHeight') foldPopupPanelHeight: number = 0;
  private dataListCache: PreviewImageItem[] = [];
  private isUgCN: number = 1;
  @State dataList: PreviewImageItem[] = [];
  @State data: LazyDataSource<SnapshotInfo> = new LazyDataSource<SnapshotInfo>();
  @State missionId: number = -1;
  @State isShowCloseButton: boolean = false;
  @State currentWidth: number = 0;
  @State styleChange: boolean = false;
  @State isHover?: boolean = false;
  @State appName: string = '';
  @State baseNum: number = 0;
  @State isRunning: boolean = false;
  @State endOffset: number = 0;
  @State isHorizontal: boolean = true;
  @State missionList: PreviewImageItem[] = [];
  @State currentListHeight: number = 0;
  @State panelRadio: number = StyleConstants.DEFAULT_16;
  @StorageLink('currColorMode') @Watch('onColorModeChange') currColorMode: number = GlobalContext.getContext().config.colorMode as number;
  @StorageLink('systemLanguage') @Watch('languageChange') language: string = '';
  @StorageLink('continueDeviceInfo') @Watch('onContinueDeviceChange') deviceInfo: DockContinuableInfo = new DockContinuableInfo();
  @State mBorderColor: string = FixedDockResource.OUTLINE_LIGHT_COLOR;
  @State continuableItemBgColor: string = FixedDockResource.LIGHT_CONTINUABLE_PREVIEW_BG_COLOR;
  @State isLabelNameShow: boolean = false;
  @State popupPanelWidth: number = 0;
  @State listShowTextWidth: number = FixedDockResource.PREVIEW_TEXT_WIDTH;
  @StorageLink('missionInfoList') @Watch('closePopup') missionInfoList: Array<RecentBundleMissionInfo> = [];
  private onColorModeChange(): void {
    this.mBorderColor = this.currColorMode === 0 ?
      FixedDockResource.OUTLINE_DART_COLOR : FixedDockResource.OUTLINE_LIGHT_COLOR;
    this.continuableItemBgColor = this.currColorMode === ColorMode.DARK ?
      FixedDockResource.LIGHT_CONTINUABLE_PREVIEW_BG_COLOR : FixedDockResource.DARK_CONTINUABLE_PREVIEW_BG_COLOR;

  }
  private scrollBarWidth: Resource = $r('app.float.ntf_scrollbar_inner_width');

  private closePopup(): void {
    if (!SmartDockModel.getInstance().checkAppIsRunning(this.mPopItem)) {
      this.popupMgr.setIsHoverSnapshot(this.screenProp.screenId, false);
      this.popupPanelCtrl.hide()
    }
  }

  private languageChange(): void {
    if (this.language === 'ug-CN') {
      this.isUgCN = -1;
    } else {
      this.isUgCN = 1;
    }
  }

  private getMaxWidth(): number {
    let maxWidth = (px2vp(this.screenProp.width) - FixedDockResource.PREVIEW_SCREEN_PADDING * 2) /
      PcSmartDockStyleManager.getStyle(this.screenProp).mRatio;
    log.showInfo(`screenWidthChange, maxWidth: ${maxWidth}`);
    return maxWidth;
  }

  private onViewShow(): void {
    this.isShowCloseButton = this.popupMgr.getIsShowCloseButton();
    const curShowingItem = this.popupMgr.getCurShowingItem();
    if (!curShowingItem) {
      this.popupPanelCtrl.hide();
      log.showError('onViewShow return with hide popup. curShowingItem is null');
      return;
    }
    this.mPopItem = curShowingItem;
    this.updateIsRunning();
    log.showInfo(`onViewShow ${this.mPopItem?.bundleName}, isRunning: ${this.isRunning}, dataListCache.length: ${this.dataListCache.length} isShowCloseButton: ${this.isShowCloseButton}`);
    const isItemOnHover = this.mPopItem.keyName === this.popupMgr.getCurrItem()?.keyName &&
    this.mSmartDockModel.checkAppInstanceKey(this.mPopItem?.appInstanceKey,
      this.popupMgr.getCurrItem()?.appInstanceKey);
    PCDockUtils.updateDockMissionsPopupShow(true, isItemOnHover, this.mPopItem, this.screenProp.screenId);
    // 更新显示数据
    this.updateName();
    this.updateDataList();

    // 更新popup大小和位置
    this.updatePopupSize();
  }

  private releaseResource(): void {
    this.dataList.length = 0;
    this.dataListCache.length = 0;
    this.missionList.length = 0;
    PCDockUtils.clearSnapshotList();
  }

  private onViewHide(): void {
    log.showInfo(`onViewHide ${this.mPopItem?.bundleName},isLabelNameShow:${this.isLabelNameShow}`);
    this.popupMgr.setIsShowCloseButton(false);
    this.isShowCloseButton = false;
    if (this.isLabelNameShow) {
      return;
    }
    const isItemOnHover = this.mPopItem.keyName === this.popupMgr.getCurrItem()?.keyName;
    PCDockUtils.updateDockMissionsPopupShow(false, isItemOnHover, this.mPopItem, this.screenProp.screenId);
    this.releaseResource();
  }

  private updatePopupItemCallback = () => {
    log.showInfo(`updatePopupItemCallback ${this.mPopItem?.bundleName},isLabelNameShow:${this.isLabelNameShow}`);
    const isItemOnHover = this.mPopItem.keyName === this.popupMgr.getCurrItem()?.keyName;
    this.mPopItem = this.popupMgr.getCurShowingItem()!;
    this.updateIsRunning();
    log.showInfo(`onViewShow ${this.mPopItem?.bundleName}, isRunning: ${this.isRunning}, dataListCache.length: ${this.dataListCache.length}`);
    PCDockUtils.updateDockMissionsPopupShow(true, isItemOnHover, this.mPopItem, this.screenProp.screenId);
    // 更新显示数据
    this.updateName();
    this.updateDataList();
    // 更新popup大小和位置
    this.updatePopupSize();
  };

  private updateDataList(): void {
    if (this.isRunning) {
      this.initMissionList();
      this.isHorizontal = this.isInnerScreenWidth(this.dataListCache);
      if (this.isHorizontal) {
        let listTemp: PreviewImageItem[] = this.dataList;
        // 1. 删除 dataList 中存在但 dataListCache 中没有的元素
        listTemp = listTemp.filter(dataItem => this.dataListCache.some(dataCacheItem =>
        dataItem.snapshotInfo.missionId === dataCacheItem.snapshotInfo.missionId));
        // 2. 将 dataListCache 中有而 dataList 中没有的元素加到 dataList 中
        const toAdd = this.dataListCache.filter(dataCacheItem => !listTemp.some(
          dataItem => dataItem.snapshotInfo.missionId === dataCacheItem.snapshotInfo.missionId));
        listTemp.push(...toAdd.map(info => new PreviewImageItem(info.snapshotInfo,
          this.initLabelName(info.snapshotInfo))));
        // 3. 更新 dataList 中与 dataListCache 中相同 missionId 的元素
        listTemp.forEach(dataItem => {
          const matchingBItem = this.dataListCache.find(dataCacheItem =>
          dataCacheItem.snapshotInfo.missionId === dataItem.snapshotInfo.missionId);
          if (matchingBItem) {
            dataItem.snapshotInfo = matchingBItem.snapshotInfo;
          }
          dataItem.labelName = this.initLabelName(dataItem.snapshotInfo);
        });
        listTemp.sort((itemA, itemB) => itemA.snapshotInfo.missionId - itemB.snapshotInfo.missionId);
        this.dataList = listTemp;
      }
    }
  }

  private updateListHeight(): void {
    this.currentListHeight = this.missionList.length *
    (FixedDockResource.PREVIEW_LIST_ITEM_HEIGHT + FixedDockResource.PREVIEW_LIST_SPACE) -
    FixedDockResource.PREVIEW_LIST_SPACE;
  }

  private updateName(): void {
    let name = '';
    switch (this.mPopItem?.abilityName) {
      case CommonConstants.APPCENTER_ABILITY:
        name = ResUtils.getInnerStringByName('dock_hover_text_appcenter');
        break;
      case CommonConstants.RECENT_ABILITY:
        name = ResUtils.getInnerStringByName('dock_hover_text_recentcenter');
        break;
      case CommonConstants.RECYCLE_BIN_ABILITY:
        name = ResUtils.getInnerStringByName('dock_hover_text_recyclebin');
        break;
      default:
        break;
    }
    if (name !== '') {
      this.setAppNameWithCacheCallback(name);
      return;
    }
    if (this.isShortcut(this.mPopItem) && !CheckEmptyUtils.isEmpty(this.mPopItem?.appName)) {
      this.setAppNameWithCacheCallback(this.mPopItem?.appName);
    } else {
      IconResourceManager.getInstance().getAppNameWithCallback(this.mPopItem?.appLabelId, this.mPopItem?.bundleName,
        this.mPopItem?.moduleName, '', (name: string) => {
        if (CheckEmptyUtils.checkStrIsEmpty(name)) {
          log.showWarn('ResourceManager getAppNameWithCache empty');
          this.setAppNameWithCacheCallback(this.mPopItem?.appName);
        } else {
          this.setAppNameWithCacheCallback(name);
        }
      });
    }
  }

  private isShortcut(item: DockItemInfo): boolean {
    return item?.typeId === CommonConstants.TYPE_SHORTCUT_ICON || !!item?.shortcutId;
  }

  private setAppNameWithCacheCallback(name: string) {
    this.appName = name;
    if (this.mPopItem?.appIndex !== undefined && this.mPopItem?.appIndex > 0) {
      this.appName = name + this.mPopItem?.appIndex;
    }
    log.showDebug(`updateName end: ${this.appName}`)
  }

  private onContinueDeviceChange(): void {
    if (!this.isMainScreen || !this.popupPanelCtrl.isShowing()) {
      return;
    }
    if (!this.isRunning) {
      this.updatePopupSize();
      return;
    }
    const isContinueItemExist: boolean = PCDockUtils.isContinuableItemExists(this.deviceInfo);
    const index = this.dataList.findIndex((info) => info.snapshotInfo.bundleName === CONTINUE_ABILITY);
    log.showInfo(`onContinueDeviceChange isContinueItemExist: ${isContinueItemExist}, index: ${index}`);
    if (!isContinueItemExist && index >= 0) {
      this.dataList.splice(index, 1);
      this.updatePopupSize();
    }
    if (isContinueItemExist && index === -1) {
      this.onSnapshotListChange();
    }
  }

  private isAdded(): boolean {
    return this.dataListCache?.findIndex(item => item?.snapshotInfo?.bundleName === CONTINUE_ABILITY) >= 0;
  }

  private checkIsAddContinuableItem(): void {
    if (!this.isRunning || !this.isContinueMerged() || this.isAdded()) {
      return;
    }
    log.showInfo('addContinuableItemData');
    const snapshot: SnapshotInfo = new SnapshotInfo();
    snapshot.left = StyleConstants.DEFAULT_12;
    snapshot.missionId = 99999;
    snapshot.boxSize = StyleConstants.DEFAULT_SMART_DOCK_MISSION_IMAGE_WIDTH;
    snapshot.bundleName = CONTINUE_ABILITY;
    snapshot.shortcutId = this.mPopItem.shortcutId;
    snapshot.image = IconResourceManager.getInstance().getCachedCombIconSync(this.mPopItem?.bundleName,
      this.mPopItem?.moduleName as string, this.mPopItem?.abilityName);
    this.dataListCache.push(new PreviewImageItem(snapshot, this.initLabelName(snapshot)));
    this.missionList.push(new PreviewImageItem(snapshot, this.initLabelName(snapshot)));
  }

  private isContinueMerged(): boolean {
      return this.isMainScreen && PCDockUtils.isSameBundle(this.deviceInfo.bundleName,
        this.mPopItem?.bundleName) && (this.mPopItem.appIndex ?? 0) === 0;
  }

  private async onSnapshotListChange(): Promise<void> {
    if (this.mSnapshotList.length === 0) {
      log.showInfo(`onSnapshotListChange return. snapshotList has been cleared. dataListCache: ${this.dataListCache.length}`);
      return;
    }
    const snapshotItem = this.popupMgr.getCurrItem();
    if (!CheckEmptyUtils.isEmptyArr(this.mSnapshotList) &&
      !PCDockUtils.isSameBundle(this.mSnapshotList[0].bundleName, (snapshotItem?.bundleName ?? ''))) {
      log.showWarn(`onSnapshotListChange return. snapshotList bundleName ${this.mSnapshotList[0].bundleName} is not equal with ${snapshotItem?.bundleName}`);
      return;
    }
    log.showInfo(`${snapshotItem?.bundleName} onSnapshotListChange start. mSnapshotList.length: ${this.mSnapshotList.length}, dataListCache.length: ${this.dataListCache.length}`);
    const toReplace = this.mSnapshotList.filter(snapshotInfo => this.dataListCache.some(
      item => snapshotInfo.missionId === item.snapshotInfo.missionId));
    const toAdd = this.mSnapshotList.filter(info => !this.dataListCache.some(
      item => item.snapshotInfo.missionId === info.missionId));
    this.dataListCache = [];
    this.dataListCache.push(...toReplace.map(info => new PreviewImageItem(info, this.initLabelName(info))));
    this.dataListCache.push(...toAdd.map(info => new PreviewImageItem(info, this.initLabelName(info))));
    await this.filterSnapIfHoverOnShortcut(snapshotItem);
    this.baseNum = 0;
    log.showInfo(`${snapshotItem?.bundleName} onSnapshotListChange end. dataListCache.length: ${this.dataListCache.length}. toReplace.length: ${toReplace.length}, toAdd: ${toAdd.length}`);
    let tempDisplayMode = this.isInnerScreenWidth(this.dataListCache) ? Axis.Horizontal : Axis.Vertical;
    if (tempDisplayMode === Axis.Vertical && snapshotItem) {
      await this.popupMgr.updateCurItemIcon(snapshotItem);
    }
    if (this.popupMgr.getCurItemNeedRefreshUI(this.screenProp.screenId)) {
      log.showWarn('onSnapshotListChange end with showPopup');
      this.popupPanelCtrl.show();
      animateTo({
        duration: FixedDockResource.HOVER_PREVIEW_SHOW_ANIM_DURATION,
      }, () => {
        this.popupPanelCtrl.setOpacity(1);
        if (this.popupPanelCtrl.isShowing()) {
          this.updatePopupItemCallback();
        }
      });
      this.popupMgr.setCurItemNeedRefreshUI(this.screenProp.screenId, false);
    }
  }

  private updateIsRunning(): void {
    this.isRunning = this.mSmartDockModel.checkAppIsRunning(this.mPopItem);
    log.showDebug(`updateIsRunning ${this.mPopItem?.bundleName} isRunning: ${this.isRunning}`);
  }

  private async filterSnapIfHoverOnShortcut(snapshotItem: DockItemInfo | null) {
    if (!snapshotItem) {
      return;
    }
    const hoverOnShortcut = !!snapshotItem.shortcutId;
    let popAbility = snapshotItem.abilityName;
    if (hoverOnShortcut) {
      const shortcutInfo = await ShortcutViewModel.getInstance().getShortcutInfo(snapshotItem);
      popAbility = shortcutInfo?.wants?.[0].targetAbility || popAbility;
    }
    this.dataListCache = this.dataListCache.filter(item => {
      if (!PCDockUtils.isSameBundle(item.snapshotInfo.bundleName, snapshotItem.bundleName)) {
        return false;
      }
      if (!item.snapshotInfo.shortcutId) {
        return true;
      }
      log.showInfo(`filterSnapshot, snapshotShortcutId:${item.snapshotInfo.shortcutId}, hoverShortcutId:${snapshotItem.shortcutId}`);
      if (item.snapshotInfo.shortcutId !== snapshotItem.shortcutId) {
        return false;
      }
      return true;
    })
  }

  private updatePopupSize(): void {
    log.showInfo(`updatePopupSize start: ${this.mPopItem.bundleName} currentWidth: ${this.currentWidth}, mCurrentBoxWidth: ${this.mCurrentBoxWidth}, isHorizontal: ${this.isHorizontal}, dataList.length: ${this.dataList.length}`);
    if (this.isHorizontal) {
      // popup为水平列表时，宽度需要计算，高度固定；popup为竖向列表时，宽度固定，高度自适应
      let sumBoxWidth = 0;
      for (let index = 0; index < this.dataList.length; index++) {
        const mission = this.dataList[index].snapshotInfo;
        if (mission) {
          sumBoxWidth += this.getSnapshotWidth(mission) + FixedDockResource.SNAPSHOT_GAP;
        } else {
          log.showError(`updateCurrentWidth error, dataList[${index}] is invalid!`);
        }
      }
      this.mCurrentBoxWidth = sumBoxWidth;
      this.currentWidth = this.mCurrentBoxWidth +
        (sumBoxWidth > 0 ? FixedDockResource.PREVIEW_MARGIN_WHEN_NO_ARROW : 0);
    }
    log.showInfo(`updatePopupSize end: ${this.mPopItem.bundleName} ${this.currentWidth} ${this.mCurrentBoxWidth}`);
    this.updatePopupPanelRect();
  }

  private getWidth(): number | string {
    if (!this.isRunning) {
      if (this.isContinueMerged() && PCDockUtils.isContinuableItemExists(this.deviceInfo)) {
        // 计算接续图标容器宽需要算上padding和margin, 不然和实际的popup组件算出来不一致
        const marginAndPadding: number = (SmartDockConstants.CONTINUABLE_ICON_POPUP_PADDING.left as number) +
          (SmartDockConstants.CONTINUABLE_ICON_POPUP_PADDING.right as number) +
          SmartDockConstants.CONTINUABLE_ICON_POPUP_TEXT_MARGIN * StyleConstants.DEFAULT_2;
        const maxWidth: number = px2vp(this.screenProp.width) * 2 / 3;
        const title: string = this.deviceInfo?.appName ? this.deviceInfo?.appName : this.appName;
        const titleWidth: number = this.getTextWidth(title,
          SmartDockConstants.CONTINUABLE_ICON_POPUP_TITLE_SIZE, 0, maxWidth, 0);
        const desc: string = getContext().resourceManager.getStringSync($r('app.string.continue_hap_come_from').id, this.deviceInfo?.sourceDeviceName ?? '');
        const descWidth: number = this.getTextWidth(desc,
          SmartDockConstants.CONTINUABLE_ICON_POPUP_DESC_SIZE, 0, maxWidth, 0);
        return Math.max(titleWidth, descWidth) + marginAndPadding;
      }
      return this.getAppNameTextWidth(this.appName);
    }
    if (!this.isHorizontal) {
      return this.listShowTextWidth + FixedDockResource.PREVIEW_LIST_IAMGE_MARGIN;
    }
    if (this.currentWidth > this.getMaxWidth()) {
      return this.getMaxWidth();
    } else {
      return this.currentWidth;
    }
  }

  private getAppNameTextWidth(appName: string): number {
    let width: number = FixedDockResource.POPUP_MIN_TEXT_WIDTH;
    if (CheckEmptyUtils.checkStrIsEmpty(appName)) {
      return width;
    }
    const maxWidth: number = px2vp(this.screenProp.width) * 2 / 3;
    width = this.getTextWidth(appName, $r('sys.float.Body_M'), width, maxWidth);
    return width;
  }

  private getAppNameTextHeight(appName: string): number | string {
    let height: number | string = FixedDockResource.POPUP_MIN_TEXT_HEIGHT;
    if (CheckEmptyUtils.checkStrIsEmpty(appName)) {
      return height;
    }
    const panelHeight = this.getPanelHeight();
    const maxHeight: number = panelHeight * 2 / 3;
    height = this.getTextHeight(appName, $r('sys.float.Body_M'), height, maxHeight);
    return height;
  }

  private getTextWidth(appName: string, size: number | string | Resource, width: number, maxWidth: number,
    defaultRadius: number = StyleConstants.DEFAULT_16): number {
    let needTextWidth: number = Math.round(px2vp(this.uiContextMeasure.measureTextSize({
      textContent: appName,
      fontSize: size,
      fontWeight: FontWeight.Regular,
      overflow: TextOverflow.Ellipsis,
      maxLines: 1
    }).width as number)) + defaultRadius;
    needTextWidth = needTextWidth > maxWidth ? maxWidth : needTextWidth;
    return needTextWidth > width ? needTextWidth : width;
  }

  private getTextHeight(appName: string, size: number | string | Resource, height: number, maxHeight: number,
    defaultRadius: number = StyleConstants.DEFAULT_16): number {
    let needTextHeight: number = Math.round(px2vp(this.uiContextMeasure.measureTextSize({
      textContent: appName,
      fontSize: size,
      fontWeight: FontWeight.Regular,
      overflow: TextOverflow.Ellipsis,
      maxLines: 1
    }).height as number)) + defaultRadius;
    needTextHeight = needTextHeight > maxHeight ? maxHeight : needTextHeight;
    return needTextHeight > height ? needTextHeight : height;
  }

  private getSnapshotWidth(item: SnapshotInfo): number {
    if (CheckEmptyUtils.isEmpty(item) || !item.boxSize) {
      return FixedDockResource.SNAPSHOT_ITEM_DEFAULT_WIDTH;
    } else if (item.boxSize < FixedDockResource.SNAPSHOT_ITEM_MIN_WIDTH) {
      return FixedDockResource.SNAPSHOT_ITEM_MIN_WIDTH;
    } else {
      return item.boxSize;
    }
  }

  private getName(): string {
    return this.appName;
  }

  @Builder
  ContinueItemTipsBuilder() {
    Column() {
      Text(this.deviceInfo?.appName ? this.deviceInfo?.appName : this.appName)
        .draggable(false)
        .fontSize(SmartDockConstants.CONTINUABLE_ICON_POPUP_TITLE_SIZE)
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .margin(SmartDockConstants.CONTINUABLE_ICON_POPUP_TEXT_MARGIN)
      Text(getContext().resourceManager.getStringSync($r('app.string.continue_hap_come_from').id, this.deviceInfo?.sourceDeviceName ?? ''))
        .draggable(false)
        .fontSize(SmartDockConstants.CONTINUABLE_ICON_POPUP_DESC_SIZE)
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .margin(SmartDockConstants.CONTINUABLE_ICON_POPUP_TEXT_MARGIN)
    }
    .width(this.getWidth())
    .height(this.getHeight())
    .alignItems(HorizontalAlign.Start)
    .padding(SmartDockConstants.CONTINUABLE_ICON_POPUP_PADDING)
  }

  @Builder
  tipsBuilder() {
    if (this.isContinueMerged() && PCDockUtils.isContinuableItemExists(this.deviceInfo)) {
      this.ContinueItemTipsBuilder();
    } else {
      Row() {
        Text(this.getName())
          .draggable(false)
          .width(this.getWidth())
          .height(this.getAppNameTextHeight(this.appName))
          .fontSize($r('sys.float.Body_M'))
          .fontColor($r('sys.color.ohos_id_color_text_primary'))
          .fontWeight(FontWeight.Regular)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .textAlign(TextAlign.Center)
          .maxLines(1)
          .align(Alignment.Center)
      }
      .scale({
        x: PcSmartDockStyleManager.getStyle(this.screenProp).mRatio,
        y: PcSmartDockStyleManager.getStyle(this.screenProp).mRatio,
        centerX: this.isUgCN === 1 ? '0%' : '100%',
      })
      .height(this.getHeight())
      .justifyContent(FlexAlign.Center)
      .padding({ top: FixedDockResource.TIPS_TEXT_PADDING })
    }
  }


  @Builder
  previewImageBuilder() {
    List({ space: FixedDockResource.SNAPSHOT_GAP, scroller: this.mScroller }) {
      ForEach(this.dataList, (item: PreviewImageItem) => {
        ListItem() {
          PreviewImageComponent({
            item: item,
            mPopItem: this.mPopItem,
            updatePopupPanelRect: () => { this.updatePopupPanelRect(); },
            updateData: this.updateData,
            appName: this.appName,
            isDragging: this.isDragging,
            hoverFlag: this.hoverFlag,
            isHover: this.isHover,
            styleChange: this.styleChange,
            dataList: this.dataList,
            ratio: PcSmartDockStyleManager.getStyle(this.screenProp).mRatio,
            currentWidth: this.currentWidth,
            currentListHeight: this.currentListHeight,
            mMaxBoxWidth: this.mMaxBoxWidth,
            mMaxWidth: this.getMaxWidth(),
            isShowCloseButton: this.isShowCloseButton,
            mCurrentBoxWidth: this.mCurrentBoxWidth,
            baseNum: this.baseNum,
            endOffset: this.endOffset,
            screenProp: this.screenProp,
            continuableItemBgColor: this.continuableItemBgColor,
            isUgCN: this.isUgCN
          })
        }
        .transition(this.missionId === item.snapshotInfo.missionId ?
          // 只需要删除动效，所以使用不对成的过度效果
          TransitionEffect.asymmetric(// 入场动效：无
            TransitionEffect.IDENTITY,
            // 退场动效：尺寸缩放变化+透明度变化
            TransitionEffect.scale({ x: 0.7, y: 0.7 })
              .animation({ curve: curves.interpolatingSpring(0, 1, 528, 44) })
              .combine(
                TransitionEffect.OPACITY.animation({ curve: curves.interpolatingSpring(0, 1, 528, 44) })
              )
          ) : undefined
        )
      }, (item: PreviewImageItem, index: number) => `${item.snapshotInfo.missionId}_${item.labelName}_${index}`)
    }
    .scale({
      x: PcSmartDockStyleManager.getStyle(this.screenProp).mRatio,
      y: PcSmartDockStyleManager.getStyle(this.screenProp).mRatio
    })
    .offset({
      x: PcSmartDockStyleManager.getStyle(this.screenProp).mRatio === 1 ?
        0 : -(this.currentWidth * (1 - PcSmartDockStyleManager.getStyle(this.screenProp).mRatio) / 2) * this.isUgCN,
      y: 0,
    })
    .contentStartOffset(FixedDockResource.SNAPSHOT_GAP / 2)
    .contentEndOffset(FixedDockResource.SNAPSHOT_GAP / 2)
    .listDirection(Axis.Horizontal)
    .align(Alignment.Center)
    .width(this.mCurrentBoxWidth)
    .height(this.getHeight())
    .onDidScroll((scrollOffset: number, scrollState: ScrollState) => {
      this.endOffset = scrollOffset;
    })
    .edgeEffect(EdgeEffect.None)
    .margin({
      left: FixedDockResource.SNAPSHOT_GAP,
      right: FixedDockResource.SNAPSHOT_GAP
    })
    .scrollBar(BarState.Off)
  }

  aboutToAppear() {
    log.showInfo(`aboutToAppear happened:${this.mPopItem.bundleName}, ${this.screenProp.width}`);
    this.popupPanelCtrl.updateId(this.persistentId);
    this.popupPanelCtrl?.registerCallback(this.mViewCallback);
    this.languageChange();
    viewMgrPolicy.registerViewController(this.viewType, this.popupPanelCtrl);
    if (this.isMainScreen) {
      this.touchOutsideSession =
        SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(this.persistentId, this.screenProp.screenId);
      if (!CommonUtils.isInvalid(this.touchOutsideSession)) {
        this.touchOutsideSession.registerTouchOutsideCallback(this.onTouchOutside);
      } else {
        log.showError(`getSystemSceneSessionWithId fail, , ${this.persistentId}, ${this.screenProp.screenId}`);
      }
    } else {
      this.touchOutsideListener.onDealTouchOutside = (x: number, y: number) => {
          log.showInfo(`extend screen onDealTouchOutside ${this.windowName},${windowMgr.isShowing(this.windowName)}, x:${x}, y:${y}`);
          this.dealTouchOutside(x, y);
        }

      PcTouchOutSideMgr.getInstance().registerDataChangeListener(this.touchOutsideListener);
    }
    this.popupMgr.registerViewController(this.popupPanelCtrl, this.screenProp.screenId);
    this.popupMgr.registerUpdateCallback(this.screenProp.screenId, this.updatePopupItemCallback);
    this.mMaxBoxWidth = this.getMaxWidth() - 2 * FixedDockResource.PREVIEW_MARGIN_WHEN_HAS_ARROW;
    this.onColorModeChange();
  }

  private touchOutsideListener: TouchOutsideListener = new TouchOutsideListener();

  private onTouchOutside = (x: number, y: number): void => {
    log.showInfo(`masin screen onTouchOutside ${this.windowName},${windowMgr.isShowing(this.windowName)}, x:${x}, y:${y}`);
    this.dealTouchOutside(x, y);
    if (this.screenProp.screenId === 0) {
      PcTouchOutSideMgr.getInstance().notifyTouchOutside(x, y);
    }
  };

  private dealTouchOutside = (x: number, y: number): void => {
    if (!windowMgr.isShowing(this.windowName)) {
      return;
    }
    const rect = this.popupPanelCtrl.getArea();
    if (x >= vp2px(rect.left) && x <= (vp2px(rect.left + rect.width)) &&
      y >= vp2px(rect.top) && y <= vp2px(rect.top + rect.height)) {
      log.showInfo(`dealTouchOutside in ctrl area`);
      return;
    }

    if (this.isTouchInCurrentPopupItem(x, y)) {
      log.showInfo('dealTouchOutside in popup dock item')
      return;
    }
    log.showInfo(`onTouchOutside ${this.windowName} - ${this.viewType} outside hide`);
    windowMgr.hideWindowWithAnim(this.windowName);
  };

  private isTouchInCurrentPopupItem(x: number, y: number): boolean {
    const appIconId: string = PCDockUtils.getAppItemColumnId(this.mPopItem);
    log.showInfo(`isTouchInCurrentPopupItem appIconId: ${appIconId}`);
    let cmpRect = ItemUtils.getCmpRect(appIconId, this.screenProp.screenId, this.getUIContext());
    if (CheckEmptyUtils.isEmpty(cmpRect)) {
      return false;
    }
    const cmpRectWidth: number = cmpRect?.right - cmpRect?.left;
    const cmpRectHeight: number = cmpRect?.bottom - cmpRect?.top;
    if (cmpRect.right === 0 && cmpRect.left === 0 && cmpRectWidth === 0 && cmpRectHeight === 0) {
      return false;
    }
    log.showInfo(`isTouchInCurrentPopupItem left: ${vp2px(cmpRect?.left)}, top: ${vp2px(cmpRect?.top)}, width: ${vp2px(cmpRectWidth)}, height: ${vp2px(cmpRectHeight)}`);
    if (x >= vp2px(cmpRect?.left) && x <= vp2px((cmpRect?.left + cmpRectWidth)) &&
      y >= vp2px(cmpRect?.top) && y <= vp2px(cmpRect?.top + cmpRectHeight)) {
      return true;
    }
    return false;
  }

  private updateStatusIconCaches(): void {
    const rect: ViewArea = this.popupPanelCtrl.getArea();
    const area: Area = {
      width: rect.width,
      height: rect.height,
      position: {
        x: rect.left,
        y: rect.top
      },
      globalPosition: {
        x: rect.left,
        y: rect.top
      }
    }
    windowMgr.setStatusIconCaches(WindowConstants.WINDOW_NAME_DOCK_POPUP_PANEL, area);
  }

  aboutToDisappear() {
    this.popupPanelCtrl?.unRegisterCallback(this.mViewCallback);
    this.popupMgr.unregisterViewController(this.screenProp.screenId);
    this.popupMgr.unRegisterUpdateCallback(this.screenProp.screenId);
    viewMgrPolicy.unregisterViewController(this.viewType);
    if (this.isMainScreen) {
      this.touchOutsideSession?.unregisterTouchOutsideCallback();
      this.touchOutsideSession = null;
    } else {
      PcTouchOutSideMgr.getInstance().unregisterDataChangeListener(this.touchOutsideListener)
    }
    log.showInfo(`aboutToDisAppear happened:${this.mPopItem.bundleName}`);
  }

  private updatePopupPanelRect(): void {
    let config: PcDockStyleConfig = PcSmartDockStyleManager.getStyle(this.screenProp);
    let ratio = config.mRatio;
    let panelRadio = this.isRunning && this.isHorizontal ? StyleConstants.DEFAULT_16 : StyleConstants.DEFAULT_8;
    let systemSceneSession = SCBSceneSessionManager.getInstance()
      .getSystemSceneSessionWithId(this.persistentId, this.screenProp.screenId);
    if (systemSceneSession) {
      systemSceneSession.setBorderRadius(panelRadio);
      this.panelRadio = panelRadio;
      log.showInfo(`updatePopupPanelRect panelRadio: ${panelRadio}`);
    }
    try {
      log.showInfo(`updatePopupPanelRect at ${this.popupMgr.getCurShowingItemId()}.`);
      let info: componentUtils.ComponentInfo = componentUtils.getRectangleById(this.popupMgr.getCurShowingItemId());
      const iconMiddleX = px2vp(info.screenOffset.x) + px2vp(info.size.width) / 2;
      let popupPanelWidth: number | string = this.getWidth();
      if (typeof popupPanelWidth === 'string') {
        log.showError(`updatePopupPanelRect err. popupPanelWidth type invalid`);
        popupPanelWidth = FixedDockResource.POPUP_MIN_TEXT_WIDTH;
      }
      popupPanelWidth = ( popupPanelWidth + 2 ) * ratio;
      let panelLeftX = iconMiddleX - popupPanelWidth / 2;
      // 避障，由于超屏自动转竖向，所以不存在2边同时需要避障的情况
      panelLeftX = panelLeftX > FixedDockResource.PREVIEW_SCREEN_PADDING ?
        panelLeftX : FixedDockResource.PREVIEW_SCREEN_PADDING;
      const panelRightX = iconMiddleX + popupPanelWidth / 2;
      const beyondRightX = panelRightX - px2vp(this.screenProp.width) + FixedDockResource.PREVIEW_SCREEN_PADDING;
      if (beyondRightX > 0) {
        panelLeftX = panelLeftX - beyondRightX;
      }
      const popupPanelHeight = (this.getHeight() + 2) * ratio;
      // 判断是否是在遮挡磁吸态
      const panelHeight = this.getPanelHeight();
      const vpRect: ViewArea = {
        left: panelLeftX,
        top: panelHeight - config.mDockHeight - FixedDockResource.PANEL_BOTTOM_SPACE - popupPanelHeight,
        width: popupPanelWidth,
        height: popupPanelHeight
      };

      if (popupPanelWidth === 0 || popupPanelHeight === 0) {
        log.showError(`updatePopupPanelRect size err return with hide popup. rect is 0: ${JSON.stringify(vpRect)}`);
        this.popupPanelCtrl.hide();
        return;
      }

      this.popupPanelWidth = popupPanelWidth;
      this.popupPanelCtrl.updateRect(vpRect);
      this.popupPanelCtrl.updateArea(vpRect);
      if (this.isMainScreen) {
        this.updateStatusIconCaches();
      }
      log.showInfo(`updatePopupPanelRect ${JSON.stringify(vpRect)}.`);
    } catch (err) {
      log.showError(`updatePopupPanelRect err. ${err?.code}`);
    }
  }

  private getPanelHeight(): number {
    return this.foldPopupPanelHeight === 0 ?
      this.getUIContext()?.px2vp(this.screenProp.height) : this.foldPopupPanelHeight;
  }

  private getScrollBarConstraintHeight(): number {
    let config: PcDockStyleConfig = PcSmartDockStyleManager.getStyle(this.screenProp);
    const statusBarHeight = viewMgrPolicy.getViewController(ViewType.STATUS_BAR)?.getArea().height ?? 0;
    const panelHeight: number = this.getPanelHeight();
    const sceneHeight = panelHeight - config.mDockHeight - statusBarHeight;
    const safeSpace = statusBarHeight === 0 ?
    FixedDockResource.WINDOW_STYLE_SAFE_SPACE : FixedDockResource.MAC_STYLE_SAFE_SPACE;
    const constraintHeight = (sceneHeight - FixedDockResource.PANEL_BOTTOM_SPACE - safeSpace -
    2 * FixedDockResource.PREVIEW_LIST_MARGIN - 2) / config.mRatio;
    log.showInfo(`getScrollBarConstraintHeight: ${constraintHeight}, dockHeight: ${config.mDockHeight}, statusBarHeight: ${statusBarHeight}`);
    return constraintHeight;
  }

  private getHeight(): number {
    if (!this.isRunning) {
      if (this.isContinueMerged() && PCDockUtils.isContinuableItemExists(this.deviceInfo)) {
        // 计算接续图标容器宽需要算上padding和margin, 不然和实际的popup组件算出来不一致
        const panelHeight = this.getPanelHeight();
        const maxHeight: number = panelHeight * 2 / 3;
        const margin: number = SmartDockConstants.CONTINUABLE_ICON_POPUP_TEXT_MARGIN * StyleConstants.DEFAULT_2;
        const title: string = this.deviceInfo?.appName ? this.deviceInfo?.appName : this.appName;
        const titleHeight: number = this.getTextHeight(title,
          SmartDockConstants.CONTINUABLE_ICON_POPUP_TITLE_SIZE, 0, maxHeight, 0) + margin;
        const desc: string = getContext().resourceManager.getStringSync($r('app.string.continue_hap_come_from').id, this.deviceInfo?.sourceDeviceName ?? '');
        const descHeight: number = this.getTextHeight(desc,
          SmartDockConstants.CONTINUABLE_ICON_POPUP_DESC_SIZE, 0, maxHeight, 0) + margin;
        return titleHeight + descHeight + (SmartDockConstants.CONTINUABLE_ICON_POPUP_PADDING.top as number) +
          (SmartDockConstants.CONTINUABLE_ICON_POPUP_PADDING.bottom as number);
      }
      return FixedDockResource.TIPS_POPUP_HEIGHT;
    }
    if (this.isHorizontal) {
      return FixedDockResource.SNAPSHOT_ITEM_HEIGHT;
    }
    const constraintListHeight = this.getScrollBarConstraintHeight();
    const curListHeight: number = this.currentListHeight > constraintListHeight ?
      constraintListHeight : this.currentListHeight;
    const popupPanelHeight = curListHeight + 2 * FixedDockResource.PREVIEW_LIST_MARGIN;
    return popupPanelHeight;
  }

  private isInnerScreenWidth(list: PreviewImageItem[]): boolean {
    let sumBoxWidth = 0;
    for (let index = 0; index < list.length; index++) {
      const mission = list[index].snapshotInfo;
      if (mission) {
        sumBoxWidth += this.getSnapshotWidth(mission) + FixedDockResource.SNAPSHOT_GAP;
      } else {
        log.showError(`isInnerScreenWidth error, list[${index}] is invalid!`);
      }
    }
    let re = sumBoxWidth < this.getMaxWidth();
    log.showInfo(`isInnerScreenWidth ${re}. list.length: ${this.missionList.length}, ${sumBoxWidth}, ${this.getMaxWidth()}`);
    return re;
  }

  private initMissionList(): void {
    const missionInfoList = AppStorage.get('missionInfoList') as Array<RecentBundleMissionInfo>;
    let list = missionInfoList.filter(it => (this.mSmartDockModel.isSameDockItem(this.mPopItem, it)));
    if (list.length <= 0) {
      log.showInfo(`${this.mPopItem.bundleName}: missionInfoList is null`);
      return;
    }
    this.missionList = [];
    this.listShowTextWidth = FixedDockResource.PREVIEW_TEXT_WIDTH;
    let isMultipleInstanceSplit: boolean = false;
    for (const item of list[0].missionInfoList) {
      let missionId = 0;
      if (PCDockUtils.isSameBundle(item.secondarySession?.sceneInfo?.bundleName, list[0].bundleName)) {
        if (PCDockUtils.isSameBundle(item.primarySession?.sceneInfo?.bundleName, list[0].bundleName)) {
          if (isMultipleInstanceSplit === false) {
            isMultipleInstanceSplit = true;
            missionId = item.primarySession?.session?.persistentId ?? 0;
          } else {
            isMultipleInstanceSplit = false;
            missionId = item.secondarySession?.session?.persistentId ?? 0;
          }
        } else {
          missionId = item.secondarySession?.session?.persistentId ?? 0;
        }
      } else {
        missionId = item.primarySession?.session?.persistentId ?? 0;
      }
      if (missionId <= 0) {
        continue;
      }
      let snapshot: SnapshotInfo = new SnapshotInfo();
      snapshot.missionId = missionId;
      snapshot.bundleName = item.secondarySession?.sceneInfo?.bundleName === list[0].bundleName ?
        item.secondarySession?.sceneInfo?.bundleName ?? '' :
        item.primarySession?.sceneInfo?.bundleName ?? '';
      snapshot.sceneSession = item;
      let labelName = this.initLabelName(snapshot);
      this.missionList.push(new PreviewImageItem(snapshot, labelName));
      this.listShowTextWidth = this.getTextWidth(labelName, $r('sys.float.Subtitle_M'),
        this.listShowTextWidth, FixedDockResource.PREVIEW_LIST_ITEM_MAX_WIDTH);
      log.showDebug(`initMissionList missionId:${missionId},listShowTextWidth:${this.listShowTextWidth},labelName:${labelName}`);
    }
    this.checkIsAddContinuableItem();
    this.updateListHeight();
  }

  private initLabelName(snapshot: SnapshotInfo): string {
    if (snapshot.bundleName === CONTINUE_ABILITY) {
      return getContext().resourceManager.getStringSync($r('app.string.continue_hap_come_from').id, this.deviceInfo.sourceDeviceName ?? '');
    }
    const containerSession = snapshot.sceneSession as SCBSceneContainerSession;
    const primarySession = containerSession?.primarySession;
    const secondarySession = containerSession?.secondarySession;
    let session = primarySession;
    if (snapshot.missionId === secondarySession?.session.persistentId) {
      session = secondarySession;
    }
    const sessionLabel: string | undefined = session?.sceneInfo?.label;
    let labelName: string = '';
    if (!CheckEmptyUtils.isEmpty(sessionLabel)) {
      log.showDebug(`labelName from sessionLabel:${sessionLabel}`);
      labelName = sessionLabel as string;
      return labelName;
    }
    ResourceManager.getInstance().getAppNameWithCache(snapshot?.appLabelId, this.mPopItem?.bundleName,
      this.mPopItem?.moduleName, snapshot.name, (name: string): void => { labelName = name; });
    if (!CheckEmptyUtils.isEmpty(labelName)) {
      log.showDebug(`labelName from AppNamecache ${labelName}`)
      return labelName;
    } else {
      labelName = this.mPopItem.appName;
      log.showInfo(`labelName from appName: ${labelName}`);
      return labelName;
    }
  }

  private getBrightnessOptions(): BrightnessOptions {
    return this.currColorMode === 0 ? FixedDockResource.fixedScrollerComponentDarkParam :
    FixedDockResource.fixedScrollerComponentLightParam;
  }

  @Builder
  previewBuilder() {
    List({ space: FixedDockResource.PREVIEW_LIST_SPACE, scroller: this.mScroller }) {
      ForEach(this.missionList, (item: PreviewImageItem) => {
        ListItem() {
          PreviewImageComponent({
            item: item,
            mPopItem: this.mPopItem,
            updatePopupPanelRect: () => { this.updatePopupPanelRect(); },
            updateData: this.updateData,
            appName: this.appName,
            styleChange: this.styleChange,
            isDragging: this.isDragging,
            hoverFlag: this.hoverFlag,
            isHover: this.isHover,
            dataList: this.missionList,
            ratio: PcSmartDockStyleManager.getStyle(this.screenProp).mRatio,
            currentWidth: this.currentWidth,
            currentListHeight: this.currentListHeight,
            mMaxBoxWidth: this.mMaxBoxWidth,
            mMaxWidth: this.getMaxWidth(),
            mCurrentBoxWidth: this.mCurrentBoxWidth,
            baseNum: this.baseNum,
            endOffset: this.endOffset,
            isShowCloseButton: this.isShowCloseButton,
            isHorizontal: false,
            screenProp: this.screenProp,
            continuableItemBgColor: this.continuableItemBgColor,
            listShowTextWidth: this.listShowTextWidth,
            isUgCN: this.isUgCN
          })
        }
      }, (item: PreviewImageItem, index: number) =>
           `${item.snapshotInfo.missionId}_${item.labelName}_${this.listShowTextWidth}_${index})`)
    }
    .scale({
      x: PcSmartDockStyleManager.getStyle(this.screenProp).mRatio,
      y: PcSmartDockStyleManager.getStyle(this.screenProp).mRatio
    })
    .offset({
      x: PcSmartDockStyleManager
            .getStyle(this.screenProp).mRatio === 1 ?
            0 : -((this.getWidth() as number) * (1 - PcSmartDockStyleManager
           .getStyle(this.screenProp).mRatio) / 2) * this.isUgCN,
      y: 0,
    })
    .alignListItem(ListItemAlign.Center)
    .scrollBar(BarState.On)
    .constraintSize({
      maxHeight: this.getScrollBarConstraintHeight()
    })
    .margin({
      top: FixedDockResource.PREVIEW_LIST_MARGIN,
      bottom: FixedDockResource.PREVIEW_LIST_MARGIN
    })
  }

  @Builder
  contentBuilder() {
    if (!this.isRunning) {
      this.tipsBuilder();
    } else if (this.missionList.length > 0) {
      Stack({
        alignContent: this.isHorizontal ? Alignment.Center : Alignment.TopEnd
      }) {
        if (this.isHorizontal) {
          this.previewImageBuilder();
        } else {
          this.previewBuilder()
        }
      }
      .width(this.getWidth())
      .height(this.getHeight())
      .onHover((isHover: boolean, event: HoverEvent) => {
        if (event.sourceTool === SourceTool.Pen) {
          return;
        }
        if (isHover) {
          this.hoverFlag = true;
          this.popupMgr.setIsHoverSnapshot(this.screenProp.screenId, true);
          log.showDebug(`onhover true isHoverSnapshot true, ${isHover}`);
        } else {
          if (this.isLabelNameShow) {
            return;
          }
          this.hoverFlag = false;
          this.popupMgr.setIsHoverSnapshot(this.screenProp.screenId, false);
          log.showDebug(`onhover false isHoverSnapshot false, ${isHover}`);
          this.isLabelNameShow = false;
          this.popupMgr.hide(this.screenProp.screenId, HOVER_OUT_POPUP_DELAY, true);
        }
      })
      .onMouse((event?: MouseEvent) => {
        if (event && this.isDragging && event.action === MouseAction.Release) {
          log.showInfo('onMouse isDragging and release');
          this.isDragging = false;
          clearMoveToFrontDelayTimer();
        }
      })
    }
  }

  build() {
    if (this.popupPanelCtrl.isShowing()) {
      Row() {
        this.contentBuilder()
      }
      .margin(FixedDockResource.BORDER_WIDTH)
      .borderWidth(FixedDockResource.BORDER_WIDTH)
      .borderColor(FixedDockResource.BORDER_COLOR)
      .borderRadius(this.panelRadio)
      .outlineWidth(FixedDockResource.BORDER_WIDTH)
      .outlineColor(this.mBorderColor)
      .outlineRadius(this.panelRadio)
      .backgroundColor('#FFFFFFFF')
      .shadow({
        radius: 16,
        color: FixedDockResource.POPUP_COLOR,
        offsetX: 0,
        offsetY: 10
      })
      .backgroundBrightnessInternal(this.getBrightnessOptions())
      .backgroundEffect({
        radius: this.currColorMode === 0 ? 120 : 100
      })
    }
  }
}

@Observed
export class PreviewImageItem {
  public offsetX: number = 0;
  public snapshotInfo: SnapshotInfo;
  public labelName: string;
  constructor(snapshotInfo: SnapshotInfo, labelName: string) {
    this.snapshotInfo = snapshotInfo;
    this.labelName = labelName;
  }
}

@Component
export struct PreviewImageComponent {
  private popupMgr: PcDockPopupMgr = PcDockPopupMgr.getInstance();
  private player = animator.create({
    duration: 350,
    easing: 'friction',
    begin: 0,
    end: 1,
    delay: 0,
    iterations: 1,
    fill: 'forwards',
    direction: 'normal'
  })
  private mPopItem: DockItemInfo = new DockItemInfo();
  private updatePopupPanelRect: Function = (): void => { };
  private updateData: Function = (): void => { };
  private mMaxBoxWidth: number = 0;
  private isUgCN: number = 1; // 1：非维语、 -1：维语
  private mMaxWidth = 0;
  private thisScrollerStyle = false;
  private isHorizontal: boolean = true;
  private scbSceneSessionManager = SCBSceneSessionManager.getInstance();
  @State labelName: string = '';
  @State listShowTextWidth: number = FixedDockResource.PREVIEW_TEXT_WIDTH;
  private ratio: number = 1;
  private bodyM: number = this.getNumberByResource($r('sys.float.Body_M'), 14);
  private paddingLevel4: number = this.getNumberByResource($r('sys.float.padding_level4'), 8);
  private radiusLevel4: number = this.getNumberByResource($r('sys.float.corner_radius_level4'), 8);
  private uiContextMeasure: MeasureUtils = this.getUIContext().getMeasureUtils();
  @StorageLink('continueDeviceInfo') deviceInfo: DockContinuableInfo = new DockContinuableInfo();
  @ObjectLink item: PreviewImageItem;
  @Link appName: string;
  @State missionId: number = -1;
  @Link isDragging: boolean;
  @Link hoverFlag: boolean;
  @Link isHover: boolean;
  @Link dataList: PreviewImageItem[];
  @Link currentWidth: number;
  @Link currentListHeight: number;
  @Link styleChange: boolean;
  @Link mCurrentBoxWidth: number;
  @Link baseNum: number;
  @Link endOffset: number;
  @Link screenProp: SCBScreenProperty;
  @Link isShowCloseButton: boolean;
  @Link continuableItemBgColor: string;
  @State closePicBackgroundColor: Resource | null = null;
  @State hoverScale: number = 1;
  @State isLabelNameShow: boolean = false;
  @State horizontalTextWidth: number = 0;
  @State hoverTipWindowWidth: number = 0;
  @State hoverTipWindowHeight: number = 0;
  @State pressState: boolean = false;
  @State snapshotImg: image.PixelMap | undefined = undefined;
  private snapshotTimer: number = 0;

  aboutToAppear(): void {
    this.labelName = this.item.labelName;
    this.scbSceneSessionManager.registerSessionLabelListener(this.item?.snapshotInfo.missionId,
      this.sessionLabelListener);
    log.showInfo(`PreviewImageComponent aboutToAppear. missionId: ${this.item.snapshotInfo.missionId},labelName:${this.labelName} `);
    this.updateSnapShot();
  }

  aboutToDisappear(): void {
    this.scbSceneSessionManager.unRegisterSessionLabelListener(this.item?.snapshotInfo.missionId,
      this.sessionLabelListener);
    this.stopSnapshot();
    log.showInfo(`PreviewImageComponent aboutToDisappear. missionId: ${this.item.snapshotInfo.missionId} `);
  }

  private getNumberByResource(resource: Resource, defaultValue: number): number {
    try {
      let sourceValue: number = resourceManager.getSystemResourceManager().getNumber(resource);
      if (sourceValue > 0) {
        return sourceValue;
      } else {
        return defaultValue;
      }
    } catch (error) {
      let code: number = (error as BusinessError).code;
      let message: string = (error as BusinessError).message;
      log.showError(`getNumberByResource error, code: ${code}, message: ${message}`);
      return defaultValue;
    }
  }

  private sessionLabelListener: SessionLabelListener = {
    onUpdate: (label: string) => {
      this.labelName = label;
    }
  }

  private updateSnapShot(): void {
    if (!this.isHorizontal || !CheckEmptyUtils.isEmptyPixelMap(this.item.snapshotInfo.image)) {
      return;
    }
    this.getSnapshot(this.item.snapshotInfo.missionId, this.item.snapshotInfo?.nodeType ?? 0);
  }

  private async getSnapshot(missionId: number, nodeType: number, retryTime: number = 4): Promise<void> {
    if (missionId !== this.item.snapshotInfo?.missionId || this.snapshotTimer < 0) {
      return;
    }
    const isEmpty: boolean = CheckEmptyUtils.isEmptyPixelMap(this.snapshotImg);
    log.showInfo(`getSnapshot missionId:${missionId} retryTime:${retryTime} isEmpty:${isEmpty}`);
    if (retryTime > 0 && isEmpty) {
      this.snapshotTimer = setTimeout(async () => {
        this.snapshotImg = await SmartDockModel.getInstance().getSnapShotImagePixelMap(missionId, nodeType);
        this.getSnapshot(missionId, nodeType, --retryTime);
      }, 500);
    } else if (!isEmpty) {
      this.item.snapshotInfo.image = this.snapshotImg!;
    }
  }

  private stopSnapshot(): void {
    if (this.snapshotTimer > 0) {
      clearTimeout(this.snapshotTimer);
      this.snapshotTimer = -1;
    }
  }

  private clearShowTipsDelayTimer(): void {
    if (showTipsDelayTimer) {
      clearTimeout(showTipsDelayTimer);
      showTipsDelayTimer = null;
    }
  }

  private showTipsWithDelay(isHover: boolean): void {
    this.clearShowTipsDelayTimer();
    const snapshotTextWith = this.isHorizontal
      ? this.horizontalTextWidth : this.listShowTextWidth;
    if (isHover && this.getTextWidth(this.labelName, $r('sys.float.Subtitle_M'), StyleConstants.DEFAULT_0) >
      snapshotTextWith) {
      showTipsDelayTimer = setTimeout(() => {
        this.isLabelNameShow = true;
      }, POPUP_TIP_SHOW_DELAY);
    } else {
      showTipsDelayTimer = setTimeout(() => {
        this.isLabelNameShow = false;
      }, HOVER_OUT_POPUP_DELAY);
    }
  }

  private getTextWidth(labelName: string, size: Resource, defaultRadius: number = StyleConstants.DEFAULT_16): number {
    let needTextWidth: number = Math.round(px2vp(this.uiContextMeasure.measureTextSize({
      textContent: labelName,
      fontSize: size,
      fontWeight: FontWeight.Regular,
      overflow: TextOverflow.Ellipsis
    }).width as number)) + defaultRadius;
    return needTextWidth;
  }

  private calcShowTipsWidth(): number {
    const textWidth = this.getTextWidth(this.labelName, $r('sys.float.Body_M'));
    const maxTextWidth = px2vp(this.screenProp.width) * 2 / 3;
    return textWidth > maxTextWidth ? maxTextWidth : textWidth;
  }

  private checkIsShowCloseButton(): boolean {
    if (this.item?.snapshotInfo.bundleName == CONTINUE_ABILITY) {
      return false;
    }
    if (this.isShowCloseButton) {
      return true;
    }
    return this.missionId === this.item?.snapshotInfo.missionId;
  }

  @Builder
  showTipsBuilder() {
    Row() {
      Text(this.labelName)
        .id(`PreviewImageLabelName_Text_${this.labelName}`)
        .wordBreak(WordBreak.BREAK_ALL)
        .fontSize(this.bodyM * PcSmartDockStyleManager.getStyle(this.screenProp).mRatio)
        .fontColor($r('sys.color.font_primary'))
        .textOverflow({overflow: TextOverflow.Ellipsis})
    }
    .width(this.calcShowTipsWidth() * PcSmartDockStyleManager.getStyle(this.screenProp).mRatio)
    .padding({
      left: this.paddingLevel4 * PcSmartDockStyleManager.getStyle(this.screenProp).mRatio,
      right: this.paddingLevel4 * PcSmartDockStyleManager.getStyle(this.screenProp).mRatio,
      bottom: this.paddingLevel4 * PcSmartDockStyleManager.getStyle(this.screenProp).mRatio,
      top: this.paddingLevel4 * PcSmartDockStyleManager.getStyle(this.screenProp).mRatio,
    })
  }

  @Builder
  closeButtonBuilder() {
    Stack() {
      SymbolGlyph($r('sys.symbol.xmark'))
        .draggable(false)
        .id(`${TAG}_Image_closePic`)
        .fontColor([$r('sys.color.ohos_id_color_primary')])
        .fontSize('16vp')
        .width(FixedDockResource.SNAPSHOT_CLOSE_BUTTON_SIZE)
        .height(FixedDockResource.SNAPSHOT_CLOSE_BUTTON_SIZE)
        .backgroundColor($r('sys.color.ohos_id_color_button_normal'))
        .padding({
          left: this.isUgCN === -1 ? 0 : 4,
          right: this.isUgCN === -1 ? 4 : 0
        })
    }
    .backgroundColor(this.closePicBackgroundColor)
    .width(FixedDockResource.SNAPSHOT_CLOSE_BUTTON_SIZE)
    .height(FixedDockResource.SNAPSHOT_CLOSE_BUTTON_SIZE)
    .clip(
      new Circle({
        width: FixedDockResource.SNAPSHOT_CLOSE_BUTTON_SIZE,
        height: FixedDockResource.SNAPSHOT_CLOSE_BUTTON_SIZE
      }))
    .responseRegion({
      x: '-33%',
      y: '-33%',
      width: '167%',
      height: '167%'
    })
    .onClick((event?: ClickEvent) => {
      this.closeClickAction(this.item);
    })
    .onTouch((event?: TouchEvent) => {
      if (event?.type === TouchType.Down) {
        this.closePicBackgroundColor = $r('sys.color.ohos_id_color_click_effect');
      } else if (event?.type === TouchType.Up) {
        this.closePicBackgroundColor = $r('sys.color.ohos_id_color_hover');
      }
    })
    .onHover((isHover) => {
      if (isHover) {
        this.closePicBackgroundColor = $r('sys.color.ohos_id_color_hover');
      } else {
        this.closePicBackgroundColor = null;
      }
    })
    .visibility(this.checkIsShowCloseButton() ? Visibility.Visible : Visibility.None)
  }

  @Builder
  horizontalItemBuilder() {
    Column() {
      Flex({
        direction: FlexDirection.Row,
        alignItems: ItemAlign.Center,
        justifyContent: FlexAlign.SpaceBetween
      }) {
        PreviewImageLabelName({
          snapShotItem: this.item?.snapshotInfo,
          labelName: this.labelName,
          customWidth: this.horizontalTextWidth,
          customHeight: FixedDockResource.SNAPSHOT_TITLE_HEIGHT
        })
          .id(`${TAG}_Text_${this.item?.snapshotInfo.bundleName}`)
          .bindPopup(this.isLabelNameShow, {
            builder: this.showTipsBuilder(),
            popupColor: FixedDockResource.POPUP_COLOR,
            mask: false,
            placement: Placement.Top,
            offset: { y: - StyleConstants.DEFAULT_4 * PcSmartDockStyleManager.getStyle(this.screenProp).mRatio },
            enableArrow: false,
            autoCancel: true,
            onStateChange: (e) => {
              log.showError(`onItemPopupStateChange isVisible:${e.isVisible},bundleName: ${this.mPopItem.moduleName}`);
              if (!e.isVisible) {
                this.isLabelNameShow = false;
              }
            },
            showInSubWindow: true,
            followTransformOfTarget: true,
            radius: this.radiusLevel4 * PcSmartDockStyleManager.getStyle(this.screenProp).mRatio,
            shadow: ShadowStyle.OUTER_DEFAULT_SM,
            backgroundBlurStyle: BlurStyle.COMPONENT_REGULAR
          })
          .onHover((isHover) => {
            this.showTipsWithDelay(isHover);
          })

        this.closeButtonBuilder()
      }
      .width('100%')
      .height(FixedDockResource.SNAPSHOT_TITLE_HEIGHT)
      .margin({
        bottom: FixedDockResource.SNAPSHOT_TITLE_MARGIN_BOTTOM
      })

      if (this.item.snapshotInfo.bundleName === CONTINUE_ABILITY) {
        Row() {
          Image(this.getImage(this.item))
            .draggable(false)
            .id(`${TAG}_Image_${this.item?.snapshotInfo.missionId}`)
            .width(FixedDockResource.CONTINUABLE_ITEM_PREVIEW_IMAGE_SIZE)
            .height(FixedDockResource.CONTINUABLE_ITEM_PREVIEW_IMAGE_SIZE)
            .objectFit(ImageFit.Contain)
            .interpolation(ImageInterpolation.Medium)
            .autoResize(false)
            .borderRadius(FixedDockResource.SNAPSHOT_IMAGE_OUTER_BORDER_RADIUS)
            .scale({ x: this.hoverScale, y: this.hoverScale })
            .syncLoad(true)
            .shadow({
              radius: FixedDockResource.SNAPSHOT_IMAGE_SHADOW_RADIUS,
              color: FixedDockResource.SNAPSHOT_IMAGE_SHADOW_COLOR
            })
        }
        .width(FixedDockResource.SNAPSHOT_ITEM_DEFAULT_WIDTH)
        .height(FixedDockResource.SNAPSHOT_IMAGE_HEIGHT)
        .justifyContent(FlexAlign.Center)
        .scale({ x: this.hoverScale, y: this.hoverScale })
        .backgroundColor(this.continuableItemBgColor)
        .shadow({
          radius: FixedDockResource.SNAPSHOT_IMAGE_SHADOW_RADIUS,
          color: FixedDockResource.SNAPSHOT_IMAGE_SHADOW_COLOR
        })
        .borderRadius(FixedDockResource.SNAPSHOT_IMAGE_OUTER_BORDER_RADIUS)
        .clip(true)
      } else {
        Image(this.getImage(this.item))
          .draggable(false)
          .id(`${TAG}_Image_${this.item?.snapshotInfo.missionId}`)
          .width('100%')
          .height(FixedDockResource.SNAPSHOT_IMAGE_HEIGHT)
          .objectFit(ImageFit.Contain)
          .interpolation(ImageInterpolation.Medium)
          .autoResize(false)
          .borderRadius(FixedDockResource.SNAPSHOT_IMAGE_OUTER_BORDER_RADIUS)
          .scale({ x: this.hoverScale, y: this.hoverScale })
          .syncLoad(true)
          .shadow({
            radius: FixedDockResource.SNAPSHOT_IMAGE_SHADOW_RADIUS,
            color: FixedDockResource.SNAPSHOT_IMAGE_SHADOW_COLOR
          })
      }
    }
    .width(this.getSnapshotWidth(this.item.snapshotInfo))
    .height(FixedDockResource.SNAPSHOT_ITEM_HEIGHT)
    .padding({
      top: FixedDockResource.SNAPSHOT_ITEM_PADDING_TOP,
      bottom: FixedDockResource.SNAPSHOT_ITEM_PADDING_BOTTOM,
      left: FixedDockResource.SNAPSHOT_ITEM_PADDING_LEFT,
      right: FixedDockResource.SNAPSHOT_ITEM_PADDING_RIGHT
    })
  }

  @Builder
  verticalItemBuilder() {
    Row() {
      Image(this.popupMgr.getCurItemIcon() ? this.popupMgr.getCurItemIcon() : this.getAppIcon())
        .draggable(false)
        .width(FixedDockResource.PREVIEW_TITLE_IAMGE_SIZE)
        .height(FixedDockResource.PREVIEW_TITLE_IAMGE_SIZE)
        .borderRadius(FixedDockResource.PREVIEW_TITLE_IAMGE_RADIUS)

      PreviewImageLabelName({
        snapShotItem: this.item.snapshotInfo,
        labelName: this.labelName,
        customWidth: this.listShowTextWidth,
        customHeight: FixedDockResource.PREVIEW_TEXT_HEIGHT
      })
        .bindPopup(this.isLabelNameShow, {
          builder: this.showTipsBuilder(),
          popupColor: FixedDockResource.POPUP_COLOR,
          mask: false,
          placement: Placement.Top,
          offset: { y: - StyleConstants.DEFAULT_6 * PcSmartDockStyleManager.getStyle(this.screenProp).mRatio},
          enableArrow: false,
          autoCancel: true,
          onStateChange: (e) => {
            log.showError(`onItemPopupStateChange isVisible:${e.isVisible},bundleName: ${this.mPopItem.moduleName}`);
            if (!e.isVisible) {
              this.isLabelNameShow = false;
            }
          },
          followTransformOfTarget: true,
          showInSubWindow: true,
          radius: this.radiusLevel4 * PcSmartDockStyleManager.getStyle(this.screenProp).mRatio,
          shadow: ShadowStyle.OUTER_DEFAULT_SM,
          backgroundBlurStyle: BlurStyle.COMPONENT_REGULAR
        })
        .onHover((isHover) => {
          this.showTipsWithDelay(isHover);
        })
        .margin({
          left: FixedDockResource.PREVIEW_TEXT_MARGIN,
          right: FixedDockResource.PREVIEW_TEXT_MARGIN
        })

      this.closeButtonBuilder()
    }
    .width(this.listShowTextWidth + FixedDockResource.PREVIEW_LIST_TEXT_MARGIN)
    .height(FixedDockResource.PREVIEW_LIST_ITEM_HEIGHT)
    .backgroundColor(this.getItemBackgroundColor())
    .borderRadius(FixedDockResource.PREVIEW_LIST_ITEM_RADIUS)
    .padding({
      left: FixedDockResource.PREVIEW_LIST_ITEM_PADDING,
      right: FixedDockResource.PREVIEW_LIST_ITEM_PADDING
    })
  }

  private getItemBackgroundColor(): Resource | string {
    log.showInfo(`tugaobo this.missionId:${this.missionId},this.item?.snapshotInfo.missionId:${this.item?.snapshotInfo.missionId},this.pressState:${this.pressState}` );
    if (this.pressState) {
      return $r('sys.color.ohos_id_color_click_effect');
    }
    if (this.missionId === this.item?.snapshotInfo.missionId) {
      return $r('sys.color.ohos_id_color_hover');
    }
    return StyleConstants.DEFAULT_TRANSPARENT_COLOR;
  }

  build() {
    Column() {
      if (this.isHorizontal) {
        this.horizontalItemBuilder()
      } else {
        this.verticalItemBuilder();
      }
    }
    .onTouch((event?: TouchEvent) => {
      if (event?.type === TouchType.Down) {
        this.pressState = true;
      }
      if (event?.type === TouchType.Up) {
        this.pressState = false;
      }
    })
    .onMouse((event?: MouseEvent) => {
      if (event?.button === MouseButton.Left && event?.action === MouseAction.Press) {
        this.pressState = true;
      } else if (event?.button === MouseButton.Left && event?.action === MouseAction.Release) {
        this.pressState = false;
      }
    })
    .translate({ x: this.isHorizontal ? this.item?.offsetX : 0})
    .alignItems(HorizontalAlign.Center)
    .onClick((event?: ClickEvent) => {
      this.itemClickAction(this.item?.snapshotInfo, event);
      this.pressState = false;
    })
    .onHover((isHover?: boolean) => {
      this.itemHoverAction(this.item?.snapshotInfo, isHover);
    })
    .onDrop((event?: DragEvent, extraParams?: string) => {
    })
    .onDragEnter((event: DragEvent, extraParams?: string) => {
      this.isDragging = true;
      this.hoverFlag = true;
      this.popupMgr.setIsHoverSnapshot(this.screenProp.screenId, this.hoverFlag);
      this.itemHoverAction(this.item?.snapshotInfo, this.hoverFlag);
    })
    .onDragLeave((event: DragEvent, extraParams?: string) => {
      this.hoverFlag = false;
      this.popupMgr.setIsHoverSnapshot(this.screenProp.screenId, this.hoverFlag);
      this.itemHoverAction(this.item?.snapshotInfo, this.hoverFlag);
      this.popupMgr.hide(this.screenProp.screenId, HOVER_OUT_POPUP_DELAY, true);
    })
  }
  
  private updateWidthAndArrow(): void {
    log.showInfo(
      `updateWidthAndArrow start: ${this.mPopItem?.bundleName} ${this.currentWidth} ${this.mCurrentBoxWidth}`);
    if (CheckEmptyUtils.isEmptyArr(this.dataList)) {
      this.currentWidth = 0;
      return;
    }

    let sumBoxWidth = 0;
    for (let index = 0; index < this.dataList.length; index++) {
      const mission = this.dataList[index];
      if (mission) {
        sumBoxWidth += this.getSnapshotWidth(mission.snapshotInfo) + FixedDockResource.SNAPSHOT_GAP;
      } else {
        log.showError(`updateCurrentWidth error, dataList[${index}] is invalid!`);
      }
    }
    this.mCurrentBoxWidth = sumBoxWidth;
    this.currentWidth = this.mCurrentBoxWidth + FixedDockResource.PREVIEW_MARGIN_WHEN_NO_ARROW;
    log.showInfo(`updateWidthAndArrow end: ${this.mPopItem?.bundleName} ${this.currentWidth} ${this.mCurrentBoxWidth}`);
  }

  private getScreenId(sceneSession: SCBSceneContainerSession, missionId: number): number {
    let screenId: number;
    if (missionId === sceneSession.primarySession?.session?.persistentId) {
      screenId = sceneSession.primarySession?.sceneInfo?.screenId as number;
    } else {
      screenId = sceneSession.secondarySession?.sceneInfo?.screenId as number;
    }
    return screenId;
  }

  private getPersistentId(sceneSession: SCBSceneContainerSession, missionId: number): number {
    let persistentId: number;
    if (missionId === sceneSession.primarySession?.session?.persistentId) {
      persistentId = sceneSession.primarySession?.sceneInfo?.persistentId as number;
    } else {
      persistentId = sceneSession.secondarySession?.sceneInfo?.persistentId as number;
    }
    return persistentId;
  }

  private close(missionId: number, sceneSession?: SCBSceneContainerSession): void {
    if (!sceneSession) {
      return;
    }
    let screenId: number = this.getScreenId(sceneSession, missionId);
    SCBSceneSessionManager.getInstance().asyncPrepareTerminate(missionId, (err, isPrepareTerminate) => {
      if (isPrepareTerminate) {
        this.hideDockPanel();
        log.showInfo('deleteRecentSession isPrepareTerminate');
        return;
      }
      try {
        SCBSceneSessionManager.getInstance().close(screenId, missionId);
      } catch (error) {
        log.showError(`close error= ${error}`);
        return;
      }
    });
  }

  private moveToFront(sceneSession: SCBSceneContainerSession, missionId: number): void {
    if (!sceneSession) {
      return;
    }
    log.showInfo(`moveToFront ${sceneSession.primarySession?.sceneInfo.bundleName}`);
    let screenId: number = this.getScreenId(sceneSession, missionId);
    let persistentId: number = this.getPersistentId(sceneSession, missionId);
    SCBSceneSessionManager.getInstance().exitActiveSplit(INVALID_SCREEN_ID);
    SCBSceneSessionManager.getInstance().startSceneFromRecent(screenId, persistentId, sceneSession.containerId);
    SCBSceneSessionManager.getInstance().requestFocus(persistentId, false);
  }

  private clearMoveToFrontDelayTimer(): void {
    if (moveToFrontDelayTimer) {
      clearTimeout(moveToFrontDelayTimer);
      moveToFrontDelayTimer = null;
    }
  }

  private moveToFrontWithDelay(sceneSession: SCBSceneContainerSession, missionId: number, delay: number): void {
    this.clearMoveToFrontDelayTimer();
    moveToFrontDelayTimer = setTimeout(() => {
      if (missionId === this.missionId && this.popupMgr.isHoverSnapshot(this.screenProp.screenId) as boolean &&
      this.isDragging) {
        this.popupMgr.hide(this.screenProp.screenId, 0, true);
        this.hoverFlag = false;
        this.popupMgr.setIsHoverSnapshot(this.screenProp.screenId, false);
        this.isDragging = false;
        ContextMenu.close();
        this.moveToFront(sceneSession, missionId);
        this.clearMoveToFrontDelayTimer();
      }
      log.showInfo(`${this.mPopItem?.bundleName} moveToFront missionId: ${missionId} ${this.missionId}`);
    }, delay);
  }

  private getSnapshotWidth(item: SnapshotInfo): number {
    let snapshotWidth = 0;
    if (CheckEmptyUtils.isEmpty(item) || !item.boxSize) {
      snapshotWidth = FixedDockResource.SNAPSHOT_ITEM_DEFAULT_WIDTH;
    } else if (item.boxSize < FixedDockResource.SNAPSHOT_ITEM_MIN_WIDTH) {
      snapshotWidth = FixedDockResource.SNAPSHOT_ITEM_MIN_WIDTH;
    } else {
      snapshotWidth = item.boxSize;
    }
    this.horizontalTextWidth = snapshotWidth - FixedDockResource.SNAPSHOT_CLOSE_BUTTON_SIZE;
    return snapshotWidth;
  }

  private scrollerStyle(): boolean {
    let sumBoxWidth = 0;
    for (let index = 0; index < this.dataList.length; index++) {
      const item = this.dataList[index];
      if (item) {
        sumBoxWidth += this.getSnapshotWidth(item.snapshotInfo) + FixedDockResource.SNAPSHOT_GAP;
      } else {
        log.showError(`closeClickAction error, dataList[${index}] is invalid!`);
      }
   }
    return sumBoxWidth < this.mMaxWidth;
  }

  private closeClickAction(item?: PreviewImageItem): void {
    if (item === undefined) {
      log.showError('onClick close, item is empty!');
      return;
    }
    const missionId: number = item.snapshotInfo.missionId;
    const index = this.dataList.findIndex((item: PreviewImageItem, index: number) => {
      return item.snapshotInfo.missionId === missionId;
    });
    log.showInfo(`item index: ${index}, missionId: ${missionId}, length: ${this.dataList.length}`);
    if (this.dataList.length <= 1) {
      this.updateData?.(false, '',
        () => this.close(missionId, item?.snapshotInfo.sceneSession as SCBSceneContainerSession));
      this.hideDockPanel();
    } else {
      // 删除列表数据
      this.endOffset = 0;
      animateTo({ duration: 0 }, () => {
        if (index === (this.dataList.length - 1)) {
          this.dataList.pop();
        } else {
          this.dataList.splice(index + this.baseNum, 1);
        }
        this.updateData(true, item.snapshotInfo.bundleName,
          () => this.close(missionId, item.snapshotInfo.sceneSession));
      });
      let lastScrollerStyle = this.thisScrollerStyle;
      this.thisScrollerStyle = this.scrollerStyle();
      if (this.thisScrollerStyle && !lastScrollerStyle) {
        this.styleChange = true;
      }
      if (!this.isHorizontal) {
        this.currentListHeight = this.dataList.length *
          (FixedDockResource.PREVIEW_LIST_ITEM_HEIGHT + FixedDockResource.PREVIEW_LIST_SPACE) -
           FixedDockResource.PREVIEW_LIST_SPACE;
        this.updatePopupPanelRect();
        return;
      }
      const snapshotWidth = this.getSnapshotWidth(item.snapshotInfo);
      log.showInfo(`after delete length: ${this.dataList.length}, endOffset: ${this.endOffset}, snapshotWidth: ${snapshotWidth}`);
      for (let i = 0; i < this.dataList.length; ++i) {
        const element = this.dataList[i];
        if (i < index) {
          element.offsetX = this.endOffset
        } else {
          element.offsetX = snapshotWidth + this.endOffset;
        }
      }
      for (let i = 0; i < this.dataList.length; ++i) {
        const element = this.dataList[i];
        animateTo({
          curve: Curve.Friction,
          duration: 350,
        }, () => {
          element.offsetX = 0
        })
      }

      // 计算所有的卡片总宽度
      let sumBoxWidth = 0;
      for (let index = 0; index < this.dataList.length; index++) {
        const item = this.dataList[index];
        if (item) {
          sumBoxWidth += this.getSnapshotWidth(item.snapshotInfo) + FixedDockResource.SNAPSHOT_GAP;
        } else {
          log.showError(`closeClickAction error, dataList[${index}] is invalid!`);
        }
      }
      const prevListWidth = this.currentWidth;
      log.showInfo(`sumBoxWidth: ${sumBoxWidth}, mMaxBoxWidth: ${this.mMaxBoxWidth}, mMaxWidth: ${this.mMaxWidth}`);
      if (sumBoxWidth > this.mMaxBoxWidth) {
        // 存在不可见的卡片
        this.updateWidthAndArrow();
        this.updatePopupPanelRect();
      } else {
        // 所有卡片均可见
        const prevBoxWidth = this.mCurrentBoxWidth;
        const changeWidth = this.currentWidth - (sumBoxWidth + FixedDockResource.PREVIEW_MARGIN_WHEN_NO_ARROW);
        const changeBoxWidth = this.mCurrentBoxWidth - sumBoxWidth;
        log.showInfo(`prevListWidth: ${prevListWidth}, changeWidth: ${changeWidth}`);
        this.player.play();
        this.player.onFrame = (num: number) => {
          this.currentWidth = prevListWidth - (changeWidth * num);
          this.mCurrentBoxWidth = prevBoxWidth - (changeBoxWidth * num);
          this.updatePopupPanelRect();
        }
        this.player.onFinish = () => {
          this.updateWidthAndArrow();
        }
      }
    }
  }

  private hideDockPanel(): void {
    this.hoverFlag = false;
    this.popupMgr.setIsHoverSnapshot(this.screenProp.screenId, false);
    this.popupMgr.hide(this.screenProp.screenId, 0, true);
    ContextMenu.close();
    localEventManager.sendLocalEvent(EventConstants.EVENT_RESET_HIDE_DOCK_AFTER_POPUP_STATE_CALLBACK,
      this.screenProp.screenId);
  }

  private itemClickAction(item?: SnapshotInfo, event?: ClickEvent): void {
    if (item === undefined) {
      return;
    }
    log.showInfo(`onClick:${item?.bundleName}, containerId: ${item?.sceneSession?.containerId}`);
    this.hoverFlag = false;
    this.popupMgr.setIsHoverSnapshot(this.screenProp.screenId, false);
    this.popupMgr.hide(this.screenProp.screenId, 0, true);
    ContextMenu.close();
    if (viewMgrPolicy.isViewShowing(ViewType.APP_CENTER) &&
    GlobalContext.getInstance().hasObject('hideAppCenterWithAnimation')) {
      let hideAppCenterWithAnimation = (
      GlobalContext.getInstance().getObject('hideAppCenterWithAnimation')) as Function;
      hideAppCenterWithAnimation();
    }
    AppStorage.setOrCreate('cardWidth', this.getSnapshotWidth(item));
    AppStorage.setOrCreate('isOpenFromPopup', true);
    AppStorage.setOrCreate('cardPositionX', event?.target.area.globalPosition.x as number);
    AppStorage.setOrCreate('cardPositionY', event?.target.area.globalPosition.y as number);
    log.showInfo(`cardWidth: ${this.getSnapshotWidth(item)}, area: ${JSON.stringify(event?.target.area)}`)
    PcDockPopupMgr.getInstance().setIsDockPopupShow(this.screenProp.screenId, false);
    localEventManager.sendLocalEvent(EventConstants.EVENT_RESET_HIDE_DOCK_AFTER_POPUP_STATE_CALLBACK,
      this.screenProp.screenId);
    if (!CheckEmptyUtils.isEmpty(item)) {
      if (item.bundleName === CONTINUE_ABILITY) {
        SCBHiSysEventUtil.reportUserClickContinueIconEvent('continueMission',
          HiSysContinueFuncResult.SUCCESS);
      } else {
        PcDockHiSysEventMgr.reportStartAppFromPopup(item?.bundleName);
        this.moveToFront(item?.sceneSession as SCBSceneContainerSession, item.missionId);
      }
    } else {
      log.showError('onClick, item is empty!');
    }
  }

  private itemHoverAction(item?: SnapshotInfo, isHover?: boolean): void {
    if (CheckEmptyUtils.isEmpty(item)) {
      this.showTipsWithDelay(false);
      log.showError('onHover, item is empty!');
      return;
    }
    this.missionId = isHover ? item?.missionId ?? -1 : -1;
    let missionId: number = this.missionId;
    let scale: number = 1.0;
    if (isHover) {
      scale = 1.01;
      if (this.isDragging) {
        this.moveToFrontWithDelay(item?.sceneSession as SCBSceneContainerSession, missionId, 800);
      }
    } else {
      this.isLabelNameShow = false;
      this.clearMoveToFrontDelayTimer();
    }
    animateTo({ curve: curves.interpolatingSpring(0, 1, 322, 30) }, () => {
      if (isHover !== undefined) {
        this.isHover = isHover;
      }
      this.hoverScale = scale;
    })
  }

  private getImage(item: PreviewImageItem): image.PixelMap | undefined {
    if (item.snapshotInfo?.image) {
      log.showInfo(`getImage return item ${item.snapshotInfo?.missionId} image`);
      return item.snapshotInfo?.image;
    }
    log.showWarn(`item ${item.snapshotInfo?.missionId} image is invalid！！`);
    return this.snapshotImg;
  }

  private getAppIcon(): string {
    let appIcon: string = '';
    ResourceManager.getInstance().getAppIconWithCache(this.mPopItem?.appIconId, this.mPopItem?.bundleName as string,
      this.mPopItem?.moduleName as string, (image: string): void => {
        log.showInfo(`image: ${image}`);
        appIcon = image
      }, StyleConstants.DEFAULT_ICON, 0);
    appIcon = CheckEmptyUtils.isEmpty(appIcon) ? '' : appIcon;
    return appIcon;
  }
}