/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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
  DeviceHelper,
  GlobalContext,
  GlobalSearchStatus,
  HiSysEventUtil,
  IconResourceManager,
  localEventManager,
  SCBDesktopCacheManager,
  SCBWindowSceneConfig,
  sOutSideWindowMgr,
  viewMgrPolicy,
  ViewManagerPolicy,
  ViewType,
  LightOutdoorConfig
} from '@ohos/frameworkwrapper';
import {
  AppStorageUtil,
  CheckEmptyUtils,
  DomainName,
  LogDomain,
  LogHelper,
  SingleBase,
  SingleContext,
  singleManager,
  TraceUtil,
} from '@ohos/basicutils';
import { SCBConstants, } from '@ohos/commonconstants';
import { SCBScreenSessionManager,
  ScenePanelState,
  SCBScreenProperty,
  SCBRotateChangeReason,
  SCBSceneSessionManager } from '@ohos/windowscene';
import { desktopUtil } from '@ohos/componenthelper';
import { DesktopLayoutState, DeviceState } from '@ohos/launchercommon/src/main/ets/constants/CommonConstants';
import {
  AppModel,
  DesktopDataLoader,
  DesktopManager,
  folderLayoutUtil,
  FolderOperationFlag,
  GridLayoutItemInfo,
  DockItemInfo,
  layoutConfigManager,
  PageDesktopLayoutConfig,
  layoutLockUtil,
  RdbStoreManager,
  ResidentLayoutCacheMgr,
  SmartDockLayoutConfig,
  SwiperLoadManager,
  ContractedFolderCommonViewModel,
  PadLaunchLayoutCacheManager,
  DefaultDesktopLayoutInfo,
  GridLayoutUtil,
  FolderCommonUtil,
  DeliverUtil,
  NotHarmonyUtil,
  LaunchLayoutCacheManager,
  LauncherLayoutCacheUtil,
  LayoutDescription,
  desktopItemDraggableManager
} from '@ohos/launchercommon/src/main/ets/TsIndex';
import { BusinessType } from '@ohos/launchercommon/src/main/ets/constants/CommonConstants';
import { settings, systemParameterEnhance } from '@kit.BasicServicesKit';
import { CommonConstants, EventConstants, LayoutViewModel } from '@ohos/launchercommon';
import { SmartDockStyleMgr } from '@ohos/smartdock/src/main/ets/default/manager/SmartDockStyleMgr';
import { PageDesktopViewModel } from '@ohos/pagedesktop/src/main/ets/default/common/viewmodel/PageDesktopViewModel';
import { PageFindPositionHelper } from '@ohos/pagedesktop/src/main/ets/default/common/PageFindPositionHelper';
import { ADMIN_USERID } from '@ohos/windowscene/src/main/ets/oobe/BaseOobeManager';
import { SCBDesktopViewData } from './SCBDesktopViewData';
import { PageDesktopViewModelUtils } from '@ohos/pagedesktop/src/main/ets/default/common/viewmodel/PageDesktopViewModelUtils';
import { FormCenterViewData } from '@ohos/form/src/main/ets/default/viewmodel/FormCenterViewData';
import { ItemLocation } from '@ohos/launchercommon/Index';
import { BigFolderViewModel } from '@ohos/bigfolder';
import { SCBDesktopAddViewModel } from '@ohos/pagedesktop';
import {
  LightOutdoorDesktopViewModel
} from '@ohos/pagedesktop/src/main/ets/default/common/viewmodel/LightOutdoorDesktopViewModel';

const TAG = 'SCBDesktopViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class SCBDesktopViewModel extends SingleBase {
  public static singleName: string = 'SCBDesktopViewModel';
  private static sInstance: SCBDesktopViewModel;

  protected mDesktopViewData: SCBDesktopViewData = new SCBDesktopViewData();

  protected mPageDesktopLayoutConfig: PageDesktopLayoutConfig;

  protected mSmartDockLayoutConfig: SmartDockLayoutConfig;

  protected mDesktopLoader: DesktopDataLoader = DesktopDataLoader.getInstance(this.mDesktopViewData.launcherModel);

  public constructor(ctx?: SingleContext) {
    super(ctx);
    this.mPageDesktopLayoutConfig =
      layoutConfigManager.getFunctionConfig<PageDesktopLayoutConfig>(PageDesktopLayoutConfig.GRID_LAYOUT_INFO);
    this.mSmartDockLayoutConfig = layoutConfigManager.getFunctionConfig(SmartDockLayoutConfig.SMART_DOCK_LAYOUT_INFO);
    this.mDesktopViewData.launcherModel = LayoutViewModel.getInstance().getDesktopModel();
    log.showInfo(`constructor the curDesktopModel ${this.mDesktopViewData.launcherModel}`);
    this.updateDesktopModel(this.mDesktopViewData.launcherModel);
    this.setIsSmallPad();
  }

  /**
   * 退出云端模式2
   */
  public exitLightOutdoorMode(): void {
    let launcherModel: string = settings.getValueSync(GlobalContext.getContext(), CommonConstants.SIMPLE_MODE_KEY, '0');
    this.changeLauncherModel(Number(launcherModel));
    LightOutdoorDesktopViewModel.getInstance().updateIsOnLightOutdoorModeStatus(false);
    settings.setValueSync(GlobalContext.getContext(), CommonConstants.LIGHT_OUTDOOR_MODE_KEY, '0');
  }

  /**
   * 进入云端2
   */
  public enterLightOutdoorMode(): void {
    this.changeLauncherModel(DesktopLayoutState.LIGHT_OUTDOOR_MODE);
    LightOutdoorDesktopViewModel.getInstance().updateIsOnLightOutdoorModeStatus(true);
    settings.setValueSync(GlobalContext.getContext(), CommonConstants.LIGHT_OUTDOOR_MODE_KEY, '1');
    SCBDesktopAddViewModel.getInstance().refreshAllAppList();
  }

  private setIsSmallPad(): void {
    let isMLR: boolean = systemParameterEnhance.getSync('const.build.product', '') === 'MLR';
    FormCenterViewData.getInstance().setIsSmallPad(isMLR);
  }

  public static getInstance(ctx?: SingleContext): SCBDesktopViewModel {
    return singleManager.get<SCBDesktopViewModel>(SCBDesktopViewModel, ctx);
  }

  private loadDesktopModelFromSettings(): number {
    let launcherModel: string = settings.getValueSync(GlobalContext.getContext(), CommonConstants.SIMPLE_MODE_KEY, '0');
    return (launcherModel === String(DesktopLayoutState.SIMPLE_LAUNCHER_MODEL)) ?
    DesktopLayoutState.SIMPLE_LAUNCHER_MODEL : DesktopLayoutState.HOME_LAUNCHER_MODE;
  }

  public updateDesktopModel(launcherModel: number): void {
    log.showInfo('updateDesktopModel curDesktopLauncher %{public}d', launcherModel);
    this.mDesktopViewData.launcherModel = launcherModel;
    this.mDesktopLoader = DesktopDataLoader.getInstance(this.mDesktopViewData.launcherModel, this.singleContext);
    this.mDesktopLoader.initDesktopLayout(launcherModel);
    this.mPageDesktopLayoutConfig.updateDesktopDataLoader(this.mDesktopLoader);
    this.mSmartDockLayoutConfig.updateDesktopDataLoader(this.mDesktopLoader);
  }

  public getDesktopViewData(): SCBDesktopViewData {
    return this.mDesktopViewData;
  }

  public async changeToLoadDesktop(): Promise<void> {
    if (CheckEmptyUtils.isEmpty(this.mDesktopLoader)) {
      log.showError('changeToLoadDesktop error as the load is null');
      return;
    }
    const curDesktopItems: GridLayoutItemInfo[] = LaunchLayoutCacheManager.getInstance().getAllGridLayoutItemList(
      BusinessType.BUSINESS_BASIC_DESKTOP);
    const curDockItems: DockItemInfo[] = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
    let homeLayoutDes: LayoutDescription = LaunchLayoutCacheManager.getInstance().selectLayoutDescription();
    this.refreshDesktopData();
    let isLoadSuccess: boolean = await this.mDesktopLoader.loadDesktopLayout();
    log.showInfo('changeToLoadDesktop with desktopModel %{public}d, loadFromDbSuccess %{public}s',
      this.mDesktopViewData.launcherModel, isLoadSuccess);
    await this.refreshDockData();
    if (!isLoadSuccess) {
      if (this.mDesktopViewData.launcherModel !== DesktopLayoutState.SIMPLE_LAUNCHER_MODEL) {
        // 切换非简易模式,加载预制布局
        let pageCount: number = await this.mDesktopLoader.loadPageCount();
        this.mPageDesktopLayoutConfig?.loadDataFromConfiguration(pageCount, this.mDesktopViewData.launcherModel);
        return;
      } else {
        // 首次切换简易佈局，加载标准模式数据库转换为简易模式初始化数据
        let simpleLayoutInfo: DefaultDesktopLayoutInfo = await this.loadSimpleDataFromHomeData(
          curDesktopItems, curDockItems, homeLayoutDes);
        await RdbStoreManager.getInstance().insertGridLayoutInfo(simpleLayoutInfo.layoutInfo, true, false);
        this.mDesktopLoader.initLayoutCache(simpleLayoutInfo);
      }
    }
    localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_PAGEDESK_RELOAD_REFRESH, null);
  }

  private async refreshDockData(): Promise<void> {
    SmartDockStyleMgr.getInstance().reSetDockCenter();
    // clear cache and init smart dock info.
    await ResidentLayoutCacheMgr.getInstance().clearCacheAndInit(TAG);
    folderLayoutUtil.initFolderLayoutConfig();
  }

  public refreshDesktopData(): void {
    SwiperLoadManager.getInstance().clearSwiperPages();
    PageDesktopViewModel.getInstance().initAfterModelChange();
  }

  private async loadSimpleDataFromHomeData(homeDesktopItems: GridLayoutItemInfo[],
    homeDockItems: DockItemInfo[], homeLayoutDes: LayoutDescription): Promise<DefaultDesktopLayoutInfo> {
    log.showWarn('loadSimpleDataFromHomeData homeDesktopItems:%{public}d, homeDockItems:%{public}d',
      homeDesktopItems.length, homeDockItems.length);

    // 1. 从配置文件初始化简易布局网格配置，以及预制布局里首个时钟卡片元素
    let simpleLayoutInfo: DefaultDesktopLayoutInfo = await this.mDesktopLoader.loadFromJsonConfig();
    simpleLayoutInfo.layoutInfo = simpleLayoutInfo.layoutInfo.filter((item: GridLayoutItemInfo) => {
      return item.container !== CommonConstants.CONTAINER_SMARTDOCK;
    });
    simpleLayoutInfo.layoutInfo = simpleLayoutInfo.layoutInfo.slice(0, 1);

    // 2. Dock元素继承到简易桌面
    this.processDockItemToSimpleDesktop(homeDockItems, simpleLayoutInfo);
    // 3. 桌面元素继承到简易桌面
    this.processDesktopItemToSimpleDesktop(homeDesktopItems, simpleLayoutInfo, homeLayoutDes);
    // 4. 主布局没有时钟卡片，则删除简易桌面首页时钟卡片
    this.processClockCardToSimpleDesktop(homeDesktopItems, simpleLayoutInfo);

    return simpleLayoutInfo;
  }

  /**
   * 天气时钟卡片继承到简易桌面首页
   *
   * @param homeDockItems
   */
  public processClockCardToSimpleDesktop(homeDesktopItems: GridLayoutItemInfo[],
    simpleLayoutInfo: DefaultDesktopLayoutInfo): void {
    let hasWeatherCard = false;
    for (let i = 0; i < homeDesktopItems.length; i++) {
      if (LauncherLayoutCacheUtil.checkIfWeatherCard(homeDesktopItems[i])) {
        hasWeatherCard = true;
      } else if (homeDesktopItems[i].typeId === CommonConstants.TYPE_FORM_STACK) {
        let mLayoutInfo = homeDesktopItems[i].layoutInfo;
        if (!mLayoutInfo || CheckEmptyUtils.isEmptyArr(mLayoutInfo) || CheckEmptyUtils.isEmptyArr(mLayoutInfo[0])) {
          continue;
        }
        for (let j = 0; j < mLayoutInfo[0].length; j++) {
          if (LauncherLayoutCacheUtil.checkIfClockCard(mLayoutInfo[0][j])) {
            hasWeatherCard = true;
            break;
          }
        }
      }
      if (hasWeatherCard) {
        break;
      }
    }
    if (!hasWeatherCard) {
      log.showInfo('not found clock card from homeDesktop');
      simpleLayoutInfo.layoutInfo = simpleLayoutInfo.layoutInfo.slice(1);
    }
  }

  /**
   * Dock元素继承到简易桌面
   *
   * @param homeDockItems
   * @param simpleLayoutInfo
   */
  private processDockItemToSimpleDesktop(homeDockItems: DockItemInfo[],
    simpleLayoutInfo: DefaultDesktopLayoutInfo): void {
    if (homeDockItems.length <= simpleLayoutInfo.layoutDescription.column) {
      log.showInfo('processDockItemToSimpleDesktop no need inherit dock. length=%{public}d', homeDockItems.length);
      return;
    }

    // Dock栏元素超过3个，则将最后一个元素继承到简易桌面首页右下角
    let inheritDockItem: DockItemInfo = homeDockItems[simpleLayoutInfo.layoutDescription.column];
    let addDeskItemFromDock: GridLayoutItemInfo = GridLayoutUtil.dockItemToGridLayout(inheritDockItem);
    addDeskItemFromDock.row = simpleLayoutInfo.layoutDescription.row - 1;
    addDeskItemFromDock.column = simpleLayoutInfo.layoutDescription.column - 1;
    addDeskItemFromDock.container = CommonConstants.CONTAINER_DESKTOP;
    if (addDeskItemFromDock.typeId === CommonConstants.TYPE_FOLDER) {
      addDeskItemFromDock.folderId = FolderCommonUtil.transFolderID(addDeskItemFromDock.folderId, 'J');
      addDeskItemFromDock.infoId = addDeskItemFromDock.folderId;
      addDeskItemFromDock.bundleName = addDeskItemFromDock.folderId;
      addDeskItemFromDock.keyName = addDeskItemFromDock.folderId;
    }
    log.showInfo('loadSimpleDataFromHomeData addDockItem:%{public}s, row:%{public}d, column:%{public}d',
      addDeskItemFromDock.bundleName, addDeskItemFromDock.row, addDeskItemFromDock.column);
    simpleLayoutInfo.layoutInfo.push(addDeskItemFromDock);
  }

  /**
   * 桌面元素继承到简易桌面
   *
   * @param homeDesktopItems
   * @param simpleLayoutInfo
   */
  private processDesktopItemToSimpleDesktop(homeDesktopItems: GridLayoutItemInfo[],
    simpleLayoutInfo: DefaultDesktopLayoutInfo, homeLayoutDes: LayoutDescription): void {
    // 继承标准布局图标和文件夹,按[页,行,列]三元组顺序排列
    let inheritItems = homeDesktopItems.filter((val: GridLayoutItemInfo) => {
      return val.typeId === CommonConstants.TYPE_APP ||
        val.typeId === CommonConstants.TYPE_SHORTCUT_ICON ||
        val.typeId === CommonConstants.TYPE_FOLDER;
    });
    inheritItems.sort((a: GridLayoutItemInfo, b: GridLayoutItemInfo) => {
      return GridLayoutUtil.getSortRankByPageRowColumn(a, homeLayoutDes.row, homeLayoutDes.column) -
        GridLayoutUtil.getSortRankByPageRowColumn(b, homeLayoutDes.row, homeLayoutDes.column);
    });
    this.transFolderItems(inheritItems);
    log.showWarn('loadSimpleDataFromHomeData inheritItems:%{public}d', inheritItems.length);
    // 继承元素按顺序加入简易布局网格
    this.findInheritItemPosition(inheritItems, simpleLayoutInfo);
  }


  private transFolderItems(inheritItems: GridLayoutItemInfo[]): void {
    // 所有普通大文件夹转换为小文件夹，特殊文件夹(克隆应用/应用/未鸿蒙化)大于2*2转化为2*2文件夹,同步设置folderID前缀,避免加载异常
    inheritItems.forEach((item: GridLayoutItemInfo) => {
      if (item.typeId === CommonConstants.TYPE_FOLDER) {
        if (!DeliverUtil.isContainerFolder(item.folderId) &&
          !NotHarmonyUtil.isNotHarmonyFolderById(item.folderId)) {
          item.area = [1, 1];
        } else if (item.area && item.area.length === 2 && (item.area[0] > 2 || item.area[1] > 2)) {
          item.area = [2, 2];
        }
        item.folderId = FolderCommonUtil.transFolderID(item.folderId, 'J');
        item.infoId = item.folderId;
        item.bundleName = item.folderId;
        item.keyName = item.folderId;
        log.showInfo(`folderId: ${item.folderId} inherit size ${item.area}`);
      }
    });
  }

  /**
   * 继承元素找位加入简易布局
   *
   * @param inheritItems
   * @param simpleLayoutInfo
   */
  private findInheritItemPosition(inheritItems: GridLayoutItemInfo[],
    simpleLayoutInfo: DefaultDesktopLayoutInfo): void {
    let findHelper = new PageFindPositionHelper(simpleLayoutInfo.layoutDescription.column,
      simpleLayoutInfo.layoutDescription.row);
    findHelper.markMultiItemsPosition(simpleLayoutInfo.layoutInfo);

    let itemLocation: ItemLocation = PageDesktopViewModelUtils.getStartFindItemLocation(0, 0, 0);
    let isFirstVisit: boolean = true;
    for (let i = 0; i < inheritItems.length; i++) {
      let item = inheritItems[i];
      if (itemLocation.curPage >= simpleLayoutInfo.layoutDescription.maxPage) {
        // 超过18屏元素通过桌面加载兜底逻辑，找位放入文件夹
        log.showInfo('inherit items over 18 pages');
        break;
      }
      if (isFirstVisit && itemLocation.curPage >= simpleLayoutInfo.layoutDescription.maxPage - 2) {
        this.swapContainerFoldersToLastTwoPages(inheritItems, i);
        isFirstVisit = false;
        i--;
        continue;
      }

      let isFind = findHelper.findBlankPosition(item, itemLocation);
      if (isFind) {
        // 元素加入空位
        item.page = itemLocation.findPage;
        item.row = itemLocation.findRow;
        item.column = itemLocation.findCol;
        simpleLayoutInfo.layoutDescription.pageCount = itemLocation.findPage + 1;
        simpleLayoutInfo.layoutInfo.push(item);
        findHelper.markItemPosition(item);
        log.showInfo('inherit addItem:%{public}s to pos [p:%{public}d,c:%{public}d,r:%{public}d]',
          item.bundleName, item.page, item.column, item.row);
      } else {
        log.showInfo('inherit addItem:%{public}s find pos failed', item.bundleName);
        // 当前页无空位，刷新到新的一页重新找位
        itemLocation.curPage = itemLocation.curPage + 1;
        itemLocation.curRow = 0;
        itemLocation.curCol = 0;
        findHelper.resetGridStatus();
        i--;
      }
    }
  }

  private swapContainerFoldersToLastTwoPages(inheritItems: GridLayoutItemInfo[], i: number): void {
    // 倒数两屏，优先处理放置克隆应用/应用/未鸿蒙化特殊文件夹
    log.showInfo('swapContainerFoldersInLastTwoPages over 16 pages');
    let leftInheritItems = inheritItems.slice(i);
    let leftContainerFolders = leftInheritItems.filter((item: GridLayoutItemInfo) => {
      return DeliverUtil.isContainerFolder(item.folderId) || NotHarmonyUtil.isNotHarmonyFolderById(item.folderId);
    });
    for (let j = 0; j < leftContainerFolders.length; j++) {
      log.showInfo(`swapContainerFoldersInLastTwoPages containerFolder:${leftContainerFolders[j].folderId}`);
      let itemPos = inheritItems.indexOf(leftContainerFolders[j]);
      if (itemPos > CommonConstants.INVALID_VALUE) {
        // 继承数组删除特殊文件夹，重新插入当前位置
        inheritItems.splice(itemPos, 1);
        inheritItems.splice(i + j, 0, leftContainerFolders[j]);
      }
    }
  }

  public getDesktopModel(): number {
    return this.mDesktopViewData.launcherModel;
  }

  /**
   * 注冊简易模式/普通模式设置切换回调
   */
  public registerLauncherModelChangeListener(): void {
    try {
      settings.registerKeyObserver(GlobalContext.getContext(), CommonConstants.SIMPLE_MODE_KEY,
        settings.domainName.DEVICE_SHARED, (err, value) => {
          let launcherModel: string = settings.getValueSync(GlobalContext.getContext(), CommonConstants.SIMPLE_MODE_KEY, '0');
          log.showWarn('registerLauncherModelChangeListener, value %{public}s, info cold: %{public}d msg: %{public}s',
            launcherModel, err?.code, err?.message);
          let isGridListFinished: boolean | undefined = AppStorage.get<boolean>('isGridListFinished');
          if (isGridListFinished === false) {
            PageDesktopViewModel.getInstance().registerDelayPropertyChangeCallback(() => {
              this.changeLauncherModel(Number(launcherModel));
            });
            log.showWarn('processChangeLauncherModel delay as gridList process not finished');
            return;
          }
          this.changeLauncherModel(Number(launcherModel));
        });
    } catch (err) {
      log.showError('registerLauncherModelChangeListener error, with code %{public}d, msg %{public}s', err?.code, err?.message);
    }
  }

  /**
   * 反注冊简易模式/普通模式设置切换回调
   */
  public unRegisterLauncherModelChangeListener(): void {
    try {
      settings.unregisterKeyObserver(GlobalContext.getContext(), CommonConstants.SIMPLE_MODE_KEY,
        settings.domainName.DEVICE_SHARED);
    } catch (err) {
      log.showError('unRegisterLauncherModelChangeListener error, with code %{public}d, msg %{public}s', err?.code, err?.message);
    }
  }

  /**
   * 模式状态切换， 当前在普通桌面，简易，云端2三种状态切换
   * @param launcherModel
   */
  private changeLauncherModel(launcherModel: number): void {
    log.showWarn('start to changeLauncherModel: %{public}d', launcherModel);
    if (launcherModel === this.mDesktopViewData.launcherModel) {
      log.showError('changeLauncherModel not change: %{public}d', this.mDesktopViewData.launcherModel);
      return;
    }

    AppStorage.setOrCreate('isGridListFinished', false);
    layoutLockUtil.init();
    ContractedFolderCommonViewModel.getInstance()
      .closeFolder('close folder by launcher mode change', FolderOperationFlag.IMMEDIATELY);
    localEventManager.sendLocalEventSticky(EventConstants.EVENT_FOLDER_DELETE_ALL_NODE_CACHE, null);
    // 1.更新桌面模式
    this.updateDesktopModel(launcherModel);
    // 2.桌面布局参数计算切换
    localEventManager.sendLocalEventSticky(EventConstants.EVENT_DESKTOP_MODE_CHANGE, launcherModel);
    // 3.桌面数据切换
    this.changeToLoadDesktop();
    // 4.更新桌面数据库card_info表中的status字段, 全搜根据status过滤搜索结果, 简易模式下为1不展示卡片搜索结果
    RdbStoreManager.getInstance().batchUpdateAppItemFormInfo(this.mDesktopViewData.launcherModel);
  }

  /**
   * 屏幕属性变化处理：无动效旋转场景
   * (注：当前仅折叠屏展开态以及pad涉及该场景：竖屏打开横屏应用、横屏打开竖屏应用)
   *
   * @param isPortrait 是否是横屏
   * @param isNeedCloseFolder 是否需要关闭文件夹
   */
  public screenChangeRotationNoAnim(isPortrait: boolean, isNeedCloseFolder: boolean): void {
    log.showInfo(`screenChangeRotationNoAnim: isPadUiType:${this.isPadUiType()}; ${isPortrait}; ${isNeedCloseFolder}；`);
    AppStorageUtil.setOrCreate<boolean>('isPortrait', isPortrait);
    if (this.isPadUiType()) {
      PageDesktopViewModel.getInstance().changeCurrentLayoutCache(isPortrait);
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_PAGEDESK_LIGHT_REFRESH, false);
    }
    if (isNeedCloseFolder) {
      this.closeFolderImmediately();
    }
    this.sendRefreshSwiperPageEventForThreeFoldPhone();
  }

  /**
   * 屏幕属性变化处理：折叠屏开合（展开或折叠）
   */
  public screenChangeExpandOrFold(foldStatus: DeviceState, isPortrait: boolean, isStatusChange: boolean): void {
    this.closeFolderImmediately(true);
    let expandStatus = SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus();
    SCBDesktopCacheManager.getInstance().setDesktopCacheWithDfx(false, 'cancel desktop cache', false, expandStatus);
    AppStorage.setOrCreate<number>('folderStatusMenu', foldStatus);
    if (foldStatus === DeviceState.EXPAND_STATE) {
      HiSysEventUtil.setScreenType(CommonConstants.NORMAL_SCREEN_TYPE);
    } else {
      HiSysEventUtil.setScreenType(CommonConstants.OUTER_SCREEN_TYPE);
    }
    if (isStatusChange) {
      this.singleDisplaySwitch();
    }
    if (desktopUtil.isFold()) {
      AppStorageUtil.setOrCreate<number>('folderStatus', foldStatus);
    }
    AppStorageUtil.setOrCreate<boolean>('isPortrait', isPortrait);
    BigFolderViewModel.getInstance().reLayoutFolder();
    this.sendRefreshSwiperPageEventForThreeFoldPhone();
    DesktopManager.getInstance().saveDesktopParam();
  }

  /**
   * 屏幕属性变化处理：带动效旋转场景
   */
  public screenChangeRotationAnim(isPortrait: boolean): void {
    this.closeFolderImmediately();
    AppStorage.setOrCreate<boolean>('isPortrait', isPortrait);
    if (this.isPadUiType()) {
      PageDesktopViewModel.getInstance().changeCurrentLayoutCache(isPortrait);
      if (!PadLaunchLayoutCacheManager.getInstance().getIsGridConfigInit()) {
        log.showWarn('getIsGridConfigInit false return!');
        return;
      }
    }
    localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_PAGEDESK_LIGHT_REFRESH, false);
    this.sendRefreshSwiperPageEventForThreeFoldPhone('screenChangeRotationAnim');
  }

  /**
   * 在三折叠手机上，每次折展，旋转事件发出后都需要刷布局
   */
  private sendRefreshSwiperPageEventForThreeFoldPhone(label?: string) {
    if (DeviceHelper.isThreeFoldProduct()) {
      localEventManager.sendLocalEvent(EventConstants.EVENT_REFRESH_SWIPER_PAGE, label);
    }
  }

  /**
   * 单手模式进入、退出
   */
  public screenChangeSingleHand(): void {
    this.closeFolderImmediately(true);
    DesktopManager.getInstance().execScreenChangeListener();
    BigFolderViewModel.getInstance().reLayoutFolder();
  }

  /**
   * 关闭文件夹
   *
   * @param isFolderStatusChang true：不使能文件夹反向添加弹框消失动效
   */
  public closeFolderImmediately(isFolderStatusChang: boolean = false): void {
    log.showInfo('closeFolderImmediately');
    ContractedFolderCommonViewModel.getInstance()
      .closeFolder('close folder by lock screen', FolderOperationFlag.IMMEDIATELY);
    // 关闭文件夹时，关闭弹窗
    localEventManager.sendLocalEventAsync(EventConstants.EVENT_EDIT_MODE_TOUCH_DOWN_ITEM,
      { folderStatusChang: isFolderStatusChang });
  }

  /**
   * 是否为PadUI布局
   *
   * @returns true：是
   */
  public isPadUiType(): boolean {
    const uiType = SCBWindowSceneConfig.getInstance().windowSceneConfig?.uiType;
    return uiType === SCBConstants.UITYPE_PAD;
  }

  private singleDisplaySwitch(): void {
      return;
  }

  /**
   * 是否需要跳过开合动效
   *
   * @param scenePanelState 当前桌面状态
   * @returns true：跳过开合动效
   */
  public skipFoldExpandAnimation(scenePanelState: number): boolean {
    // 锁屏显示、下拉搜索显示非滑动唤醒状态、窗口显示场景不走桌面开合动画
    if (viewMgrPolicy.isViewShowing(ViewType.KEYGUARD)) {
      log.showInfo('skipFoldExpandAnimation as ViewType.KEYGUARD is showing');
      return true;
    }
    if (scenePanelState === ScenePanelState.FULLSCENE) {
      log.showInfo('skipFoldExpandAnimation as ScenePanelState is FULLSCENE');
      return true;
    }
    let isDoneShowingNegativeScreen =
      viewMgrPolicy.isViewShowing(ViewType.NEGATIVE_SCREEN) && sOutSideWindowMgr.isShowNegative();
    if (isDoneShowingNegativeScreen) {
      log.showInfo('skipFoldExpandAnimation because Negative Screen is done showing');
      return true;
    }
    let globalSearchStatus = sOutSideWindowMgr.getGlobalSearchStatus();
    let isShouldSkipGlobalSearch = viewMgrPolicy.isViewShowing(ViewType.GLOBAL_SEARCH) &&
      globalSearchStatus !== GlobalSearchStatus.WAKING &&
      globalSearchStatus !== GlobalSearchStatus.BACK_OUT;
    if (isShouldSkipGlobalSearch) {
      log.showInfo('skipFoldExpandAnimation when showing GlobalSearch');
      return true;
    }
    return false;
  }

  /**
   *  加载首页和dock应用的图标
   */
  public async initFirstPage(): Promise<void> {
    let userId: number = AppModel.getInstance().getUserId();
    if (userId === ADMIN_USERID) {
      return;
    }
    TraceUtil.startTrace(DomainName.SCB, 'queryApplication');
    let itemInfos: GridLayoutItemInfo[] = await RdbStoreManager.getInstance().queryFirstPageAndDockApplication();
    TraceUtil.endTrace(DomainName.SCB, 'queryApplication');
    if (CheckEmptyUtils.isEmptyArr(itemInfos)) {
      log.showWarn('initFirstPage db result is null');
      return;
    }
    log.showInfo(`initFirstPage ApplicationSize: ${itemInfos.length}`);
    TraceUtil.startTrace(DomainName.SCB, 'initFirstPage');
    let iconResource = IconResourceManager.getInstance();
    try {
      for (let itemInfo of itemInfos) {
        iconResource.getCombIcon(itemInfo.bundleName, itemInfo.moduleName, itemInfo.abilityName);
      }
    } catch (error) {
      log.error('initFirstPage', error);
    } finally {
      log.info('initFirstPage finally');
    }
    TraceUtil.endTrace(DomainName.SCB, 'initFirstPage');
  }

  /**
   * 判断解锁后的界面是否是桌面
   *
   * @returns true: 解锁后的界面是桌面
   */
  public isUnlockToHome(): boolean {
    let scenePanelState: number = AppStorage.get<number>('scenePanelState') as number;
    let showGlobalSearch: boolean = sOutSideWindowMgr.isShowGlobalSearch();
    let showNegativeScreen: boolean = ViewManagerPolicy.isViewShowing(ViewType.NEGATIVE_SCREEN);
    let activeSessionListIsEmpty: boolean = SCBSceneSessionManager.getInstance().checkActiveSessionListIsEmpty();
    // 锁屏状态下窗口会将scenePanelState置为0,如果当前为应用页面，会将应用id写入集合，解锁时取出id并将集合清空，同时需要判断全搜和负一屏
    let isUnlockToOnHome: boolean = scenePanelState === 0 && activeSessionListIsEmpty &&
      !showGlobalSearch && !showNegativeScreen;
    return isUnlockToOnHome;
  }
}