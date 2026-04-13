/**
 * Copyright (c) 2021-2024 Huawei Device Co., Ltd.
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
import ArrayList from '@ohos.util.ArrayList';
import HashSet from '@ohos.util.HashSet';
import Prompt from '@ohos.promptAction';
import hiSysEvent from '@ohos.hiSysEvent';
import formInfo from '@ohos.app.form.formInfo';
import { bundleManager, common, Want } from '@kit.AbilityKit';
import CommonEventManager from '@ohos.commonEventManager';
import { image } from '@kit.ImageKit';
import { BusinessError, commonEventManager, systemParameterEnhance } from '@kit.BasicServicesKit';
import { componentSnapshot, display, promptAction, UIContext } from '@kit.ArkUI';
import { SCBOobeManager, SCBSceneMode, SCBSceneSessionManager } from '@ohos/windowscene';
import { FormStackModel } from '@ohos/formstack/src/main/ets/common/FormStackModel';
import { FormEditViewManager } from '@ohos/launchercommon/src/main/ets/manager/FormEditViewManager';
import {
  AppGalleryDownloadManager,
  AppGalleryEventInfo,
  AppItemInfo,
  AppModel,
  AppStatus,
  BadgeItemInfo,
  BadgeManager,
  BaseViewModel,
  CardItemInfo,
  ClickCardShortcutMenuEvent, CommonConstants,
  DeleteItemType,
  NotHarmonyUtil,
  DesktopFileInfo,
  DisposedEventManager,
  DockItemInfo,
  DownloadStatusInfo,
  DragAddCardEvent,
  EventConstants,
  Extend1Data,
  FileType,
  FolderDataModelManager,
  FolderLayoutCacheManager,
  FolderModel,
  FolderViewModel,
  FormCenterViewManager,
  FormHiSysEventReporter,
  FormLayoutCacheManager,
  FormListInfoCacheManager,
  FormManager,
  FormModel,
  GridLayoutConfig,
  GridLayoutItemInfo,
  GridLayoutUtil,
  KeyEventConstants,
  keyEventManager,
  LauncherLayoutCacheUtil,
  LaunchLayoutCacheManager,
  ContactCacheManager,
  layoutConfigManager,
  LayoutDescription,
  layoutLockUtil,
  LayoutViewModel,
  MenuInfo,
  MenuInfoManager,
  PadLaunchLayoutCacheManager,
  PageInfoManager,
  PageDesktopLayoutConfig,
  PageDesktopModel,
  SelectChangeListener,
  FocusChangeListener,
  SelectItemChangeListener,
  VisibleChangeListener,
  UninstallListener,
  GridAppListInfo,
  GridAppListInfoNew,
  PageInfo,
  StartInfo,
  PageColumnInfo,
  ResponseCode,
  FormAnimateData,
  RdbStoreManager,
  SettingsModel,
  SettingsModelObserver,
  ShortcutMenuClickType,
  ShortcutViewModel,
  StyleConstants,
  SwiperLoadManager,
  ViewManager,
  CloseAppManager,
  HiEditModeEventUtils,
  LauncherLayoutCacheConfig,
  ShortcutInfo,
  ThemeServiceManager,
  lockedAppUninstallModel,
  APP_LOCKED_ERROR_CODE,
  AppInstallUtils,
  scbBlankPositionUtils,
  AppInstallEventData,
  ClickAddCardEvent,
  ResidentLayoutCacheMgr,
  DesktopUtils,
  PreInstallUtils,
  SceneMsgEnum,
  FormCommonUtil,
  HighFrequencyCallStatistics,
  FolderDataListener,
  FolderDataRefreshType,
  FolderLifeCyclePriority,
  FolderManager,
  ContractedFolderCommonViewModel,
  ContractedFolderLayoutViewModel,
  lockLayoutManager,
  KeyEventListener,
  FormHostService,
  EditModeUtils,
  ReceiveEventInfo,
  FoldersData,
  PageDesktopViewModelForPC,
  DesktopPosition,
  FolderCommonUtil,
  MenuInfoType,
  desktopItemDraggableManager,
} from '@ohos/launchercommon';
import { StartAppType } from '@ohos/launchercommon/src/main/ets/constants/CommonConstants';
import lazy { pocketPreferenceUtil } from '@ohos/launchercommon/src/main/ets/utils/PocketPreferenceUtil';
import { FormDetailLayoutConfig } from '@ohos/form/src/main/ets/default/common/FormDetailLayoutConfig';
import {
  CheckEmptyUtils,
  CommonUtils,
  DomainName,
  LogDomain,
  Logger,
  Trace,
  TraceUtil,
  StartType,
  ArrayUtils,
  SingleContext,
  singleManager,
} from '@ohos/basicutils';
import {
  AccountMgr,
  GlobalContext,
  HiDfxEventUtil,
  HiSysEventUtil,
  InstallStatusChangeEvent,
  localEventManager,
  DeviceHelper,
  ResourceManager,
  ResultType,
  SCBWindowSceneConfig,
  WallpaperColorManager,
  sOutSideWindowMgr,
  AccessibilityManager,
  SCBVisualEffectData
} from '@ohos/frameworkwrapper';
import { GravityAnimationListener, gravityAnimationListenerManager, } from '@ohos/componentanimator';
import { desktopUtil, ObjectCopyUtil } from '@ohos/componenthelper';
import {
  launcherStatusUtil,
  ScenePanelState,
  DisplayConstants,
  ResUtils,
} from '@ohos/windowscene';
import { NumberConstants, SCBConstants, KeyCodeConstants, VisualEffectConstants } from '@ohos/commonconstants';
import { SCBVisualEffectMgr } from '@ohos/componenthelper/src/main/ets/manager/SCBVisualEffectManager';
import { DragEventManager, windowManager, DragGridPosition, } from '@ohos/componentdrag';
import { FormViewModel } from '@ohos/form/src/main/ets/default/viewmodel/FormViewModel';
import FormConstants from '@ohos/form/src/main/ets/default/common/constants/FormConstants';
import FeatureConstants from '../constants/FeatureConstants';
import { PageDesktopGridStyleConfig } from '@ohos/launchercommon/src/main/ets/layoutconfig/PageDesktopGridStyleConfig';
import { PageDesktopDragHandler } from '../PageDesktopDragHandler';
import formHost from '@ohos.app.form.formHost';
import type FileFolderManager from '@ohos/desktopfilefolder/src/main/ets/default/manager/FileFolderManager';
import fileFolderManagerFactory from '@ohos/desktopfilefolder/src/main/ets/default/manager/FileFolderManagerFactory';
import fileInfoUpdateManager from '@ohos/desktopfilefolder/src/main/ets/default/FileInfoUpdateManager';
import type { FormStyleConfig } from '@ohos/form/src/main/ets/default/common/FormStyleConfig';
import AppFormWeightManager from '@ohos/form/src/main/ets/default/manager/AppFormWeightManager';
import type { Callback } from '@ohos.base';
import type ServiceExtensionContext from 'application/ServiceExtensionContext';
import type ctx from '@ohos.app.ability.common';
import { PageDesktopViewModelUtils, SqueezeGridLayout } from './PageDesktopViewModelUtils';
import { FormManageResponse } from '@ohos/form/src/main/ets/default/service/ServiceInterface';
import {
  BusinessType,
  DesktopLayoutState,
  DesktopSortInfo,
  DesktopSortRule,
  ItemParameter,
  PageType
} from '@ohos/launchercommon/src/main/ets/constants/CommonConstants';
import { OverflowFormInfoUtil } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { BigFolderViewModel } from '@ohos/bigfolder/src/main/ets/default/viewmodel/BigFolderViewModel';
import { AppFormWantParamInterface } from '@ohos/launchercommon/src/main/ets/manager/FormManager';
import { FocusViewModel } from './FocusViewModel';
import { AppListInfo } from '../dao/AppListInfo';
import { systemParameter } from '@kit.BasicServicesKit';
import MultipleDragSettings, { MultipleDragPosition } from '@ohos/launchercommon/src/main/ets/pagedesktop/viewmodel/MultipleDragSettings';
import DesktopSortUtils from '../DesktopSortUtils';
import { OverflowConstants} from '@ohos/commonconstants/src/main/ets/constants/SCBConstants';
import { FormHiSysEventUtil, ScreenSelectType } from '@ohos/form/src/main/ets/default/util/FormHiSysEventUtil';
import { CardAddType } from '@ohos/launchercommon/src/main/ets/manager/FormCenterViewManager';
import { AppLockUtils, AppLockManager, editModeManager } from '@ohos/launchercommon';
import UDC from '@ohos.data.unifiedDataChannel';
import { AutoAlignDataManager } from '../autoalign/AutoAlignDataManager';
import { AppCategoryUtils } from '@ohos/launchercommon/src/main/ets/utils/AppCategoryUtils';
import { AppCategoryInfoManager } from '@ohos/launchercommon/src/main/ets/manager/AppCategoryInfoManager';
import CardLockUtils from '@ohos/launchercommon/src/main/ets/utils/CardLockUtils';
import CardLockManager from '@ohos/launchercommon/src/main/ets/manager/CardLockManager';
import { PreviewConstants } from '../../preview/PreviewConstants';
import { GridItemsPool } from '../../manager/GridItemsPool';
import lazy { OverflowGrayAppManager } from '../components/liveform/common/OverflowGrayAppManager';
import { MatchCardDataManager } from '@ohos/launchercommon/src/main/ets/model/MatchCardDataManager';
import { GameEventListener } from '@ohos/launchercommon/src/main/ets/listener/GameEventListener';
import { MatchCardLayoutManager } from './MatchCardLayoutManager';
import { MemoryManager } from '@ohos/frameworkcommon';
import { LauncherDebug } from '../dfx/LauncherDebug';
import { DesktopAccessibilityUtils } from '../DesktopAccessibilityUtils';
import {
  ItemLocation,
  PageDesktopViewModelProxy,
  IPageDesktopViewModel,
  PageDesktopOneShotManager,
} from '@ohos/launchercommon/Index';
import {
  DesktopItemBuilderProxy
} from '@ohos/launchercommon/src/main/ets/pagedesktop/viewmodel/DesktopItemBuilderProxy';
import { AppItemBuilder } from '../components/AppItem';
import { FileFolderItemBuilder } from '../components/FileFolderItem';
import { LauncherStartup, StartupStep } from '@ohos/launchercommon/src/main/ets/tools/LauncherStartup';
import { SCBDesktopAddViewModel } from '../components/desktopaddapp/SCBDesktopAddViewModel';

const TAG = 'PageDesktopViewModel';
const log: Logger = Logger.getLogHelper(LogDomain.HOME);
const iconLog: Logger = Logger.getLogHelper(LogDomain.ICON);
const formLog: Logger = Logger.getLogHelper(LogDomain.FORM);
const KEY_FORM_LIST = 'formListInfo';
const INVALID_IDX = -1;
const MAX_VISIBLE_SETABLE = 32;
const START_FIND_POSITION_BIG_FOLD = 2;
const ROW_OFFSET_THREE = 3;
const DELAY_TIME_FOR_NOTIFY_PAGE_INVISIBLE = 2000;
const DELAY_TIME_INSTALL_AFTER_REMOVE = 1000;
const INVALID_TIMER: number = -1;
const INVISIBLE_DELAY_TIMER_WHEN_START_APP: number = 3000;
const RECYCLE_DELAY_TIMER_WHEN_START_APP: number = 3 * 60 * 1000;
const RECOVER_DELAY: number = 2 * 1000;
const CARD_RECYCLE_LIMIT: number = 7;
const ON_FOCUS_CLICK_DELAY = 300;
const REFRESH_DESKTOP_DELAY = 500;
const SNAPSHOT_MAP_COUNT = 3;
const SWIPER_PAGE_GRID_WORKSPACE_0: string = 'SwiperPage_Grid_WorkSpace_0';
const THREE_IN_ONE_CARDNAMES = ['ClockWeatherCard', 'ClockWeatherHoriCard']; // 三合一卡片 cardName
// 三合一卡片 cardName-bundleName-abilityName-moduleName
const THREE_IN_ONE_CARDS = new Set([
  'ClockWeatherCard-com.ohos.totemweather-FormAbility-product',
  'ClockWeatherHoriCard-com.ohos.totemweather-FormAbility-product'
]);
const EVENT_INSTALL_STATUS_CHANGE = 'com.ohos.appgallery.commonevent.EVENT_INSTALL_STATUS_CHANGE';
const BUNDLE_NAME_AG = 'com.ohos.appgallery';
const ENTERPRISE_APP_AUTH_CHANGE_CODE = 519;
const ENTERPRISE_APP_AUTH_SUCCESS_STATUS = 0;
const DUE_HAP_CFG_UPDATED = 'usual.event.DUE_HAP_CFG_UPDATED';
const EVENT_INTELLIGENT_CLOSE_SCB: string = 'intelligent_close_SCBNegativeScreen';
const DELAY_OBTAIN_SNAPSHOT: number = 10;
const CALL_STATISTICS_SCENE_COUNT = 4;

export class PageDesktopViewModel extends BaseViewModel implements IPageDesktopViewModel {
  public static singleName: string = 'PageDesktopViewModel';
  private readonly pageDesktopStyleConfig: PageDesktopGridStyleConfig;
  private readonly formDetailLayoutConfig: FormDetailLayoutConfig;
  private readonly mSettingsModel: SettingsModel;
  private readonly mFolderModel: FolderModel;
  private readonly mFormStackModel: FormStackModel;
  private readonly mFormModel: FormModel;
  private readonly mPageDesktopModel: PageDesktopModel;
  private readonly mFormListInfoCacheManager: FormListInfoCacheManager;
  private readonly mFormHostService: FormHostService;
  private readonly mLauncherLayoutCacheManager: LaunchLayoutCacheManager;
  private readonly mShortcutViewModel: ShortcutViewModel;
  private mBundleInfoList: GridLayoutItemInfo[] = [];
  private mHideBundleInfoList = new Array<AppItemInfo>();
  private mGridConfig: GridLayoutConfig;
  private mPageIndex: number = 0;
  private mTargetIndex: number = 0;
  private mOldPageIndex: number = 0;
  private mPageInvisibleTimer: number = INVALID_TIMER;
  private startRecycleTimer: number = INVALID_TIMER;
  private startInvisibleTimer: number = INVALID_TIMER;
  private gameEventListener: GameEventListener = GameEventListener.getInstance();
  private mGridAppsInfos: GridLayoutItemInfo[][] = [];
  private fileFolderManager: FileFolderManager = fileFolderManagerFactory.getFileFolderManager();
  private isPad = false;
  private isBigScreen: boolean = false;
  private isAddByDraggingFlag = false;
  private desktopSwiperController: SwiperController | undefined;
  private mMenuInfoManager: MenuInfoManager;
  private unInstallList: Set<string> = new Set();
  private mViewManager: ViewManager;
  private mIsFinishedInitLayout: boolean = false;
  private gridListener: Object | undefined;
  private selectItemChangeListenerMap: Map<number, SelectItemChangeListener> = new Map();
  private selectChangeListeners: Map<string, SelectChangeListener> = new Map();
  private formVisibleListenerMap: Map<string, ArrayList<VisibleChangeListener>> = new Map();
  private desktopContext: ServiceExtensionContext = GlobalContext.getContext();
  private waitingForInstallAni: boolean = false;
  private createCardState: boolean = false;
  private mUninstallListeners: UninstallListener[] = [];
  private mIsLayoutOrDockFinish: boolean = false;
  private mIsDesktopFocused: boolean = false;
  private mIsNeedRearrange: boolean = true;
  private viewModelUtils: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(this);
  private pcPageDesktopViewModel: PageDesktopViewModelForPC = PageDesktopViewModelForPC.getInstance();
  private formInfoList: GridLayoutItemInfo[] = [];
  private lastSelectedItems: string[] = [];
  private mSubscriber: commonEventManager.CommonEventSubscriber | null = null;
  // paste files from FileManager process
  private pasteSelectItems: HashSet<string> = new HashSet<string>();
  private fileMapForInoByUri: Map<string, string> = new Map();
  private allDesktopItemInfo: GridLayoutItemInfo[] = [];
  private cutItems: string[] = [];
  private overMaxPageItems: Set<string> = new Set();
  private intelligentSignStatus: boolean = false;
  private focusChangeListener: Map<string, FocusChangeListener> = new Map();
  private mAutoAlignStatus: boolean = false;
  private mAutoAlignUpdateItem: GridLayoutItemInfo[] = [];
  private focusFlag: Boolean = true;
  private multipleDragSettings = MultipleDragSettings.getInstance();
  private mFocusViewModel: FocusViewModel = FocusViewModel.getInstance();
  private mFormEditViewManager: FormEditViewManager = FormEditViewManager.getInstance();
  private multiSelectMap: Map<string, image.PixelMap > = new Map();
  private uninstallAppItemInfoArr: AppItemInfo[] = [];
  private mGridLayoutItemList: GridLayoutItemInfo[] = [];
  private mdeleteItemList: GridLayoutItemInfo[] = [];
  private isChangingPage: boolean = false;
  private voteTimeId: number = 0;
  private currentStartApp: boolean = false;
  private mInstallingItem: GridLayoutItemInfo[] = [];
  private mUninstallingItem: GridLayoutItemInfo[] = [];
  private mIsNeedUpdateInstallingApp: boolean = false;
  private loadGridListStartTime: number = 0;
  private loadGridListCostTime: number = 0;
  private mIsFirstSinglePlaySwitch: boolean = true;
  private isRemoveFlag: boolean = false;
  private isSupportLayoutAndDockSameIcon: boolean = false;
  private gravityListener: GravityAnimationListener = {
    finishAllCallback: () => {
      log.showInfo(TAG, 'exectue autoAlign after gravityListener finishAllCallback');
      this.autoAlignAndSqueezedAnimation();
      gravityAnimationListenerManager.unregisterListener(this.gravityListener);
    }
  };
  private isMakingFolder: boolean = false;
  private newUpdateAppList: GridLayoutItemInfo[] = [];

  private posOccupyArray: boolean[][][] = [];
  public appGridLayoutItems: GridLayoutItemInfo[] = [];
  public folderGridLayoutItems: GridLayoutItemInfo[] = [];
  public fileGridLayoutItems: GridLayoutItemInfo[] = [];
  public cardGridLayoutItems: GridLayoutItemInfo[] = [];
  public exceedScreenItems: GridLayoutItemInfo[] = [];
  private regionFolderGridLayoutItems: GridLayoutItemInfo[] = [];
  private _unlockMin: number = 0;
  private _unlockMax: number = 0;
  private _unLockMaxDelayKey: string = '';
  private isOuterCloneStatus: boolean = false;
  private delayPropertyChangeCallbackFunc: Function | undefined;
  private keyBoardStatus: number = FeatureConstants.NO_KEYBOARD;
  private sortOrTrimPage: number = 0;
  private isExpandStatus: boolean = false;
  private uiContext?: UIContext;
  private isScreenLock: boolean = false;
  private multiDragStart: boolean = false;
  private voteTimeout: number = 10000;
  private initAbnormalTimerId: number | undefined = undefined;
  private initAbnormalTimeout: number = 5 * 1000;
  private subscribeInfo: CommonEventManager.CommonEventSubscriber | undefined;
  private highFrequencyStatistics: HighFrequencyCallStatistics;
  private mFolderMgr: FolderManager = FolderManager.getInstance();
  private mFolderDataListener: FolderDataListener = {
    description: TAG,
    refreshType: FolderDataRefreshType.DESKTOP,
    priority: FolderLifeCyclePriority.HIGH,
    createFolder: (folder: GridLayoutItemInfo): void => {
      log.showInfo(TAG, 'create new folder and delete item on desktop');
      let items: GridLayoutItemInfo[] | undefined = folder.layoutInfo?.flat();
      items?.forEach((element) => {
        this.mLauncherLayoutCacheManager.deleteAppItemByKeyName(element.keyName, 'addFolder', false);
      });
      this.lightPagingFiltering(true);
    },
    addToFolder: (folderId: string, addItems: GridLayoutItemInfo[]): void => {
      log.showInfo(TAG, 'add items %{public}d to folder %{public}s', addItems.length, folderId);
      let appListInfo: GridLayoutItemInfo[] = this.mSettingsModel.getAppListInfo();
      for (let i = 0; i < addItems.length; i++) {
        appListInfo = appListInfo.filter(item => item.keyName !== addItems[i].keyName);
        this.mLauncherLayoutCacheManager.deleteAppItemByKeyName(addItems[i].keyName, 'addToFolder', false);
      }
      this.mSettingsModel.setAppListInfo(appListInfo);
      this.lightPagingFiltering(true);
    },
    removeFolder: (folder: GridLayoutItemInfo) => {
      log.showInfo(TAG, 'remove folder %{public}d on page %{public}d', folder.folderId, folder.page);
      this.mPageDesktopModel.deleteBlankPageFromLayoutInfo(folder.page, false);
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_PAGEDESK_LIGHT_REFRESH, false);
    }
  };

  /**
   * 设置UIContext
   *
   * @param uiContext 页面UIContext
   */
  public setUIContext(uiContext: UIContext): void {
    if (uiContext) {
      this.uiContext = uiContext;
    }
  }

  public getKeyBoardStatus(): number {
    return this.pcPageDesktopViewModel.getKeyBoardStatus();
  }

  public set unLockMaxDelayKey(value: string) {
    this._unLockMaxDelayKey = value;
  }

  public get unLockMaxDelayKey(): string {
    return this._unLockMaxDelayKey;
  }

  public set unlockMin(value: number) {
    this._unlockMin = value;
  }

  public get unlockMin(): number {
    return this._unlockMin;
  }

  public set unlockMax(value: number) {
    this._unlockMax = value;
  }

  public get unlockMax(): number {
    return this._unlockMax;
  }

  /**
   * 设置桌面是否正在滑动
   *
   * @param isChangingPage 桌面是否正在滑动
   */
  public setIsChangingPage(isChangingPage: boolean): void {
    this.isChangingPage = isChangingPage;
  }

  /**
   * 获取桌面是否正在滑动
   *
   * @returns 桌面是否正在滑动
   */
  public getIsChangingPage(): boolean {
    return this.isChangingPage;
  }

  /**
   * 切换横竖屏缓存
   *
   * @param isPortrait 是否切到竖屏缓存
   */
  public changeCurrentLayoutCache(isPortrait: boolean): void {
    PadLaunchLayoutCacheManager.getInstance().changeCurrentLayoutCacheData(isPortrait, this.mPageIndex);
  }

  getCreateCardState(): boolean {
    log.showInfo(TAG, `getCreateCardState: ${this.createCardState}`);
    return this.createCardState;
  }

  hasEnoughArea(itemInfo: CardItemInfo): boolean {
    let pageCount: number = this.mLauncherLayoutCacheManager.selectPageCount();
    let maxPage: number = this.mLauncherLayoutCacheManager.selectMaxPageCount();
    log.showInfo(TAG, 'check is area enough');
    if (pageCount < maxPage) {
      log.showInfo(TAG, 'has area enough add form');
      return true;
    }
    let foldOpen: boolean = desktopUtil.isFoldExpandStatus();
    // 折叠屏展开态情况下，当前屏左屏开始搜索4页; 其他场景搜索2页
    let searchPageCount: number = foldOpen ? 4 : 2;
    let findStartPage: number = this.getPagesWhenAddCard()[0];
    if (this.getEnoughAreaPosition(findStartPage, itemInfo.area ?? [], searchPageCount)) {
      log.showInfo(TAG, 'has area enough add form');
      return true;
    }
    if (launcherStatusUtil.getShowOutLauncherStatus()) {
      promptAction.showToast({
        message: this.mResourceManager.getStringByName('add_icon_to_desktop_max'),
      });
    } else {
      promptAction.showToast({
        message: this.mResourceManager.getStringByName('add_icon_to_desktop_max'),
        showMode: 2
      });
    }
    this.desktopContext?.eventHub.emit('waitFormManagerResponse', FormManageResponse.CREATE_FORM_FAILED);
    log.showInfo(TAG, 'no enough area add form');
    return false;
  }

  public outerHasAppItemEnoughArea(itemInfo: GridLayoutItemInfo): boolean {
    let pageCount: number = this.mLauncherLayoutCacheManager.selectPageCount();
    let maxPage: number = this.mLauncherLayoutCacheManager.selectMaxPageCount();
    log.showInfo(TAG, 'check is area enough');
    if (pageCount < maxPage) {
      log.showInfo(TAG, 'has area enough add app item');
      return true;
    }
    // 扩展新形态小折叠产品场景，向后搜索两页
    let searchPageCount: number = 2;
    if (this.getEnoughAreaPosition(this.mPageIndex, itemInfo.area ?? [], searchPageCount)) {
      log.showInfo(TAG, 'has area enough add app item');
      return true;
    }
    return false;
  }

  public createCardWithAnimation(cardItemInfo: CardItemInfo, dragItemType: number, dropX: number, dropY: number,
    isAddFormApp?: boolean): Promise<number> {
    if (this.hasEnoughArea(cardItemInfo)) {
      GlobalContext.getContext()?.eventHub.emit(FormConstants.EVENTHUB_FORM_MANAGER_CREATE_FORM, cardItemInfo, [dropX, dropY], dragItemType);
    } else {
      // 桌面没有空位，删除已加到卡片框架侧的卡片
      if (cardItemInfo.cardId) {
        FormManager.getInstance().deleteCard(cardItemInfo.cardId);
      }
    }
    return this.createCardToDeskTop(cardItemInfo,
      () => {
        log.showInfo(TAG, 'do create card animation');
        GlobalContext.getContext()?.eventHub.emit(FormConstants.EVENTHUB_FORM_MANAGER_CREATE_FORM_RESULT, cardItemInfo, this.createCardState);
        this.reportAddCardToScreenByDragEvent(cardItemInfo, dragItemType,
          this.createCardState ? ResultType.SUCCESS : ResultType.FAILED, isAddFormApp);
      },
      (position: number[], page?: number, screenSelectType?: number) => {
        cardItemInfo.row = position[0];
        cardItemInfo.column = position[1];
        cardItemInfo.page = page;
        let formManagerShowFrom: number | undefined = FormCenterViewManager.getInstance().getOpenAddFormViewSource();
        if (isAddFormApp && page && screenSelectType && formManagerShowFrom) {
          let formStyleConfig = FormViewModel.getInstance().getFormStyleConfig();
          let dpSize: string = formStyleConfig.mFormWidth.get(cardItemInfo.cardDimension.toString()) + '*' +
          formStyleConfig.mFormHeight.get(cardItemInfo.cardDimension.toString());
          let event: ClickAddCardEvent = {
            packageName: cardItemInfo.bundleName,
            area: CardItemInfo.getCardSize(cardItemInfo.dimension, cardItemInfo.isFormDimension1x4),
            dpSize: dpSize,
            formId: cardItemInfo.id ?? '',
            moduleName: cardItemInfo.moduleName,
            formName: cardItemInfo.name ?? '',
            page: page,
            addType: FormHiSysEventUtil.getDragAddCardType(dragItemType, formManagerShowFrom),
            column: position[0],
            row: position[1],
            screenType: screenSelectType,
            formType: FormCommonUtil.getFormType(cardItemInfo.gameCardInfo),
          };
          FormHiSysEventReporter.reportAddCardToScreenByClick(event);
        }
      });
  }

  /**
   * 从缓存中获取App
   * @param bundleName
   * @param appIndex
   * @param typeId
   * @param isOuter
   * @returns
   */
  public findAppFromCache(bundleName: string, appIndex: number = CommonConstants.MAIN_APP_INDEX,
    typeId: number = CommonConstants.TYPE_APP): GridLayoutItemInfo | undefined {
    let findApps = this.mLauncherLayoutCacheManager.getAllSameBundleNameAppItem(bundleName);
    let app = findApps.find((item: GridLayoutItemInfo) => {
      return item.appIndex === appIndex && item.typeId === typeId;
    });
    return app;
  }

  public reportAddCardToScreenByDragEvent(dragItemInfo: CardItemInfo | undefined, dragItemType: number,
    resultType: number, isAddFormApp?: boolean) : void {
    if (!dragItemInfo || !dragItemInfo.area || CheckEmptyUtils.isEmptyArr(dragItemInfo.area) ||
    CheckEmptyUtils.isEmpty(dragItemInfo.cardDimension) || CheckEmptyUtils.isEmpty(dragItemInfo.page)) {
      return;
    }
    // 从堆叠卡片中拖拽子卡片到桌面有单独的点位
    if (dragItemType === CommonConstants.DRAG_FROM_FORM_STACK) {
      return;
    }
    let formManagerShowFrom: number | undefined = FormCenterViewManager.getInstance().getOpenAddFormViewSource();
    if (dragItemType === CommonConstants.DRAG_FROM_MANAGE && formManagerShowFrom === undefined) {
      log.showWarn(TAG, 'report drag to add card failed, formManagerShowFrom is undefined');
      return;
    }
    // 加桌完成将加桌页拉起方式恢复默认值
    FormCenterViewManager.getInstance().setOpenAddFormViewSource(CardAddType.OTHERS);
    let formStyleConfig = FormViewModel.getInstance(this.singleContext).getFormStyleConfig();
    let dpSize = formStyleConfig.mFormWidth.get(dragItemInfo.cardDimension.toString()) + '*' +
    formStyleConfig.mFormHeight.get(dragItemInfo.cardDimension.toString());
    let event: DragAddCardEvent = {
      packageName: dragItemInfo.bundleName,
      area: dragItemInfo.area,
      dpSize: dpSize,
      formId: dragItemInfo.id ?? '',
      moduleName: dragItemInfo.moduleName,
      formName: dragItemInfo.name ?? '',
      page: dragItemInfo.page ?? 0,
      addType: FormHiSysEventUtil.getDragAddCardType(dragItemType, formManagerShowFrom),
      resultType: resultType,
      column: dragItemInfo.column ?? 0,
      row: dragItemInfo.row ?? 0,
      sourceType: Extend1Data.getCardSourceType(dragItemInfo.extend1),
      formType: FormCommonUtil.getFormType(dragItemInfo?.gameCardInfo),
    };
    if (!isAddFormApp) {
      FormHiSysEventReporter.reportAddCardToScreenByDrag(event);
    }
  }

  async showFormManager(): Promise<void> {
    let createWindowWithName = GlobalContext.getInstance().getObject('createWindowWithName') as Function;
    createWindowWithName(windowManager.FORM_MANAGER_WINDOW_NAME, windowManager.FORM_MANAGER_RANK);
  }

  setSwiperController(swiperController: SwiperController): void {
    this.desktopSwiperController = swiperController;
  }

  getSwiperController(): SwiperController | undefined {
    return this.desktopSwiperController;
  }

  showNext(): void {
    log.showInfo(TAG, 'show next page');
    this.desktopSwiperController?.showNext();
    PageDesktopDragHandler.getInstance(this.singleContext).updateDragPageIndex(true);
  }

  showPrevious(): void {
    log.showInfo(TAG, 'show previous page');
    this.desktopSwiperController?.showPrevious();
    PageDesktopDragHandler.getInstance(this.singleContext).updateDragPageIndex(false);
  }

  public changeSwiperIndex(index: number): void {
    log.showInfo(TAG, 'changeIndex to %{public}d', index);
    this.desktopSwiperController?.changeIndex(index, true);
    PageDesktopDragHandler.getInstance(this.singleContext).setDragPageIndex(index);
  }

  private readonly mLocalEventListener: ReceiveEventInfo = {
    onReceiveEvent: (event: string, params: GridLayoutItemInfo | DeleteItemType | DeleteItemType[] | BadgeItemInfo |
    string | boolean | AppInstallEventData | CardItemInfo | DesktopFileInfo[] | string[] | DesktopSortInfo | number):
      void => {
      this.receiveEventLog(event);
      if (event === EventConstants.EVENT_REQUEST_PAGEDESK_ADD_TO_FOLDER) {
        this.lightPagingFiltering(true);
      } else {
        this.judgeEvent(event, params);
      }
    }
  };

  private receiveEventLog(event: string) {
    if (event === EventConstants.EVENT_REQUEST_APP_DOUBLE_CLICK) {
      return;
    }
    if (event === EventConstants.EVENT_BADGE_UPDATE) {
      iconLog.showWarn(TAG, `localEventListener receive event: ${event}`);
      return;
    }
    if (event === EventConstants.EVENT_REQUEST_FORM_ITEM_VISIBLE ||
      event === EventConstants.EVENT_REQUEST_FORM_RECYCLE) {
      formLog.showWarn(TAG, `localEventListener receive event: ${event}`);
      return;
    }
    log.showWarn(TAG, `localEventListener receive event: ${event}`);
  }

  private judgeEvent(event: string, params: GridLayoutItemInfo | DeleteItemType | DeleteItemType[] | BadgeItemInfo |
  string | boolean | AppInstallEventData | CardItemInfo | DesktopFileInfo[] | string[] | DesktopSortInfo | number |
  PageType | AppItemInfo[]): void {
    switch (event) {
      case EventConstants.EVENT_REQUEST_PAGEDESK_ITEM_ADD:
        this.addToDesktop(params as GridLayoutItemInfo);
        break;
      case EventConstants.EVENT_REQUEST_PAGEDESK_ITEM_DELETE:
        this.deleteAppItem(params as DeleteItemType);
        break;
      case EventConstants.EVENT_REQUEST_PAGEDESK_ITEM_DELETE_BATCH:
        this.deleteAppItemBatch(params as DeleteItemType[]);
        break;
      case EventConstants.EVENT_REQUEST_PAGEDESK_ITEM_REMOVE:
        this.removeAppItem(params as DeleteItemType);
        break;
      case EventConstants.EVENT_REQUEST_PAGEDESK_ITEM_REMOVE_BATCH:
        this.removeAppItemBatch(params as DeleteItemType[]);
        break;
      case EventConstants.EVENT_BADGE_UPDATE:
        this.updateBadgeNumber(params as BadgeItemInfo);
        break;
      case EventConstants.EVENT_REQUEST_PAGEDESK_ITEM_UPDATE:
        this.lightPagingFiltering();
        break;
      case EventConstants.EVENT_REQUEST_PAGEDESK_FORM_ITEM_ADD:
        this.createCardToDeskTop(params as CardItemInfo);
        break;
      case EventConstants.EVENT_REQUEST_PAGEDESK_FORM_ITEM_DELETE:
        this.deleteFormItem(params as string);
        break;
      case EventConstants.EVENT_REQUEST_PAGEDESK_FORM_ITEM_DELETE_BY_INTELLIGENT:
        this.deleteFormItemEvent4Intelligent(params as string);
        break;
      case EventConstants.EVENT_REQUEST_JUMP_TO_FORM_VIEW:
        this.showFormManager();
        break;
      case EventConstants.EVENT_SMARTDOCK_INIT_FINISHED:
        LauncherStartup.getInstance().passStep(StartupStep.DOCK_INIT);
        this.initGridList(SceneMsgEnum.SCENE_MSG_SMART_DOCK_INIT_FINISHED);
        break;
      case EventConstants.EVENT_LAYOUT_INIT_FINISHED:
        LauncherStartup.getInstance().passStep(StartupStep.GRID_INIT);
        this.initGridList(SceneMsgEnum.SCENE_MSG_LAYOUT_INIT_FINISHED);
        PageDesktopOneShotManager.getInstance().retryUpdateCardStyle();
        break;
      case EventConstants.EVENT_REQUEST_PAGEDESK_RELOAD_REFRESH:
        this.loadGridList();
        break;
      case EventConstants.EVENT_REQUEST_PAGEDESK_LIGHT_REFRESH:
        let isSkipDuplicateCheck = params as boolean;
        this.lightPagingFiltering(isSkipDuplicateCheck);
        break;
      case EventConstants.EVENT_REQUEST_OUTER_PAGEDESK_LIGHT_REFRESH:
        break;
      case EventConstants.EVENT_REQUEST_INNER_PAGEDESK_LIGHT_REFRESH:
        this.refreshScreen();
        break;
      case EventConstants.EVENT_REQUEST_FORM_ITEM_VISIBLE:
        log.showInfo(TAG, `handle EVENT_REQUEST_FORM_ITEM_VISIBLE, params: ${params}!`);
        this.freshCurPageVisibility(params as boolean, false, false); // 锁屏解锁后调用，通知当前卡片可见性
        break;
      case EventConstants.EVENT_REQUEST_DESKTOP_ITEM_UNSELECT:
        this.notifyUnSelect();
        break;
      case EventConstants.EVENT_PACKAGE_CHANGED:
        this.changeAppInstallTime(params as GridLayoutItemInfo);
        break;
      case EventConstants.EVENT_REQUEST_APPGALLERY_CREATED:
        if (!DeviceHelper.isPC()) {
          this.insertNewUpdateApp(params as GridLayoutItemInfo[]);
        }
        break;
      case EventConstants.EVENT_REQUEST_DESKTOP_FOCUS_CHANGE:
        this.updateDesktopFocusState(params as boolean);
        break;
      case EventConstants.EVENT_REQUEST_APPGALLERY_FINISH:
        this.insertNewUpdateAppForPc(params as GridLayoutItemInfo[]);
        break;
      case EventConstants.EVENT_REQUEST_PAGEDESK_FILE_REFRESH:
        this.refreshPageDesktopFiles(params as DesktopFileInfo[]);
        break;
      case EventConstants.EVENT_REQUEST_PAGEDESK_ITEM_SELECTED:
        this.refreshPasteSelectedStates(params as string[]);
        break;
      case EventConstants.EVENT_REQUEST_PAGEDESK_FILE_ITEM_ICON_REFRESH:
        this.refreshFileItemIcon();
        break;
      case EventConstants.EVENT_INTELLIGENT_SIGN_STATUS:
        this.setIntelligentSignStatus(params as boolean);
        break;
      case EventConstants.EVENT_REQUEST_DELETE_DEFAULT_CARD:
        this.deleteSceneBoardFormRelationInfo(params as string);
        break;
      case EventConstants.EVENT_REQUEST_FORM_RECYCLE:
        this.recycleFormEventHandler(params as boolean);
        break;
      case EventConstants.EVENT_REQUEST_SINGLE_DISPLAY_SWITCH_REFRESH:
        this.switchSingleDisplay();
        break;
      case EventConstants.EVENT_REQUEST_PAGEDESK_ITEM_SORT:
        this.sortDesktopItem(params as DesktopSortInfo);
        break;
      case EventConstants.EVENT_DESKTOP_CANT_ADD:
        this.toastCantAdd();
        break;
      case EventConstants.EVENT_DESKTOP_TRIM:
        this.desktopTrim(params as number);
        break;
      case EventConstants.EVENT_DELIVER_APP_ITEM_REMOVE:
        this.removeDeliverItem(params as GridLayoutItemInfo);
        break;
      case EventConstants.EVENT_DESKTOP_PASTE:
        this.doPasteEvent(params as GridLayoutItemInfo);
        break;
      case EventConstants.EVENT_RESET_ALL_SELECT_STATUS:
        this.initSelectStatus();
        break;
      case EventConstants.EVENT_CLEAR_SELECT_ITEMS:
        this.selectItemClear();
        break;
      case EventConstants.EVENT_ADD_APP_WHEN_EXCEED_MAX_PAGE:
        this.dealAddAppWhenMaxPageEvent(params as GridLayoutItemInfo[]);
        break;
      case EventConstants.APP_INSTALL_BMS_CHANGE_EVENT:
        this.appInstallBmsChangeEvent(params as AppInstallEventData);
        break;
      case EventConstants.EVENT_REQUEST_SHORTCUT_ITEM_DELETE:
        this.removeShortcutItem(params as AppItemInfo);
        break;
      case EventConstants.EVENT_REQUEST_APP_DOUBLE_CLICK:
        this.onAppDoubleClick(params as StartAppType);
        break;
      case EventConstants.EVENT_REQUEST_FALL_BOX_HIDE:
        this.sendFallBoxHideEvent(params as string);
        break;
      case EventConstants.EVENT_OPEN_APPLICATION:
        params = params as GridLayoutItemInfo;
        this.openApplication(params.abilityName, params.bundleName, params.moduleName, params.appIndex);
        break
      case EventConstants.EVENT_UNINSTALL_APPLICATION:
        params = params as GridLayoutItemInfo;
        this.uninstallApp(params.bundleName, params.isUninstallAble as boolean, params.appIndex);
        break;
      case EventConstants.EVENT_BATCH_UPDATE_ITEM_POSITION:
        this.batchUpdateAppItemLayoutInfo(params as GridLayoutItemInfo[]);
        break;
      case EventConstants.EVENT_SHOW_NEXT_PATE:
        this.showNext();
        break;
      case EventConstants.EVENT_ADD_MIDDLE_PAGE:
        this.addMiddlePageToAppGridInfo();
        break;
      case EventConstants.EVENT_DELETE_NOT_UNINSTALL_APP:
        params = params as DeleteItemType;
        this.deleteNotInstallApp(params.isRemove, params.bundleName, params.appIndex);
        break;
      case EventConstants.EVENT_DELETE_APP_AUTO_ALIGN:
        this.viewModelUtils.getAlignStatus().then((mAutoAlignStatus) => {
          if (mAutoAlignStatus) {
            this.deleteAppItemAutoAlign(params as GridLayoutItemInfo[]);
          }
        });
        break;
      case EventConstants.EVENT_ANNOUNCED_SWIPER_PAGE:
        params = params as PageType;
        DesktopAccessibilityUtils.textAnnouncedForCurrentPage(params.curPage as number, params.totalPage as number);
      case EventConstants.EVENT_AUTO_ALIGN_AFTER_UNINSTALL:
        this.autoAlignAfterUninstall(params as AppItemInfo[]);
        break;
      case EventConstants.EVENT_UPDATE_GIRD_ITEM_POOL_STATUS:
        GridItemsPool.getInstance().setIsRelease(params as boolean);
        break;
      default:
        log.showError(TAG, `localEventListener receive error event:${event}}`);
        break;
    }
  }

  private appInstallBmsChangeEvent(eventData: AppInstallEventData): void {
    this.regroupDataAppListChange([], eventData.eventName, eventData.bundleName, eventData.appIndex);
  }

  private dealAddAppWhenMaxPageEvent(addItems: GridLayoutItemInfo[]): void {
    log.showWarn(TAG, 'dealAddAppWhenMaxPageEvent');
    let layoutDescription: LayoutDescription = this.mLauncherLayoutCacheManager.selectLayoutDescription();
    let maxPage: number = layoutDescription.maxPage;
    let startFindPage: number = scbBlankPositionUtils.getStartFindPageByHomePage(maxPage);
    this.addAppWhenMaxPage(addItems, startFindPage);
  }

  private removeDeliverItem(itemInfo: GridLayoutItemInfo): void {
    if (CheckEmptyUtils.isEmpty(itemInfo)) {
      return;
    }
  }

  /**
   * switchSingleDisplay
   */
  private async switchSingleDisplay(): Promise<void> {
    log.showInfo(TAG, `switchSingleDisplay isFirstSinglePlaySwitch ${this.mIsFirstSinglePlaySwitch}`);
    let isCloneStatus: boolean =
      AppStorage.get('isCloneStatus') as boolean && !GlobalContext.getInstance().getObject('backupStatus');
    let appListInfo: AppListInfo | undefined = AppStorage.get('appListInfo');
    let outerAppListInfo: AppListInfo | undefined = AppStorage.get('outerAppListInfo');
    if (this.mIsFirstSinglePlaySwitch || isCloneStatus || !appListInfo ||
    CheckEmptyUtils.isEmptyArr(appListInfo.appGridInfo) ||
      !outerAppListInfo || CheckEmptyUtils.isEmptyArr(outerAppListInfo.appGridInfo)) {
      if (isCloneStatus && launcherStatusUtil.getShowOutLauncherStatus()) {
        this.isOuterCloneStatus = true;
      }
      this.loadGridList(SceneMsgEnum.SCENE_MSG_SWITCH_SINGLE_DISPLAY);
      AppStorage.setOrCreate('isCloneStatus', false);
      this.mIsFirstSinglePlaySwitch = false;
    } else {
      log.showInfo(TAG, 'switchSingleDisplay outerAppListInfo length = ' + outerAppListInfo.appGridInfo.length +
        'appListInfo length = ' + appListInfo.appGridInfo.length + ' isOuter = ' + launcherStatusUtil.getShowOutLauncherStatus());
      let allGridLayoutItems =
        this.mLauncherLayoutCacheManager.getAllGridLayoutItemList(BusinessType.BUSINESS_BASIC_DESKTOP);
      this.mBundleInfoList = allGridLayoutItems;
      AppStorage.SetOrCreate('selectDesktopAppItem', '');
      AppStorage.SetOrCreate('selectItem', '');
      SwiperLoadManager.getInstance(launcherStatusUtil.getShowOutLauncherStatus()).hardCodeRefreshPageDesktop();
      let currentPage: number = AppStorage.get<number>(desktopUtil.getPageIndex()) ?? 0;
      if (appListInfo.appGridInfo.length > currentPage) {
        log.showInfo(TAG, `switchSingleDisplay current Page length = ${outerAppListInfo.appGridInfo[currentPage]?.length}`);
      }
      this.mGridAppsInfos = launcherStatusUtil.getShowOutLauncherStatus() ? outerAppListInfo.appGridInfo :
        appListInfo.appGridInfo;
    }
  }

  setIntelligentSignStatus(value: boolean): void {
    log.showInfo(TAG, `setIntelligentSignStatus status: ${value}`);
    this.intelligentSignStatus = value;
  }

  getIntelligentSignStatus(): boolean {
    log.showInfo(TAG, `getIntelligentSignStatus status: ${this.intelligentSignStatus}`);
    return this.intelligentSignStatus;
  }

  private readonly mSettingsChangeObserver: SettingsModelObserver = (event: number) => {
    log.showInfo(TAG, 'mSettingsChangeObserver event is ' + event);

    this.mGridConfig = this.getGridConfig();
    this.pagingFiltering(undefined, undefined, SceneMsgEnum.SCENE_MSG_SETTINGS_CHANGE);
  };

  private readonly mKeyEventListener: KeyEventListener = {
    onReceiveKeyEvent: (event): void => {
      log.showInfo(TAG, 'key event come: ' + event);
      switch (event) {
        case KeyEventConstants.EVENT_ENTER:
          this.doEnterEvent();
          break;
        case KeyEventConstants.EVENT_DELETE:
          this.doDeleteEvent();
          break;
        case KeyEventConstants.EVENT_FORCE_DELETE:
          this.doDeleteEvent(true);
          break;
        case KeyEventConstants.EVENT_CTRL_C:
          this.doCopyEvent();
          break;
        case KeyEventConstants.EVENT_CTRL_X:
          this.doCopyEvent(true);
          break;
        case KeyEventConstants.EVENT_CTRL_V:
          this.doPasteEvent();
          break;
        case KeyEventConstants.EVENT_CTRL_A:
          this.doSelectAllEvent();
          break;
        case KeyEventConstants.EVENT_F2:
          this.doRenameEvent();
          break;
        case KeyEventConstants.EVENT_CTRL_D:
          this.doDeleteEvent();
          break;
        case KeyEventConstants.EVENT_CTRL_Z:
          this.doRevoke();
          break;
        case KeyEventConstants.EVENT_CTRL_Y:
          this.doReverseRevoke();
          break;
        case KeyEventConstants.EVENT_CTRL_SHIFT_N:
          this.doCtrlShiftNEvent();
          break;
        case KeyEventConstants.EVENT_DPAD_UP:
          this.doSelectFirstItem();
          break;
        case KeyEventConstants.EVENT_ALT_ENTER:
          this.openFileDetail();
          break;
        case KeyEventConstants.EVENT_SPACE:
          this.openFilePreview();
          break;
        default:
          break;
      }
    }
  };

  constructor(ctx?: SingleContext) {
    super(ctx);
    DesktopItemBuilderProxy.getInstance().setDesktopItemBuilder('AppItem', wrapBuilder(AppItemBuilder));
    DesktopItemBuilderProxy.getInstance().setDesktopItemBuilder('FileFolderItem', wrapBuilder(FileFolderItemBuilder));
    this.mMenuInfoManager = MenuInfoManager.getInstance();
    this.mPageDesktopModel = PageDesktopModel.getInstance(ctx);
    this.mFolderModel = FolderModel.getInstance();
    this.mFormStackModel = new FormStackModel();
    this.mFormModel = FormModel.getInstance();
    this.onPageDesktopCreate();
    this.mSettingsModel = SettingsModel.getInstance();
    this.mFormListInfoCacheManager = FormListInfoCacheManager.getInstance();
    if (DeviceHelper.isPad()) {
      this.mLauncherLayoutCacheManager = PadLaunchLayoutCacheManager.getInstance();
    } else {
      this.mLauncherLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
    }
    this.mShortcutViewModel = ShortcutViewModel.getInstance();
    LauncherStartup.getInstance().passStep(StartupStep.DESKTOP_VM);
    this.mSettingsModel.forceReloadConfig();
    this.mSettingsModel.addObserver(this.mSettingsChangeObserver);
    this.mGridConfig = this.getGridConfig();
    this.pageDesktopStyleConfig = layoutConfigManager.getStyleConfig(PageDesktopGridStyleConfig.APP_GRID_STYLE_CONFIG,
      CommonConstants.PAGE_DESKTOP_FEATURE_NAME);
    this.formDetailLayoutConfig = layoutConfigManager.getStyleConfig(FormDetailLayoutConfig.FORM_LAYOUT_INFO,
      FeatureConstants.FEATURE_NAME);
    this.mFolderMgr.registerDataLifeListener(this.mFolderDataListener);
    this.setPageIndex();
    this.mViewManager = ViewManager.getInstance();
    this.mFormHostService = FormHostService.getInstance();
    this.isBigScreen = DeviceHelper.isBigScreenMachine();
    // 开机注册时还不是deliver版本，事件未注册上，需要修改为phone和pad都注册
    if (DeviceHelper.isPhoneOrPad()) {
      this.viewModelUtils.initDeliverStatusChange();
      DisposedEventManager.getInstance().initEvent();
      this.registerDeliverAppStrategyChangeObserver();
    }
    ContractedFolderCommonViewModel.getInstance().registerBuildAppMenu((menu: MenuInfoType): MenuInfo[] => {
      return this.buildAppMenu(menu);
    });
    this.initSubscriber();
    this.getLauncherVoteTimeout();
    this.highFrequencyStatistics = new HighFrequencyCallStatistics(CALL_STATISTICS_SCENE_COUNT);
    LauncherDebug.getInstance();
  }

  private getLauncherVoteTimeout(): void {
    try {
      this.voteTimeout = Number(systemParameterEnhance.getSync('const.sceneboard.launcher.vote_timeout', '10000'));
    } catch (err) {
      log.showError(TAG, `getLauncherVoteTimeout Error ${err?.code} ${err?.message}`);
    }
  }

  /**
   * 监听应用出湖策略云推更新
   * @returns
   */
  private registerDeliverAppStrategyChangeObserver(): void {
    this.subscribeInfo = CommonEventManager.createSubscriberSync({
      events: [DUE_HAP_CFG_UPDATED]
    });
    CommonEventManager.subscribe(this.subscribeInfo, async (err: BusinessError, data: CommonEventManager.CommonEventData) => {
      if (err) {
        log.showError(TAG, `subscribe callback failed, ${err.code}, ${err.message}`);
        return;
      }
      log.showInfo(TAG, `broadcast type:${data?.parameters?.type} subtype:${data?.parameters?.subtype}`);
    });
  }

  private initSubscriber(): void {
    // 订阅企业应用安装状态改变事件
    let subscribeInfo: commonEventManager.CommonEventSubscribeInfo = {
      events: [EVENT_INSTALL_STATUS_CHANGE],
      publisherBundleName: BUNDLE_NAME_AG,
    };

    commonEventManager.createSubscriber(subscribeInfo).then(res => {
      this.mSubscriber = res;
      commonEventManager.subscribe(this.mSubscriber, this.eventCallback);
    }).catch((err: Error) => {
      log.showError(TAG, `commonEventManager createSubscriber error, message:${err?.message}`);
    });
  }

  private eventCallback = (err: BusinessError, eventData: commonEventManager.CommonEventData): void => {
    if (err) {
      log.showError(TAG, `eventCallback failed, code:${err.code}, message:${err.message}`);
      return;
    }
    // 企业应用授权成功后重建卡片
    if (!eventData || eventData.code !== ENTERPRISE_APP_AUTH_CHANGE_CODE || !eventData.parameters ||
      eventData.parameters.authStatus !== ENTERPRISE_APP_AUTH_SUCCESS_STATUS) {
      log.showError(TAG, `eventCallback failed, code:${eventData?.code}, authStatus:${eventData?.parameters?.authStatus}`);
      return;
    }

    let bundleName: string = eventData.parameters.bundleName;
    let currentDate: string = Date.now().toString();
    log.showInfo(TAG, `start to update forms of bundleName: ${bundleName}, currentDate:${currentDate}`);
    // 内屏
    this.updateFormRefreshDate(bundleName, currentDate);
    this.refreshScreen(SceneMsgEnum.SCENE_MSG_EVENT_AG_INSTALL_STATUS_CHANGE);
  };

  private updateFormRefreshDate(bundleName: string, currentDate: string, isOuter: boolean = false): void {
    FormLayoutCacheManager.getInstance().selectFormsAndFormStackByBundleName(bundleName, isOuter)?.forEach(item => {
      item.formRefreshDate = currentDate;
      log.showInfo(TAG, `update formRefreshDate keyName:${item.keyName}`);
    });
  }

  getRightMenuSelectedIcon(isSelected: boolean): string {
    return isSelected ? '/common/pics/ic_public_selected.svg' : '';
  }

  /**
   * Obtains the PageDesktopViewModel instance.
   *
   * @return PageDesktopViewModel
   */
  static getInstance(ctx?: SingleContext): PageDesktopViewModel {
    const instance: PageDesktopViewModel = singleManager.get<PageDesktopViewModel>(PageDesktopViewModel, ctx);
    PageDesktopViewModelProxy.setInstance(instance);
    return instance;
  }

  public setFileFolderBadge(event: DragEvent, extraParams?: string): void {
    this.fileFolderManager?.setFileFolderBadge(event, extraParams);
  }

  public dropFileToDesktop(event: DragEvent, extraParams?: string, extraData?: string): void {
    if (this.mLauncherLayoutCacheManager.isAddAppOverMaxPage(this.mSettingsModel.getGridConfig())
    ) {
      log.showInfo(TAG, 'show toast drop file folder to desktop max');
      this.showNoSpaceToast();
    }
    this.fileFolderManager?.dropFileToDesktop(event, extraParams, extraData);
  }

  public fileFolderEnterDesktop(event: DragEvent): void {
    this.fileFolderManager?.fileFolderEnterDesktop(event);
  }

  async getFileInos(event: DragEvent): Promise<string[]> {
    return await this.fileFolderManager?.getFileInos(event);
  }

  public getSelectItemInfos(): GridLayoutItemInfo[] {
    const items: GridLayoutItemInfo[] = this.mGridAppsInfos[this.mPageIndex];
    return items.filter((item: GridLayoutItemInfo) => {
      return this.lastSelectedItems.includes(this.getItemKeyByType(item));
    });
  }

  /**
   * Registering Listening Events.
   */
  private onPageDesktopCreate(): void {
    log.showInfo(TAG, 'onPageDesktopCreate');
    // 手机设备不再通过这个方式监听BMS事件
    if (!AppGalleryDownloadManager.getInstance().isEnableNextDownload()) {
      this.mAppModel.registerAppListEvent();
    }
    this.mPageDesktopModel.registerPageDesktopItemAddEvent(this.mLocalEventListener);
    this.mPageDesktopModel.registerPageDesktopBadgeUpdateEvent(this.mLocalEventListener);
    this.registerKeyEvent(this.mKeyEventListener);
    this.mFormModel.registerJumpToFormViewEvent(this.mLocalEventListener);
    let wallpaperResolver = WallpaperColorManager.getInstance();
    let scbVisualEffectData: SCBVisualEffectData = new SCBVisualEffectData();
    scbVisualEffectData.isDockSolidColor =
      SCBVisualEffectMgr.isFeatureParamTrue(VisualEffectConstants.DOCK_BLUR_DISABLE);
    wallpaperResolver.setSCBVisualEffectData(scbVisualEffectData);
    wallpaperResolver.loadWallpaper();
    wallpaperResolver.registerWallpaperChange();
  }

  /**
   * init desktop layout
   */
  async initGridList(sceneMsg: string = SceneMsgEnum.SCENE_MSG_DEFAULT_INIT_GRID_LIST): Promise<void> {
    log.showInfo(TAG, `initGridList:${this.mIsLayoutOrDockFinish} when ${sceneMsg}`);
    if (this.mIsLayoutOrDockFinish) {
      if (this.initAbnormalTimerId) {
        clearTimeout(this.initAbnormalTimerId);
        this.initAbnormalTimerId = undefined;
      }
      LauncherStartup.getInstance().passStep(StartupStep.LOAD_GRID);
      this.loadGridList(sceneMsg);
      // 重启且桌面布局加载完成后，全量更新应用的分类信息
      if (AppCategoryInfoManager.getInstance().getAppCatEnable()) {
        let bundleNames: string [] = [];
        bundleNames = AppCategoryUtils.getAllAppBundleNames();
        AppCategoryInfoManager.getInstance().initAllAppCatInfo(bundleNames);
      }
    } else {
      // 延时5s发异常打点
      this.initAbnormalTimerId = setTimeout(() => {
        HiDfxEventUtil.reportLauncherLayoutAbnormal(SceneMsgEnum.SCENE_MSG_LAYOUT_INIT_ABNORMAL,
          `${sceneMsg} has been finished, check other scene`);
      }, this.initAbnormalTimeout);
      this.mIsLayoutOrDockFinish = true;
    }
  }

  /**
   * 加载网格列表数据，包含BMS应用列表校验
   */
  public async loadGridList(sceneMsg: string = SceneMsgEnum.SCENE_MSG_DEFAULT_REFRESH): Promise<void> {
    log.showInfo(TAG, `loadGridList is executed when ${sceneMsg}`);
    this.highFrequencyStatistics.record('loadGridList');
    Trace.start(Trace.CORE_METHOD_LOAD_GRID_LIST + sceneMsg);
    AppStorage.setOrCreate('isGridListFinished', false);
    this.loadGridListStartTime = new Date().getTime();
    if (!this.mIsFinishedInitLayout) {
      this.mAppModel.getAppList(() => {
        this.loadGridListCallback(sceneMsg);
      });
    } else {
      await this.loadGridListCallback(sceneMsg);
    }
  }

  private updatePadRotateCache(appInfo: AppItemInfo): void {
    if (!this.mLauncherLayoutCacheManager.isPad()) {
      return;
    }
    let rotateList = this.mLauncherLayoutCacheManager.getRotateGridLayoutList();
    let findApp = this.mLauncherLayoutCacheManager.findAppInCache(rotateList, appInfo);
    if (findApp) {
      this.updateAppPackageInfo(findApp, appInfo);
    } else {
      log.showWarn(TAG, 'updatePadRotateCache nothing!');
    }
  }

  public updateBMSChangedApp(bundleName: string, appIndex?: number): void {
    log.showInfo(TAG, 'updateBMSChangedApp bundle=%{public}s appIndex=%{public}d', bundleName, appIndex);
    let appInfo: AppItemInfo | undefined = AppModel.getInstance().getAppInfoByBundleInfo({
      bundleName: bundleName,
      appIndex: appIndex ?? 0
    });
    if (appInfo) {
      appInfo.typeId = CommonConstants.TYPE_APP;
      appInfo.area = [1, 1];

      // 桌面上查找是否存在
      let isFind = false;
      let gridLayoutItemInfoList = this.mLauncherLayoutCacheManager.getAllGridLayoutItemList(
        BusinessType.BUSINESS_BASIC_DESKTOP, false);
      for (let i = 0; i < gridLayoutItemInfoList.length; i++) {
        isFind = this.updateDesktopLayoutItem(gridLayoutItemInfoList[i], appInfo);
        if (isFind) {
          this.updatePadRotateCache(appInfo);
          break;
        }
      }
      // Dock上寻找是否存在
      if (!isFind) {
        isFind = this.updateDockLayoutItem(appInfo);
      }

      // 随卡定制应用加到精品应用文件夹中
      if (!isFind && MatchCardDataManager.isMatchCardApp(appInfo, 'updateBMSChangedApp')) {
        MatchCardLayoutManager.getInstance().doAddToFolderAction(appInfo);
        return;
      }

      // 桌面和dock不存在,则找空位插入(pc不直接加桌)
      if (!isFind && !DeviceHelper.isPC()) {
        this.updateAppItemLayoutInfo(appInfo, false);
      }
      // 刷新桌面
      this.lightPagingFiltering(true, SceneMsgEnum.SCENE_MSG_UPDATE_BMS_CHANGED_APP);
      if (launcherStatusUtil.getShowOutLauncherStatus()) {
        // 外屏场景刷新内屏
        this.refreshScreen(SceneMsgEnum.SCENE_MSG_UPDATE_BMS_CHANGED_APP);
      }
    }
  }

  private updateDesktopLayoutItem(gridItem: GridLayoutItemInfo, appInfo: AppItemInfo): boolean {
    if (gridItem.typeId === CommonConstants.TYPE_APP) {
      if (gridItem.bundleName === appInfo.bundleName && gridItem.appIndex === appInfo.appIndex) {
        this.updateAppPackageInfo(gridItem, appInfo);
        this.mLauncherLayoutCacheManager.updateLayoutInfoByAppInfo(gridItem, gridItem,
          BusinessType.BUSINESS_BASIC_DESKTOP, true);
        return true;
      }
    } else if (gridItem.typeId === CommonConstants.TYPE_FOLDER) {
      let gridLayoutInfo: GridLayoutItemInfo | undefined = gridItem.layoutInfo?.flat().find(
        item => item.bundleName === appInfo.bundleName && item.appIndex === appInfo.appIndex &&
          item.typeId === CommonConstants.TYPE_APP
      );
      if (gridLayoutInfo) {
        LauncherLayoutCacheUtil.updateFolderAppPackageInfo(gridLayoutInfo, appInfo);
        this.updateFolderItem(gridItem, appInfo);
        return true;
      }
    }
    return false;
  }

  private updateFolderItem(folderInfo: GridLayoutItemInfo, updateInfo: AppItemInfo): void {
    if (this.mFolderMgr.isFolderOpen() && this.mFolderMgr.getOpenFolderId() === folderInfo.folderId) {
      this.mFolderMgr.updateOpenFolderLayout('BMS change opened folder item', folderInfo.layoutInfo?.flat() ?? [], true);
    } else {
      // 安装或更新时，移除新的应用后在节点管理的回调删除旧节点
      const items: GridLayoutItemInfo[] = (folderInfo.layoutInfo?.flat() ?? []).filter(
        item => item.bundleName !== updateInfo.bundleName);
      this.mFolderMgr.updateFolderItems('BMS change folder item', folderInfo, items);
    }
  }

  private updateDockLayoutItem(appInfo: AppItemInfo): boolean {
    let residentList: DockItemInfo[] = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
    let appInDockIndex: number = residentList.findIndex(
      dockItem => dockItem.bundleName === appInfo.bundleName && dockItem.appIndex === appInfo.appIndex &&
        dockItem.typeId === CommonConstants.TYPE_APP
    );
    if (appInDockIndex !== -1) {
      return true;
    }

    let isFindInDock = false;
    residentList.forEach((dockItem, index) => {
      if (dockItem.typeId === CommonConstants.TYPE_FOLDER) {
        let inFolderIndex: number = dockItem.layoutInfo?.flat().findIndex(
          itemInFolder => itemInFolder.bundleName === appInfo.bundleName && itemInFolder.appIndex === appInfo.appIndex &&
            itemInFolder.typeId === CommonConstants.TYPE_APP
        ) ?? -1;
        if (inFolderIndex !== -1) {
          isFindInDock = true;
        }
      }
    });
    return isFindInDock;
  }

  /**
   * 桌面元素删除后，补位操作
   */
  afterDeleteDesktopItem(isOuter?: boolean): void {
    if (launcherStatusUtil.getShowOutLauncherStatus()) {
      this.refreshScreen(SceneMsgEnum.SCENE_MSG_DELETE_DESKTOP_ITEM);
    } else {
      this.lightPagingFiltering(false, SceneMsgEnum.SCENE_MSG_DELETE_DESKTOP_ITEM);
    }
    if (DeviceHelper.isPC()) {
      this.pasteSelectItems.clear();
      this.fileFolderManager?.refreshDesktopFiles();
    }
  }

  private async loadGridListCallback(sceneMsg: string = SceneMsgEnum.SCENE_MSG_DEFAULT_REFRESH): Promise<void> {
    // 关键流程中确保外屏标识一致
    let isOuter: boolean = launcherStatusUtil.getShowOutLauncherStatus();
    const installedAppInfoList = this.mAppModel.getAppList();
    const appInfoList = this.getAppList(installedAppInfoList, isOuter);
    // 角标不克隆，克隆场景优化峰值内存
    if (sceneMsg !== SceneMsgEnum.SCENE_MSG_CLONE_REFRESH_DESKTOP) {
      //先初始化所有角标信息,避免getBadgeDisplayNumberByBundleSync中大量taskpool创建
      BadgeManager.getInstance().getAllBadge().then(() => {
        for (let item of appInfoList) {
          BadgeManager.getInstance().getBadgeDisplayNumberByBundleSync(item).then(badgeNumber => {
            item.badgeNumber = badgeNumber;
            log.showDebug(TAG, `badgeNumber is ${item.badgeNumber} ${item.bundleName} ${item.appIndex}`);
          });
        }
      });
    }
    const bundleInfoListTemp = [];
    this.appendAppData(appInfoList, bundleInfoListTemp);
    const folderInfoList = this.mFolderModel.getFolderList(installedAppInfoList, isOuter);
    FolderDataModelManager.getInstance().initFolderData(folderInfoList);
    this.viewModelUtils.getFolderAppBadgeNumber(folderInfoList);
    this.viewModelUtils.appendFolderData(folderInfoList, bundleInfoListTemp);
    this.formInfoList = this.mFormModel.getAllFormsInfoFromLayout(isOuter);
    await this.appendFormData(this.formInfoList, bundleInfoListTemp);
    let formStackInfoList: GridLayoutItemInfo[] = this.mFormStackModel.getFormStackList(isOuter);
    this.viewModelUtils.appendFormStackData(formStackInfoList, bundleInfoListTemp);
    let shortcutInfoList: GridLayoutItemInfo[] = this.mLauncherLayoutCacheManager
      .selectGridLayoutItemsByType(CommonConstants.TYPE_SHORTCUT_ICON, isOuter);
    this.appendShortcutData(shortcutInfoList, bundleInfoListTemp);
    this.mBundleInfoList = bundleInfoListTemp;
    log.showWarn(TAG, 'loadGridList length of bundle:%{public}d, form:%{public}d, stack:%{public}d, shortcut:%{public}d folder:%{public}d',
      this.mBundleInfoList.length, this.formInfoList.length, formStackInfoList.length, shortcutInfoList.length, folderInfoList.length);
    this.mSettingsModel.setAppListInfo(this.mBundleInfoList, isOuter);
    Trace.end(Trace.CORE_METHOD_LOAD_GRID_LIST + sceneMsg);
    this.pagingFiltering(bundleInfoListTemp, undefined, undefined, isOuter);
    LauncherStartup.getInstance().passStep(StartupStep.PAGING_FILTERING);
    AppStorage.setOrCreate('isGridListFinished', true);
    if (this.delayPropertyChangeCallbackFunc) {
      this.delayPropertyChangeCallbackFunc();
      this.delayPropertyChangeCallbackFunc = undefined;
    }
    this.loadGridListCostTime = new Date().getTime() - this.loadGridListStartTime;
    log.showWarn(TAG, 'loadGridList costTime:%{public}d', this.loadGridListCostTime);
  }

  public registerDelayPropertyChangeCallback(callback: Function): void {
    this.delayPropertyChangeCallbackFunc = callback;
  }

  async updateForms(): Promise<void> {
    log.showInfo(TAG, 'updateForms start');
    let allFormsInfo: CardItemInfo[] = await this.mFormModel.getAllFormsInfoFromRdb();
    if (allFormsInfo.length) {
      for (const cardInfo of allFormsInfo) {
        if (!cardInfo || CheckEmptyUtils.checkStrIsEmpty(cardInfo.cardId)) {
          continue;
        }
        log.showInfo(TAG, `updateForms cardId: ${cardInfo.cardId}`);
        this.requestForm(cardInfo.cardId);
      }
    }
  }

  async updateDesktopInfo(sceneMsg?: string): Promise<void> {
    this.mIsFinishedInitLayout = false;
    this.loadGridList(sceneMsg);
    AppStorage.setOrCreate('formRefresh', String(new Date()));
  }

  private getAppList(totalAppInfoList: AppItemInfo[], isOuter: boolean): AppItemInfo[] {
    log.showWarn(TAG, 'getAppList start');
    // get pageDesktop app from config
    let pageDesktopInfoList: GridLayoutItemInfo[] = isOuter ?
      this.mSettingsModel.getAppListInfo(isOuter) :
      this.mLauncherLayoutCacheManager.selectAppAndShortcutByContainer(CommonConstants.CONTAINER_DESKTOP, isOuter);
    // get from config empty then init pageDesktop app
    if (!this.mSettingsModel.isAppListInfoExist() && CheckEmptyUtils.isEmptyArr(pageDesktopInfoList)) {
      if (!this.isPad) {
        // 类扩展新形态小折叠产品外屏布局初始化pageDesktopInfo，只涉及json文件app，外屏非全量显示
        if (isOuter) {
          let outerLayoutConfig =
            layoutConfigManager.getFunctionConfig<PageDesktopLayoutConfig>(PageDesktopLayoutConfig.GRID_LAYOUT_INFO);
          let outerLayoutInfoList: GridLayoutItemInfo[] = outerLayoutConfig.getGridLayoutInfo().layoutInfo;
          this.viewModelUtils.initOuterInstalledInfo(totalAppInfoList, pageDesktopInfoList, outerLayoutInfoList);
        } else {
          totalAppInfoList.forEach(item => pageDesktopInfoList.push(item as GridLayoutItemInfo));
        }
      }
    } else {
      // remove uninstalled app
      pageDesktopInfoList = this.filterAppNotInstalled(pageDesktopInfoList, totalAppInfoList, isOuter);
    }
    // product phone logic
    if (!this.isPad) {
      // 类扩展新形态小折叠产品外屏布局初始化pageDesktopInfo，不涉及新增应用添加，不涉及dock区应用移除
      if (isOuter) {
        let outerLayoutConfig =
          layoutConfigManager.getFunctionConfig<PageDesktopLayoutConfig>(PageDesktopLayoutConfig.GRID_LAYOUT_INFO);
        let outerLayoutInfoList: GridLayoutItemInfo[] = outerLayoutConfig.getGridLayoutInfo().layoutInfo;
        if (AppStorage.get('isCloneStatus') || this.isOuterCloneStatus) {
          log.showInfo(TAG, 'is outer clone  clear pageDesktopInfo cache.');
          this.isOuterCloneStatus = false;
          this.viewModelUtils.addOutNewInstalledInfo(outerLayoutInfoList, pageDesktopInfoList);
        } else {
          this.viewModelUtils.initOuterInstalledInfo(totalAppInfoList, pageDesktopInfoList, outerLayoutInfoList);
        }
      } else {
        this.removeBottomBarInfo(pageDesktopInfoList, isOuter);
      }
    }
    this.viewModelUtils.updateAppInFolderByInstalledApps();
    this.updateCardTypeId(pageDesktopInfoList);
    // update pageDesktop app config
    this.mSettingsModel.setAppListInfo(pageDesktopInfoList, isOuter);
    this.mLauncherLayoutCacheManager.updateAppCacheInfoByAppList(pageDesktopInfoList,
      BusinessType.BUSINESS_BASIC_DESKTOP, isOuter);
    log.showWarn(TAG, 'getAppList:' + pageDesktopInfoList.length);
    TraceUtil.endTrace(DomainName.SCB, TraceUtil.CORE_METHOD_LAUNCH_HOME_COLD);
    log.showWarn(TAG, 'LaunchHomeCold end');
    AppStorage.setOrCreate('isDesktopLoadFinished', true);
    RdbStoreManager.getInstance().setStartupStatus(false);

    try {
      AccountMgr.getCurrentAccountId().then((userId) => {
        let launcherTime = AppStorage.get<number>('launcherTime') as number;
        HiSysEventUtil.reportReloadDesktop(Date.now() - launcherTime, userId);
      });
    } catch (err) {
      log.showError(TAG, 'setUseCameraAppInfo catch error');
    }
    return pageDesktopInfoList as AppItemInfo[];
  }

  /**
   * 对时钟组件 type_id 被篡改的特定场景进行恢复
   *
   * @param pageDesktopInfoList
   */
  private updateCardTypeId(pageDesktopInfoList: GridLayoutItemInfo[]): void {
    log.showInfo(TAG, `pageDesktopInfoList length: ${pageDesktopInfoList.length}`);
    pageDesktopInfoList.forEach(item => {
      if (item.cardName === PreviewConstants.CLOCK_WEATHER_CARD_NAME && item.typeId === CommonConstants.TYPE_APP &&
        item.abilityName === 'FormAbility') {
        log.showError(TAG, `pageDesktopInfoList item: ${item.cardName} ${item.typeId} ${item.abilityName}`);
        item.typeId = CommonConstants.TYPE_CARD;
      }
    });
  }

  private filterAppNotInstalled(pageDesktopInfo: GridLayoutItemInfo[], totalAppInfoList: AppItemInfo[],
    isOuter: boolean): GridLayoutItemInfo[] {
    return pageDesktopInfo.filter(item => {
      if (item.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
        log.showInfo(TAG, `filterAppNotInstalled item: ${item.typeId} ${item.keyName}${item.bundleName}`);
        return false;
      }
      let isMultiIcon = this.mAppModel.checkIsMultiIcon(item.bundleName, item.appIndex);
      for (const appInfo of totalAppInfoList) {
        if (item.keyName === appInfo.keyName) {
          item.appName = appInfo.appName;
          item.applicationName = appInfo.applicationName;
          item.applicationLabelId = appInfo.applicationLabelId;
          item.appIconId = appInfo.appIconId;
          item.appLabelId = appInfo.appLabelId;
          item.isUninstallAble = appInfo?.isUninstallAble;
          item.isSystemApp = appInfo?.isSystemApp;
          item.installTime = appInfo.installTime;
          item.appStatus = AppStatus.INSTALLED;
          if (appInfo?.enableNewAppInstance) {
            item.enableNewAppInstance = true;
          }
          return true;
        }
        // 更新非多图标应用包名变化的场景
        if (item.typeId === CommonConstants.TYPE_APP && item.bundleName === appInfo.bundleName &&
          item.appIndex === appInfo.appIndex && !isMultiIcon) {
          this.updateAppPackageInfo(item, appInfo);
          let itemInLayoutList: GridLayoutItemInfo[] = this.mLauncherLayoutCacheManager
            .selectGridLayoutItemsByBundleNameAndAppIndex(item.bundleName, item.appIndex, isOuter);
          if (itemInLayoutList && itemInLayoutList.length === 1) {
            this.mLauncherLayoutCacheManager.updateLayoutInfoByAppInfo(itemInLayoutList[0], item,
              BusinessType.BUSINESS_BASIC_DESKTOP, true);
          }
          return true;
        }
      }
      if (item.typeId === CommonConstants.TYPE_APP) {
        log.showInfo(TAG, `filterAppNotInstalled isMultiIcon:${isMultiIcon} item: ${item.keyName}`);
        if (PreInstallUtils.checkIsNeedInstallApp(item)) {
          return true;
        }
      }
      return false;
    });
  }

  private updateAppPackageInfo(originItem: GridLayoutItemInfo, itemUpdate: AppItemInfo): void {
    log.showInfo(TAG, `update pageDesktopInfo ${originItem.keyName} ${itemUpdate.keyName}`);
    originItem.appName = itemUpdate.appName;
    originItem.applicationName = itemUpdate.applicationName;
    originItem.applicationLabelId = itemUpdate.applicationLabelId;
    originItem.appIconId = itemUpdate.appIconId;
    originItem.appLabelId = itemUpdate.appLabelId;
    originItem.isUninstallAble = itemUpdate?.isUninstallAble;
    originItem.isSystemApp = itemUpdate?.isSystemApp;
    originItem.installTime = itemUpdate.installTime;
    originItem.moduleName = itemUpdate.moduleName;
    originItem.abilityName = itemUpdate.abilityName;
    originItem.keyName = itemUpdate.keyName;
    originItem.appIndex = itemUpdate.appIndex;
  }

  /**
   * delete app in pageDesktop
   *
   * @param abilityName
   * @param bundleName
   */
  deleteAppItem(appItem: DeleteItemType): void {
    this.deleteAppItemOne(appItem);
    this.afterDeleteDesktopItem();
  }

  /**
   * 移除桌面图标(抽屉模式特性新增移除接口)
   *
   * @param appItem
   */
  removeAppItem(appItem: DeleteItemType): void {
    let isAutoAlign: boolean = true;
    let isNeedUpdateDrawerModeStatus: boolean = true;
    this.removeAppItemOne(appItem, isAutoAlign, isNeedUpdateDrawerModeStatus);
    this.lightPagingFiltering();
  }

  /**
   * 批量移除桌面图标(抽屉模式特性新增移除接口)
   *
   * @param items
   */
  public removeAppItemBatch(items: DeleteItemType[]): void {
    if (ArrayUtils.isEmpty(items)) {
      log.showWarn(TAG, 'removeAppItemBatch items is empty');
      return;
    }
    log.showInfo(TAG, `removeAppItemBatch items length: ${items.length}`);
    for (let i = 0; i < items.length; i++) {
      this.removeAppItemOne(items[i], true);
    }
    this.lightPagingFiltering();
  }

  /**
   * 删除元素后自动对齐
   *
   * @param deleteItemList
   * @param appItem
   */
  public deleteAppItemAutoAlign(deleteItemList: GridLayoutItemInfo[]): void {
    if (ArrayUtils.isEmpty(deleteItemList)) {
      log.showInfo(TAG, 'autoAlign deleteItemList of deleteAppItemAutoAlign is error');
      return;
    }
    log.showInfo(TAG, `deleteAppItemAutoAlign deleteItemList length:${deleteItemList.length}`);
    let flagName: string = deleteItemList[0].bundleName + deleteItemList[0].typeId + deleteItemList[0].appIndex;
    let alreadyAutoAlign = AutoAlignDataManager.getInstance().hasItem(flagName);
    if (!alreadyAutoAlign) {
      let deleteAppItemInfo: AppItemInfo[] = [];
      deleteItemList.forEach(item => {
        deleteAppItemInfo.push(item as AppItemInfo);
      })
      this.uninstallAppItemInfoArr = deleteAppItemInfo;
      log.showInfo(TAG, 'deleteAppItemAutoAlign execute autoAlign item bundleName: %{public}s, appName: %{public}s',
        deleteItemList[0]?.bundleName, deleteItemList[0]?.appName);
      this.autoAlignAndSqueezedAnimation();
    } else {
      log.showInfo(TAG, 'deleteAppItemAutoAlign not execute autoAlign item bundleName: %{public}s, appName: %{public}s',
        deleteItemList[0]?.bundleName, deleteItemList[0]?.appName);
      AutoAlignDataManager.getInstance().removeAutoAlginItem(flagName);
    }
  }

  /**
   * 删除单个桌面元素
   *
   * @param appItem 删除元素
   */
  private deleteAppItemOne(appItem: DeleteItemType, needAutoAlign: boolean = true): void {
    this.mBundleInfoList = this.mSettingsModel.getAppListInfo(false);
    log.showWarn(TAG, `deleteAppItem bundle:${appItem.bundleName}, typeId:${appItem.typeId},` +
      `appIndex:${appItem.appIndex}, shortcutId:${appItem.shortcutId} needAutoAlign:${needAutoAlign}`);
    let originalBundleListLength = this.mBundleInfoList.length;
    this.deleteItemInBundleList(appItem);
    let newBundleListLength = this.mBundleInfoList.length;
    this.mSettingsModel.setAppListInfo(this.mBundleInfoList, false);

    let deleteItemList: GridLayoutItemInfo[] = this.mLauncherLayoutCacheManager
      .selectSameAppAndFolder(appItem.keyName, appItem.bundleName, appItem.folderId, appItem.appIndex,
        appItem.shortcutId, false);
    this.mLauncherLayoutCacheManager.deleteSameAppAndFolder(appItem, BusinessType.BUSINESS_BASIC_DESKTOP, true, false);
    this.dealAppStatusAfterDelete(deleteItemList, appItem);
    if (needAutoAlign && !appItem.deleteByDockDrop) {
      this.deleteAppItemAutoAlign(deleteItemList);
    }
    const uiType:ESObject = SCBWindowSceneConfig.getInstance().windowSceneConfig?.uiType;
    if (uiType !== SCBConstants.UITYPE_PC || (uiType === SCBConstants.UITYPE_PC && appItem?.isUninstalled)) {
      // 卸载应用，同步移除快捷方式
      deleteItemList = this.mLauncherLayoutCacheManager.selectSameApp(appItem.bundleName, appItem.appIndex);
      // 删除前保存快捷方式用于自动对齐统计空位
      this.mdeleteItemList = deleteItemList;
      deleteItemList.forEach((item: GridLayoutItemInfo) => {
        if (item.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
          this.removeShortcutItem(item as AppItemInfo, false);
        }
      });
    }
    this.dealWithAppLocked(appItem);
  }

  /**
   * 移除单个桌面元素
   *
   * @param appItem 移除元素
   */
  private removeAppItemOne(appItem: DeleteItemType, needAutoAlign: boolean = true, needUpdateDrawerModeStatus: boolean = true): void {
    this.mBundleInfoList = this.mSettingsModel.getAppListInfo(false);
    log.showWarn(TAG, `removeAppItemOne bundle:${appItem.bundleName}, typeId:${appItem.typeId},` +
      `appIndex:${appItem.appIndex}, shortcutId:${appItem.shortcutId}, keyname=${appItem.keyName}, autoAlign:${needAutoAlign}`);
    let originalBundleListLength = this.mBundleInfoList.length;
    this.deleteItemInBundleList(appItem);
    let newBundleListLength = this.mBundleInfoList.length;
    // 处理文件夹中的应用移除
    if (originalBundleListLength === newBundleListLength) {
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_FOLDER_ITEM_REMOVE, appItem);
      return;
    }
    this.mSettingsModel.setAppListInfo(this.mBundleInfoList, false);

    let removeItemList: GridLayoutItemInfo[] = this.mLauncherLayoutCacheManager
      .selectGridLayoutItemsByBundleName(appItem.bundleName);
    removeItemList = removeItemList.filter((item) => {
      if (item.keyName === appItem.keyName) {
        return true;
      }
      return false;
    });
    log.showWarn(TAG, `removeAppItemOne removeItemList size:${removeItemList.length}`);
    if (removeItemList.length === 0) {
      log.showError(TAG, `removeAppItemOne not found bundle:${appItem.bundleName}, typeId:${appItem.typeId}`);
      return;
    }
    this.mLauncherLayoutCacheManager.deleteGridLayoutItemById(removeItemList[0], BusinessType.BUSINESS_BASIC_DESKTOP, true);
    if (needAutoAlign) {
      this.deleteAppItemAutoAlign(removeItemList);
    }
  }

  private deleteItemInBundleList(appItem: DeleteItemType): void {
    if (appItem.keyName) {
      this.mBundleInfoList = this.mBundleInfoList.filter(item => item.keyName !== appItem.keyName);
    } else if (appItem.bundleName) {
      this.mBundleInfoList = this.mBundleInfoList.filter(item => {
        if (item.bundleName !== appItem.bundleName) {
          return true;
        }
        if (appItem.appIndex && appItem.appIndex !== item.appIndex) {
          return true;
        }
        return false;
      });
    } else if (appItem.folderId) {
      this.mBundleInfoList = this.mBundleInfoList.filter(item => item.folderId !== appItem.folderId);
    }
  }

  private dealWithAppLocked(appItem: DeleteItemType): void {
    if (AppLockManager.getInstance().getUninstallLockedAppBundleName() !== appItem.bundleName) {
      return;
    }
    log.showInfo(TAG, `dealWithAppLocked bundleName: ${appItem.bundleName}`);
    this.mUninstallListeners.forEach(listener => listener?.uninstallAppResult(appItem.bundleName ?? '',
      CommonConstants.UNINSTALL_SUCCESS, appItem.appIndex, appItem.shortcutId));
    AppLockManager.getInstance().setUninstallLockedAppBundleName('');
  }

  /**
   * delete app in pageDesktop
   *
   * @param DeleteItemType[]
   */
  public deleteAppItemBatch(items: DeleteItemType[]): void {
    if (ArrayUtils.isEmpty(items)) {
      log.showWarn(TAG, 'deleteAppItemBatch items is empty');
      return;
    }
    log.showInfo(TAG, `deleteAppItemBatch items length: ${items.length}`);
    let autoAlignDeleteItemList: GridLayoutItemInfo[] = [];
    for (let i = 0; i < items.length; i++) {
      let deleteItems: GridLayoutItemInfo[] = this.mLauncherLayoutCacheManager
        .selectSameAppAndFolder(items[i].keyName, items[i].bundleName, items[i].folderId, items[i].appIndex,
          items[i].shortcutId, false);
      this.deleteAppItemOne(items[i], false);
      if (!CheckEmptyUtils.isEmptyArr(deleteItems) && !CheckEmptyUtils.isEmpty(deleteItems[0]) &&
        deleteItems[0].container === CommonConstants.CONTAINER_DESKTOP) {
        autoAlignDeleteItemList.push(deleteItems[0]);
      }
    }
    if (!items[0].deleteByDockDrop) {
      this.viewModelUtils.getAlignStatus().then((mAutoAlignStatus) => {
        if (mAutoAlignStatus) {
          this.deleteAppItemAutoAlign(autoAlignDeleteItemList);
        }
      });
    }
    this.afterDeleteDesktopItem();
  }

  private dealAppStatusAfterDelete(deleteItemList: GridLayoutItemInfo[], appItem: DeleteItemType): void {
    for (const deleteItem of deleteItemList) {
      if (deleteItem.appStatus !== AppStatus.INSTALLED) {
        this.mUninstallingItem.push(deleteItem);
        this.mInstallingItem = this.mInstallingItem.filter(item => item.bundleName !== deleteItem.bundleName);
      }
      const page = deleteItem.page;
      if (page === undefined) {
        continue;
      }
      let ret: boolean = this.mPageDesktopModel.deleteBlankPageFromLayoutInfo(page, false);
      AppGalleryDownloadManager.getInstance().deleteDownloadTaskInfo(appItem.bundleName);
      AppGalleryDownloadManager.getInstance().deleteDownloadProgressInfo(appItem.bundleName);
      if (!ret) {
        break;
      }
      const curPageIndex = this.mPageDesktopModel.getPageIndex(false);
      log.showInfo(TAG, 'deleteAppItem' + curPageIndex);
      if (curPageIndex >= page) {
        this.mPageDesktopModel.setPageIndex((curPageIndex > 0) ? (curPageIndex - 1) : curPageIndex, false);
      }
      break;
    }
  }

  /**
   * 编辑模式下删除文件夹内应用和快捷方式
   *
   * @param uninstallItemInfo 要删除的应用或快捷方式信息
   */
  public uninstallAppInFolder(uninstallItemInfo: GridLayoutItemInfo): void {
    if (CheckEmptyUtils.isEmpty(uninstallItemInfo)) {
      log.showWarn(TAG, 'uninstallItemFromFolder failed: appInfo is empty.');
      return;
    }
    // 在编辑模式文件夹内快捷方式删除时，发现isUninstallAble存在为undefined的情况
    // 与图标对齐后，undefined均视为true
    if (uninstallItemInfo.isUninstallAble === undefined || uninstallItemInfo.isUninstallAble === false) {
      log.showWarn(TAG, 'uninstallItemFromFolder failed: isUninstallAble is false.');
      return;
    }
    const openFolderId: string = this.mFolderMgr.getOpenFolderId();
    const isCardFolder: boolean = GridLayoutUtil.isBigFolder(this.mFolderMgr.getOpenedFolder());
    log.showInfo(TAG, 'uninstallItemFromFolder appName: %{public}s, uninstallAble: %{public}s',
      uninstallItemInfo.bundleName, uninstallItemInfo.isUninstallAble);
    let appItem = uninstallItemInfo.toAppItemInfo();
    if (uninstallItemInfo.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
      log.showInfo(TAG, 'removeShortcutItem');
      this.removeShortcutItem(appItem);
    } else if (uninstallItemInfo.typeId === CommonConstants.TYPE_APP && uninstallItemInfo.appStatus !== AppStatus.INSTALLED) {
      // 下载中删除
      AppInstallUtils.getInstance().cancelTask(uninstallItemInfo.bundleName);
    } else {
      log.showInfo(TAG, 'uninstallApp');
      this.uninstallApp(uninstallItemInfo.bundleName, uninstallItemInfo.isUninstallAble, uninstallItemInfo.appIndex);
    }
  }

  /**
   * 卸载快捷方式
   *
   * @param appItem 快捷方式AppItemInfo
   * @param needRefreshDesktop 可选参数，删除后是否需要更新桌面布局，默认更新
   */
  public removeShortcutItem(appItem: AppItemInfo, needRefreshDesktop: boolean = true): void {
    log.showInfo(TAG, `removeShortcutItem ${appItem?.shortcutId}, ${appItem.bundleName}, ${appItem.appIndex}`);
    HiEditModeEventUtils.reportShortcutReMove(appItem.shortcutId, appItem.bundleName, appItem.moduleName);
    this.mUninstallListeners.forEach(listener => listener?.uninstallApp(appItem.bundleName, appItem.appIndex,
      appItem.shortcutId));
    this.mUninstallListeners.forEach(listener => listener?.uninstallAppResult(appItem.bundleName,
      CommonConstants.UNINSTALL_SUCCESS, appItem.appIndex, appItem.shortcutId));
    this.mLauncherLayoutCacheManager.deleteShortcutItem(appItem, true, false);
    this.mShortcutViewModel.deleteShortcutFromBMS({ bundleName: appItem.bundleName, appIndex: appItem.appIndex,
      id: appItem.shortcutId });
    if (this.mPageDesktopModel.deleteBlankPageFromLayoutInfo(appItem.page, false)) {
      const curPageIndex = this.mPageDesktopModel.getPageIndex(false);
      log.showInfo(TAG, 'deleteAppItem' + curPageIndex);
      if (curPageIndex === appItem.page) {
        // 被删除的是当前页，则返回到上一页
        this.mPageDesktopModel.setPageIndex((curPageIndex > 0) ? (curPageIndex - 1) : curPageIndex, false);
      }
    }
    const dragItemType = AppStorage.get<number>('dragItemType') as number;
    const isDragFromFolder = dragItemType === CommonConstants.DRAG_FROM_FOLDER;
    log.showInfo(TAG, `isDragFromFolder ${isDragFromFolder}`);
    if (isDragFromFolder) {
      // 刷新文件夹
      const openFolderId: string = this.mFolderMgr.getOpenFolderId();
      const folder: FoldersData = this.mFolderMgr.getFolder(openFolderId);
      const delItem: GridLayoutItemInfo = appItem as object as GridLayoutItemInfo;
      this.mFolderMgr.batchDeleteInFolders('delete from desktop', [delItem], [folder], true);
    }
    if (needRefreshDesktop) {
      // 待移除快捷方式动效执行完成后，刷新桌面
      setTimeout(() => {
        this.afterDeleteDesktopItem();
      }, REFRESH_DESKTOP_DELAY)
    }
  }

  /**
   * add app to pageDesktop
   *
   * @param appInfo
   */
  addToDesktop(appInfo: GridLayoutItemInfo): void {
    let appItemInfo: AppItemInfo | undefined;
    const shortcutId = appInfo?.shortcutId ?? '';
    if (appInfo.itemType === CommonConstants.TYPE_SHORTCUT_ICON) {
      appItemInfo = appInfo as AppItemInfo;
      appItemInfo.typeId = appInfo.itemType;
      appItemInfo.shortcutId = shortcutId;
    } else {
      if (appInfo?.keyName) {
        appItemInfo = AppModel.getInstance().getAppInfoByKeyName(appInfo.keyName);
      } else {
        appItemInfo = AppModel.getInstance().getAppInfoByBundleName(appInfo?.bundleName);
      }
      if (!appItemInfo) {
        log.showInfo(TAG, `addToDesktop get appItemInfo error. bundleName:${appInfo?.bundleName}, keyName:${appInfo?.keyName}`);
        return;
      }
      appItemInfo.typeId = CommonConstants.TYPE_APP;
    }
    appItemInfo.area = [1, 1];
    this.mBundleInfoList = this.mSettingsModel.getAppListInfo();
    log.showWarn(TAG, `addToDesktop keyName: ${appItemInfo?.keyName}, mBundleInfoList length: ${this.mBundleInfoList.length}`);
    for (let i = 0; i < this.mBundleInfoList.length; i++) {
      const shortcutIdTemp = this.mBundleInfoList[i]?.shortcutId ?? '';
      if (this.mBundleInfoList[i].keyName === appItemInfo.keyName &&
        this.mBundleInfoList[i]?.appIndex === appItemInfo.appIndex &&
        shortcutIdTemp === shortcutId) {
        log.showWarn(TAG, 'addToDesktop in loop:' + JSON.stringify(this.mBundleInfoList[i]));
        Prompt.showToast({
          message: this.mResourceManager.getStringByName('duplicate_add'),
          bottom: this.getToastBottom()
        });
        return;
      }
    }

    if (this.mLauncherLayoutCacheManager.isAppInFolder(appItemInfo)) {
      Prompt.showToast({
        message: this.mResourceManager.getStringByName('duplicate_add'),
        bottom: this.getToastBottom()
      });
      return;
    }

    let gridLayoutItemList: GridLayoutItemInfo[] =
      this.filterItemExceedCurrentScreen(this.mLauncherLayoutCacheManager.getAllGridLayoutItemList(BusinessType.BUSINESS_BASIC_DESKTOP));
    // hopper PC:传入pageId与keyBoardStatus值一致(无键盘时为-1),其他设备:keyBoardStatus 默认为 -1.
    if (this.mLauncherLayoutCacheManager.isAddAppOverMaxPage(this.mSettingsModel.getGridConfig(), this.keyBoardStatus,
      gridLayoutItemList)) {
      Prompt.showToast({
        message: this.mResourceManager.getStringByName('add_icon_to_desktop_max'),
        bottom: this.getToastBottom()
      });
      return;
    }
    if (this.isPad) {
      const buildItem: GridLayoutItemInfo = this.viewModelUtils.buildGridLayoutInfoFromItemInfo(appItemInfo, 0, 0, 0);
      this.updateElementLocation(this.mLauncherLayoutCacheManager.selectLayoutDescription(), buildItem);
    }
    this.lightPagingFiltering(false, SceneMsgEnum.SCENE_MSG_ADD_TO_DESKTOP);
    if (this.isPad) {
      Prompt.showToast({
        message: this.mResourceManager.getStringByName('added_to_desktop'),
        bottom: this.getToastBottom()
      });
    }
  }

  /**
   * update badge in desktop
   *
   * @param badgeInfo
   */
  updateBadgeNumber(badgeInfo: BadgeItemInfo): void {
    // badgeInfo.checkAppInstanceKey 应用多开实例消息不在桌面显示，判断多开消息，在桌面直接退出
    if (AppStorage.get('isDesktopLoadFinished') !== true || !CheckEmptyUtils.checkStrIsEmpty(badgeInfo?.appInstanceKey)) {
      log.showInfo(TAG, 'the desktop is not load finished');
      return;
    }
    iconLog.showWarn(TAG, `updateBadgeNumber bundleName: ${badgeInfo.bundleName} appIndex: ${badgeInfo.appIndex}`);
    this.mBundleInfoList = this.mSettingsModel.getAppListInfo();

    let appInfo = this.mBundleInfoList.find(item => {
      return item.bundleName === badgeInfo.bundleName && item.appIndex === badgeInfo.appIndex;
    });
    if (appInfo) {
      appInfo.badgeNumber = badgeInfo.isShow ? badgeInfo.badgeNumber : 0;
      this.mSettingsModel.setAppListInfo(this.mBundleInfoList);
    } else {
      appInfo = FolderLayoutCacheManager.getInstance().updateBadgeNumberInFolder(badgeInfo, BusinessType.BUSINESS_BASIC_DESKTOP, false);
    }
    if (appInfo?.bundleName) {
      const newBadgeNumber = badgeInfo.isShow ? badgeInfo.badgeNumber : 0;
      localEventManager.sendLocalEventSticky(`badgeUpdate${appInfo.bundleName}${appInfo.appIndex ?? 0}`, newBadgeNumber);
    }
  }

  /**
   * add app to dock
   *
   * @param appInfo
   */
  addToDock(appInfo: AppItemInfo): void {
    this.mPageDesktopModel.sendDockItemChangeEvent(appInfo);
  }

  sendBehaviorEvent(formInfo: GridLayoutItemInfo): void {
    const sysEventInfo: hiSysEvent.SysEventInfo = {
      domain: 'LAUNCHER',
      name: 'LAUNCHER_BEHAVIOR',
      eventType: hiSysEvent.EventType.BEHAVIOR,
      params: {
        'BEHAVIOR_ID': 'formManager',
        'BUNDLE_NAME': formInfo.bundleName,
        'APP_NAME': formInfo.appName,
        'MSG': 'phone formManager behavior',
      }
    };
    hiSysEvent.write(sysEventInfo,
      (err, value) => {
        if (err) {
          log.showError(TAG, `launcher behavior hiSysEvent write error: ${err.code}`);
        }
      });
  }

  private appendAppData(appInfoList: AppItemInfo[], bundleInfoList: AppItemInfo[]): void {
    for (let i = 0; i < appInfoList.length; i++) {
      if (this.isInHideAppList(appInfoList[i] as GridLayoutItemInfo)) {
        continue;
      }
      appInfoList[i].typeId = CommonConstants.TYPE_APP;
      appInfoList[i].area = [1, 1];
      bundleInfoList.push(appInfoList[i]);
    }
  }

  private appendShortcutData(shortcutInfoList: GridLayoutItemInfo[], bundleInfoList: AppItemInfo[]): void {
    for (let i = 0; i < shortcutInfoList.length; i++) {
      if (this.isInHideAppList(shortcutInfoList[i])) {
        continue;
      }
      shortcutInfoList[i].typeId = CommonConstants.TYPE_SHORTCUT_ICON;
      shortcutInfoList[i].area = [1, 1];
      bundleInfoList.push(shortcutInfoList[i] as AppItemInfo);
    }
  }

  private isInHideAppList(appInfo: GridLayoutItemInfo): boolean {
    for (const hideInfo of this.mHideBundleInfoList) {
      if (appInfo.keyName === hideInfo.keyName) {
        return true;
      }
    }
    return false;
  }

  private async updateFormData(formInfoList: GridLayoutItemInfo[]): Promise<void> {
    let allFormInfo: CardItemInfo[] = await this.mFormModel.getAllFormsInfo();
    if (CheckEmptyUtils.isEmptyArr(formInfoList) || CheckEmptyUtils.isEmptyArr(allFormInfo)) {
      log.showInfo(TAG, 'updateFormData formInfoList or allFormInfo is null');
      return;
    }

    for (let i = 0; i < formInfoList.length; i++) {
      let cardItem: CardItemInfo = allFormInfo.find(item => ((item.bundleName === formInfoList[i].bundleName) &&
        (item.cardName === formInfoList[i].cardName))) as CardItemInfo;
      if (CheckEmptyUtils.isEmpty(cardItem)) {
        continue;
      }
      log.showInfo(TAG, `update default activated ${formInfoList[i].bundleName}: ${cardItem.isDefaultActivated}`);
      formInfoList[i].isDefaultActivated = cardItem.isDefaultActivated;

      if (CheckEmptyUtils.checkStrIsEmpty(formInfoList[i].cardId)) {
        continue;
      }

      if (cardItem.cardName === 'OneMulFourClockCard') {
        log.showWarn(TAG, `updateFormData ${cardItem.cardName}`);
        formInfoList[i].isFormDimension1x4 = true;
        formInfoList[i].area = CardItemInfo.getCardSize(cardItem.dimension, formInfoList[i].isFormDimension1x4);
      }
      if ((formInfoList[i].formConfigAbility !== cardItem.formConfigAbility) ||
        (formInfoList[i].isTransparent !== cardItem.isTransparent) ||
        (cardItem.gameCardInfo && !formInfoList[i].gameCardInfo)) {
        formInfoList[i].formConfigAbility = cardItem.formConfigAbility;
        formInfoList[i].isTransparent = cardItem.isTransparent;
        formInfoList[i].gameCardInfo = cardItem.gameCardInfo;

        // 将游戏卡片信息 gameCardInfo，增量更新到 intent 字段中
        let newIntent: string | undefined = this.updateFormIntent(formInfoList[i], cardItem);
        if (newIntent) {
          formInfoList[i].intent = newIntent;
        }
        let formInfoTmp: CardItemInfo = this.mFormModel.convertToFormItem(formInfoList[i]);
        this.mFormModel.updateFormConfigInfo(formInfoTmp);
      }
    }
  }

  private updateFormIntent(formInfo: GridLayoutItemInfo, cardItem: CardItemInfo): string | undefined {
    // 将游戏卡片信息 gameCardInfo，增量更新到 intent 字段中
    let intentMap: Map<string, Object> = CommonUtils.jsonStrToMap(formInfo.intent);
    let intentAfterUpdate =
      OverflowFormInfoUtil.updateLiveFromData(intentMap, cardItem.intent, OverflowConstants.INTENT_KEY_GAMECARD);
    if (!intentAfterUpdate) {
      intentAfterUpdate =
        OverflowFormInfoUtil.updateLiveFromData(intentMap, cardItem.intent,
          OverflowConstants.INTENT_KEY_LIVE_FORM_CARD);
    }
    return intentAfterUpdate;
  }

  private async appendFormData(formInfoList: GridLayoutItemInfo[], bundleInfoList: GridLayoutItemInfo[]): Promise<void> {
    let appListCopy: AppItemInfo[] = [];
    appListCopy.push(...this.mAppModel.getAppList());
    if (SCBOobeManager.isEnable()) {
      log.showWarn(TAG, 'in oobe, do not query AtomicServiceAppList');
    } else {
      appListCopy.push(...await this.mAtomicServiceAppModel.getAtomicServiceAppList());
    }
    log.showInfo(TAG, `the length of appListCopy is ${appListCopy.length}`);
    if (!this.mIsFinishedInitLayout) {
      await this.updateFormData(formInfoList);
    }

    for (let i = 0; i < formInfoList.length; i++) {
      formInfoList[i].typeId = CommonConstants.TYPE_CARD;
      this.viewModelUtils.updateFormId(formInfoList[i], appListCopy);
      if (CheckEmptyUtils.isEmpty(formInfoList[i].bundleName)) {
        log.showInfo(TAG, 'formInfo has not bundlename, not to display');
        continue;
      }
      OverflowFormInfoUtil.fillOverflowCardInfoInGridLayout(formInfoList[i]);
      bundleInfoList.push(formInfoList[i]);
    }
    this.mLauncherLayoutCacheManager.updateFormsCacheInfoByFormList(formInfoList, BusinessType.BUSINESS_CARD);
  }

  private updateFormLabel(formInfo: CardItemInfo): void {
    let appListCopy: AppItemInfo[] = [];
    appListCopy.push(...this.mAppModel.getAppList());
    let atomicInfo: AppItemInfo | undefined = this.mAtomicServiceAppModel.getAtomicInfoByBundleName(formInfo.bundleName);
    if (atomicInfo) {
      appListCopy.push(atomicInfo);
    }
    this.viewModelUtils.updateFormId(formInfo, appListCopy);
  }

  /**
   * Obtains Grid Configuration.
   */
  getGridConfig(): GridLayoutConfig {
    return this.mSettingsModel.getGridConfig();
  }

  /**
   * light refresh page
   */
  lightPagingFiltering(isSkipDuplicateCheck?: boolean,
    sceneMsg: string = SceneMsgEnum.SCENE_MSG_DEFAULT_REFRESH): void {
    log.showInfo(TAG, `lightPagingFiltering is executed when ${sceneMsg}`);
    this.highFrequencyStatistics.record('lightPagingFiltering');
    Trace.start(Trace.CORE_METHOD_LIGHT_PAGING_FILTERING + sceneMsg);
    const desktopLayoutInfo: GridAppListInfoNew = {
      appGridInfo: [],
      waterfallItemListInfo: []
    };
    if (!isSkipDuplicateCheck) {
      this.checkIfDuplicatePosition(true);
    }
    let appListInfo: GridLayoutItemInfo[] = new Array<GridLayoutItemInfo>();
    let allGridLayoutItems = this.mLauncherLayoutCacheManager.getAllGridLayoutItemList(BusinessType.BUSINESS_BASIC_DESKTOP);
    this.mBundleInfoList = allGridLayoutItems;
    this.mSettingsModel.setAppListInfo(this.mBundleInfoList);
    const folderInfoList = this.mLauncherLayoutCacheManager.selectGridLayoutItemsByType(CommonConstants.TYPE_FOLDER);
    FolderDataModelManager.getInstance().initFolderData(folderInfoList);
    appListInfo = this.getAppListInfo(undefined, appListInfo, allGridLayoutItems);
    // 将一维数组整理到不同的swiper中
    const allRankedAppInfos = this.integrateSwiper(appListInfo);
    desktopLayoutInfo.appGridInfo = allRankedAppInfos.gridAppsInfos;
    desktopLayoutInfo.waterfallItemListInfo = allRankedAppInfos.waterfallAppInfos;
    log.showWarn(TAG, 'lightPagingFiltering length of appListInfo:%{public}d waterfallInfo:%{public}d bundleInfo:%{public}d',
      appListInfo.length, desktopLayoutInfo.waterfallItemListInfo.length, this.mBundleInfoList?.length);
    AppStorage.SetOrCreate('selectDesktopAppItem', '');
    AppStorage.SetOrCreate('selectItem', '');
    this.checkIsAutoAnimating();
    LayoutViewModel.getInstance().updateDesktopLayoutData(desktopLayoutInfo, 'lightPagingFiltering');
    if (!isSkipDuplicateCheck) {
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_PAGEDESK_REFRESH_FINISHED, null);
    }
    Trace.end(Trace.CORE_METHOD_LIGHT_PAGING_FILTERING + sceneMsg);
  }

  /**
   * refresh page
   */
  private pagingFiltering(bundleInfoList = this.mBundleInfoList, abilityInfo?: GridLayoutItemInfo,
    sceneMsg: string = SceneMsgEnum.SCENE_MSG_DEFAULT_REFRESH, isOuter?: boolean): void {
    log.showInfo(TAG, `pagingFiltering is executed when ${sceneMsg}`);
    this.highFrequencyStatistics.record('pagingFiltering');
    Trace.start(Trace.CORE_METHOD_PAGING_FILTERING + sceneMsg);
    const appInfo: GridAppListInfoNew = {
      appGridInfo: [],
      waterfallItemListInfo: []
    };
    let appListInfo: GridLayoutItemInfo[] = new Array<GridLayoutItemInfo>();
    this.getAndSetLayoutInfo(bundleInfoList, undefined, isOuter);
    const layoutInfo: GridLayoutItemInfo[] = this.mLauncherLayoutCacheManager.getAllGridLayoutItemList(
      BusinessType.BUSINESS_BASIC_DESKTOP, isOuter);
    appListInfo = this.getAppListInfo(bundleInfoList, appListInfo, layoutInfo, abilityInfo);

    const allAppInfos = this.integrateSwiper(appListInfo, isOuter);
    appInfo.appGridInfo = allAppInfos.gridAppsInfos;
    appInfo.waterfallItemListInfo = allAppInfos.waterfallAppInfos;
    log.showWarn(TAG, `pagingFiltering appListInfo length: ${appListInfo.length} waterfallInfo length: ${appInfo.waterfallItemListInfo.length}`);
    AppStorage.setOrCreate('selectDesktopAppItem', '');
    AppStorage.setOrCreate('selectItem', '');
    this.checkIsAutoAnimating();
    LayoutViewModel.getInstance().updateDesktopLayoutData(appInfo, 'pagingFiltering', isOuter);
    if (!this.mIsFinishedInitLayout) {
      this.changeIndex(0);
      AppFormWeightManager.getInstance().refreshUsageWeight();
      let pageCount: number = this.mLauncherLayoutCacheManager.selectPageCount(isOuter);
      for (let i = 0; i < layoutInfo.length; i++) {
        if (layoutInfo[i].page) {
          pageCount = Math.max(pageCount, (layoutInfo[i].page ?? 0) + 1);
        }
      }
      this.setGridPageCount(pageCount, isOuter);
      this.mFormListInfoCacheManager.setCache(KEY_FORM_LIST, this.formInfoList);
      this.mIsFinishedInitLayout = true;
      MatchCardLayoutManager.getInstance().setIsFinishedInitLayout();
    }
    localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_PAGEDESK_REFRESH_FINISHED, null);
    Trace.end(Trace.CORE_METHOD_PAGING_FILTERING + sceneMsg);
  }

  private checkIsAutoAnimating(): void {
    if (!CheckEmptyUtils.isEmptyArr(this.mAutoAlignUpdateItem) &&
    CheckEmptyUtils.isEmptyArr(this.mGridLayoutItemList)) {
      this.mAutoAlignUpdateItem.forEach(item => {
        DragEventManager.getInstance().cancelSqueezedInDesktop(GridLayoutUtil.generateUniqueKey(item), false);
      });
      this.mAutoAlignUpdateItem = [];
      this.mAutoAlignStatus = false;
    }
  }

  private getAppListInfo(bundleInfoList = this.mBundleInfoList, appListInfo: GridLayoutItemInfo[],
    layoutInfo: GridLayoutItemInfo[], abilityInfo?: GridLayoutItemInfo): GridLayoutItemInfo[] {
    const needResetAppInfoList: GridLayoutItemInfo[] = [];
    let deleteAppList: GridLayoutItemInfo[] = new Array<GridLayoutItemInfo>();
    for (let i = 0; i < layoutInfo.length; i++) {
      if (layoutInfo[i].typeId === CommonConstants.TYPE_APP || layoutInfo[i].typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
        // do not change installing app's layout
        let isAddToLayout: boolean = false;
        if (!GridLayoutUtil.isAppInstalled(layoutInfo[i]) && layoutInfo[i].appStatus !== AppStatus.UPDATING) {
          log.showWarn(TAG, 'insert uninstalled app %{public}s', layoutInfo[i]?.bundleName);
          appListInfo.push(layoutInfo[i]);
          continue;
        } else {
          for (let j = 0; j < bundleInfoList.length; j++) {
            if (layoutInfo[i].keyName === bundleInfoList[j].keyName &&
              layoutInfo[i].typeId === bundleInfoList[j].typeId) {
              bundleInfoList[j].infoId = layoutInfo[i].infoId;
              bundleInfoList[j].area = layoutInfo[i].area;
              bundleInfoList[j].page = layoutInfo[i].page;
              bundleInfoList[j].row = layoutInfo[i].row;
              bundleInfoList[j].column = layoutInfo[i].column;
              bundleInfoList[j].areaType = CommonConstants.TYPE_AREA_DESKTOP;
              bundleInfoList[j].x = 0;
              bundleInfoList[j].downloadProgress = layoutInfo[i].downloadProgress;
              bundleInfoList[j].appStatus = layoutInfo[i].appStatus;
              bundleInfoList[j].iconResource = layoutInfo[i].iconResource;
              bundleInfoList[j].callerName = layoutInfo[i].callerName;
              isAddToLayout = true;
              // 如果应用在不卸载清单内，放在待修改needResetAppInfoList数组中
              PreInstallUtils.checkIsResetAppInfo(bundleInfoList[j], layoutInfo[i], needResetAppInfoList);
              appListInfo.push(bundleInfoList[j]);
              log.showDebug(TAG, 'insert installed app %{public}s', layoutInfo[i]?.keyName);
              break;
            }
          }
        }
        if (!isAddToLayout) {
          log.showWarn(TAG, 'the app %{public}s is error at page %{public}d, row %{public}d column %{public}d and delete from layout',
            layoutInfo[i].keyName, layoutInfo[i].page, layoutInfo[i].row, layoutInfo[i].column);
          this.mLauncherLayoutCacheManager.deleteAppItemByKeyName(layoutInfo[i].keyName, BusinessType.BUSINESS_BASIC_DESKTOP, true);
          if (!CheckEmptyUtils.isEmpty(layoutInfo[i].page)) {
            this.mPageDesktopModel.deleteBlankPageFromLayoutInfo(layoutInfo[i].page);
          }
          if (layoutInfo[i].typeId === CommonConstants.TYPE_APP) {
            deleteAppList.push(layoutInfo[i]);
          }
        }
      } else if (layoutInfo[i].typeId === CommonConstants.TYPE_FOLDER) {
        // 刷新桌面布局时，将小文件夹isInDock置为false，保证展开动效位置正常
        if (GridLayoutUtil.isSmallFolder(layoutInfo[i])) {
          layoutInfo[i].isInDock = false;
        }
        // 覆盖安装时更新folder信息
        if (!abilityInfo) {
          appListInfo.push(layoutInfo[i]);
          continue;
        }
        // 查找并替换覆盖安装的app
        this.dealGridLayoutItemInfo(layoutInfo[i], abilityInfo);
        appListInfo.push(layoutInfo[i]);
      } else if (layoutInfo[i].typeId === CommonConstants.TYPE_CARD) {
        // 预置布局中的卡片
        if (CheckEmptyUtils.checkStrIsEmpty(layoutInfo[i].cardId)) {
          log.showWarn(TAG, `layoutinfo cardId is: ${layoutInfo[i].cardId}, cardDimension is: ${layoutInfo[i].cardDimension}`);
          layoutInfo[i].areaType = CommonConstants.TYPE_AREA_DESKTOP;
          layoutInfo[i].x = 0;
          if (!layoutInfo[i].cardDimension) {
            layoutInfo[i].cardDimension = this.viewModelUtils.getCardDimension(LayoutViewModel.getInstance().getDesktopModel(), layoutInfo[i]);
          }
          appListInfo.push(layoutInfo[i]);
          continue;
        }
        layoutInfo[i].x = 0;
        layoutInfo[i].areaType = CommonConstants.TYPE_AREA_DESKTOP;
        layoutInfo[i].cardDimension = this.viewModelUtils.getCardDimension(LayoutViewModel.getInstance().getDesktopModel(), layoutInfo[i]);
        layoutInfo[i].isFormDimension1x4 = layoutInfo[i].cardName === 'OneMulFourClockCard';
        layoutInfo[i].area = CardItemInfo.getCardSize(layoutInfo[i].cardDimension, layoutInfo[i].isFormDimension1x4);
        appListInfo.push(layoutInfo[i]);
      } else if (layoutInfo[i].typeId === CommonConstants.TYPE_FILE_FOLDER ) {
        if (layoutInfo[i].container !== CommonConstants.CONTAINER_DESKTOP) {
          log.showInfo(TAG, `file or folder not in desktop, container: ${layoutInfo[i].container}`);
          continue;
        }
        appListInfo.push(layoutInfo[i]);
      } else if (layoutInfo[i].typeId === CommonConstants.TYPE_FORM_STACK) {
        appListInfo.push(layoutInfo[i]);
      } else if (layoutInfo[i].typeId === CommonConstants.TYPE_REGION_FOLDER) {
        appListInfo.push(layoutInfo[i]);
      } else if (layoutInfo[i].typeId === CommonConstants.TYPE_ADD) {
        appListInfo.push(layoutInfo[i]);
      }
    };
    appListInfo = this.removeShortcutByDeleteApp(deleteAppList, appListInfo);
    PreInstallUtils.resetAppInfoList(needResetAppInfoList);
    log.showWarn(TAG, `getAppListInfo appListInfo layoutInfo ${appListInfo?.length} ${layoutInfo?.length} ${abilityInfo?.bundleName}`);
    this.viewModelUtils.itemNumMoreReport(appListInfo);
    return appListInfo;
  }

  // 卸载应用，同步移除快捷方式
  private removeShortcutByDeleteApp(deleteAppList: GridLayoutItemInfo[],
    appListInfo: GridLayoutItemInfo[]): GridLayoutItemInfo[] {
    if (CheckEmptyUtils.isEmptyArr(deleteAppList) || CheckEmptyUtils.isEmptyArr(appListInfo)) {
      log.showDebug(TAG, `removeShortcutByDeleteApp return`);
      return appListInfo;
    }
    return appListInfo.filter((app: GridLayoutItemInfo) => {
      if (app.typeId !== CommonConstants.TYPE_SHORTCUT_ICON) {
        return true;
      }
      let res: boolean = true;
      for (let j = 0; j < deleteAppList.length; j++) {
        if (app.bundleName === deleteAppList[j].bundleName && app.appIndex === deleteAppList[j].appIndex) {
          this.removeShortcutItem(app as AppItemInfo, false);
          res = false;
          break;
        }
      }
      return res;
    });
  }

  // 查找并替换覆盖安装的app
  private dealGridLayoutItemInfo(layoutInfo: GridLayoutItemInfo, abilityInfo: GridLayoutItemInfo) : void {
    if (!layoutInfo.layoutInfo) {
      return;
    }
    for (let k = 0; k < layoutInfo.layoutInfo.length; k++) {
      const appInfo = layoutInfo.layoutInfo[k].find(item => {
        return item.keyName === abilityInfo.keyName;
      });
      if (appInfo !== undefined && appInfo.bundleName.length > 0) {
        const index = layoutInfo.layoutInfo[k].indexOf(appInfo);
        appInfo.appName = abilityInfo.appName;
        appInfo.isSystemApp = abilityInfo.isSystemApp;
        appInfo.isUninstallAble = abilityInfo.isUninstallAble;
        appInfo.appIconId = abilityInfo.appIconId;
        appInfo.appLabelId = abilityInfo.appLabelId;
        appInfo.abilityName = abilityInfo.abilityName;
        appInfo.bundleName = abilityInfo.bundleName;
        appInfo.moduleName = abilityInfo.moduleName;
        appInfo.installTime = abilityInfo.installTime;
        appInfo.badgeNumber = abilityInfo.badgeNumber;
        appInfo.appStatus = abilityInfo.appStatus;
        appInfo.iconResource = abilityInfo.iconResource;
        appInfo.downloadProgress = abilityInfo.downloadProgress;
        appInfo.callerName = abilityInfo.callerName;
        appInfo.areaType = CommonConstants.TYPE_AREA_DESKTOP;
        layoutInfo.layoutInfo[k][index] = appInfo;
        break;
      }
    }
  }

  private filterDuplicateAppAndCard(appListInfo: GridLayoutItemInfo[], isOuter?: boolean): GridLayoutItemInfo[] {
    let filterItemListInfo: GridLayoutItemInfo[] = [];
    for (let i = 0; i < appListInfo.length; i++) {
      let item: GridLayoutItemInfo = appListInfo[i];
      let isDuplicateElement: boolean = false;
      let isMultiAppIcon: boolean = this.mAppModel.checkIsMultiIcon(item.bundleName, item.appIndex);
      for (let j = 0; j < filterItemListInfo.length; j++) {
        if (this.checkIsDuplicateElement(filterItemListInfo[j], item, isMultiAppIcon)) {
          isDuplicateElement = true;
          break;
        }
      }
      if (!isDuplicateElement) {
        filterItemListInfo.push(item);
      } else {
        this.mLauncherLayoutCacheManager.deleteDuplicateItemById(item, BusinessType.BUSINESS_BASIC_DESKTOP,
          DeviceHelper.isPC(), isOuter);
        log.showWarn(TAG, `filter the duplicate element in layout type ${item.typeId} id ${item.infoId} bundleName ${item.bundleName}`);
      }
    }
    return filterItemListInfo;
  }

  private checkIsDuplicateElement(firstItem: GridLayoutItemInfo, secItem: GridLayoutItemInfo, isMultiAppIcon: boolean): boolean {
    let isDuplicateElement = false;
    if (firstItem.typeId === CommonConstants.TYPE_APP && firstItem.typeId === secItem.typeId) {
      if ((isMultiAppIcon && secItem.keyName === firstItem.keyName) ||
        (!isMultiAppIcon && secItem.bundleName === firstItem.bundleName)) {
        isDuplicateElement = true;
      }
    } else if (firstItem.typeId === CommonConstants.TYPE_CARD && firstItem.typeId === secItem.typeId) {
      isDuplicateElement = this.checkIsDuplicateCard(firstItem, secItem);
    } else if (firstItem.typeId === CommonConstants.TYPE_FOLDER && firstItem.typeId === secItem.typeId) {
      isDuplicateElement = this.checkIsDuplicateFolder(firstItem, secItem);
    } else if (firstItem.typeId === CommonConstants.TYPE_FORM_STACK && firstItem.typeId === secItem.typeId) {
      isDuplicateElement = this.checkIsDuplicateFormStack(firstItem, secItem);
    } else if (firstItem.typeId === CommonConstants.TYPE_FILE_FOLDER && firstItem.typeId === secItem.typeId) {
      isDuplicateElement = this.checkIsDuplicateFileFolder(firstItem, secItem);
    }
    return isDuplicateElement;
  }

  private checkIsDuplicateCard(firstItem: GridLayoutItemInfo, secItem: GridLayoutItemInfo): boolean {
    return (secItem.cardId === firstItem.cardId && !CheckEmptyUtils.checkStrIsEmpty(firstItem.cardId)) ||
      (firstItem.container === CommonConstants.CONTAINER_DESKTOP && secItem.container === CommonConstants.CONTAINER_DESKTOP &&
        firstItem.row === secItem.row && firstItem.column === secItem.column &&
      CheckEmptyUtils.checkStrIsEmpty(secItem.cardId) && secItem.page === firstItem.page);
  }

  private checkIsDuplicateFolder(firstItem: GridLayoutItemInfo, secItem: GridLayoutItemInfo): boolean {
    return secItem.folderId === firstItem.folderId && !CheckEmptyUtils.isEmpty(firstItem.folderId) && firstItem.folderId !== '0';
  }

  private checkIsDuplicateFormStack(firstItem: GridLayoutItemInfo, secItem: GridLayoutItemInfo): boolean {
    return secItem.formStackId === firstItem.formStackId && !CheckEmptyUtils.isEmpty(firstItem.formStackId) &&
      firstItem.formStackId !== '0';
  }

  private checkIsDuplicateFileFolder(firstItem: GridLayoutItemInfo, secItem: GridLayoutItemInfo): boolean {
    return !CheckEmptyUtils.isEmpty(firstItem.infoId) && secItem.infoId === firstItem.infoId;
  }

  /**
   * 分页
   *
   * @param list appListInfo
   * @param isOuter 是否外屏
   * @returns listInfo
   */
  public integrateSwiper(list: GridLayoutItemInfo[], isOuter?: boolean): GridAppListInfo {
    isOuter = isOuter === undefined ? launcherStatusUtil.getShowOutLauncherStatus() : isOuter;
    let gridAppsInfos: GridLayoutItemInfo[][] = [];
    let waterfallAppInfos: GridLayoutItemInfo[] = [];
    if (CheckEmptyUtils.isEmpty(list)) {
      log.showInfo(TAG, 'list is null from integrateSwiper');
      return {
        gridAppsInfos: gridAppsInfos,
        waterfallAppInfos: waterfallAppInfos
      };
    }
    const allPageCount = this.mLauncherLayoutCacheManager.selectPageCount(isOuter);
    let max = allPageCount;
    // 非空白页页数
    const pageSet: Set<number> = new Set();
    for (let i = 0; i < list.length; i++) {
      let tmpPage = list[i].page;
      if (tmpPage !== undefined) {
        pageSet.add(tmpPage);
        if (max <= tmpPage + 1) {
          if (tmpPage >= max) {
            log.showError(TAG, `elementPage is not less than pageCount-->pageCount:${max}, elementPage:${list[i].page}, ` +
              `bundleName:${list[i].bundleName}, row:${list[i].row}, column:${list[i].column}`);
          }
          max = tmpPage + 1;
        }
      }
    }

    log.showInfo(TAG, `integrateSwiper max ${max}`);
    max = this.getMaxPage(max, pageSet, isOuter);
    for (let i = 0; i < max; i++) {
      gridAppsInfos.push([]);
    }

    for (let i = 0; i < list.length; i++) {
      if (list[i].page === CommonConstants.WATERFALL_PAGE_INDEX) {
        waterfallAppInfos.push(list[i]);
      } else {
        let mPage = list[i].page;
        if (mPage === undefined || mPage < 0 || CheckEmptyUtils.isEmpty(gridAppsInfos[mPage])) {
          log.showError(TAG, 'integrateSwiper page:' + mPage + 'bundle:' + list[i].bundleName + 'length:' + list.length);
        } else {
          gridAppsInfos[mPage].push(list[i]);
        }
      }
    }

    // 展开态开机时如果是奇数页就补一页
    if (desktopUtil.isFoldExpandStatus() || this.isBigScreen) {
      this.foldAddBlankPage(gridAppsInfos);
    }

    if (gridAppsInfos.length === 0) {
      gridAppsInfos.push([]);
    }

    this.mLauncherLayoutCacheManager.updatePageCount(gridAppsInfos.length, BusinessType.BUSINESS_BASIC_DESKTOP, true, isOuter);
    this.updateGridAppsInfos(gridAppsInfos);
    let rst: GridAppListInfo = {
      gridAppsInfos: gridAppsInfos,
      waterfallAppInfos: waterfallAppInfos
    };
    return rst;
  }

  private foldAddBlankPage(gridAppsInfos: GridLayoutItemInfo[][]): void {
    let pageInfoManager: PageInfoManager = PageInfoManager.getInstance();
    if (pageInfoManager.getDisplayCount() === StyleConstants.DEFAULT_3) {
      this.dealBlankPagePowerOn(pageInfoManager.getDisplayCount(), gridAppsInfos.length, gridAppsInfos);
    } else if (gridAppsInfos.length % StyleConstants.DEFAULT_2 === 1) {
      gridAppsInfos.push([]);
      log.showInfo(TAG, `addBlankPageToEnd success when powerOn, gridAppsInfos:${gridAppsInfos.length}`);
    }
  }

  private updateGridAppsInfos(gridAppsInfos: GridLayoutItemInfo[][]): void {
    this.mGridAppsInfos = gridAppsInfos;
  }

  /**
   * 处理开机场景的增补空白页
   * @param displayCount
   * @param currentCount
   * @param gridAppsInfos
   */
  private dealBlankPagePowerOn(displayCount: number, currentCount: number,
    gridAppsInfos: GridLayoutItemInfo[][]): void {
    if (displayCount === 1) {
      return;
    }
    // 对当前页进行求余
    let modulus = currentCount % displayCount;
    if (modulus === 0) {
      return;
    }
    let addBlankPageCount = displayCount - modulus;
    for (let i = 0; i < addBlankPageCount; i++) {
      gridAppsInfos.push([]);
    }
  }

  private getMaxPage(maxPage: number, pageSet: Set<number>, isOuter?: boolean): number {
    const rdbPageCount: number = PageInfoManager.getInstance().getPageCount(isOuter);
    let newMaxPage: number = Math.max(maxPage, rdbPageCount);
    log.showInfo(TAG, `getMaxPage rdbPageCount ${rdbPageCount} isOuter ${isOuter}`);
    // 删除verde由内屏编辑外屏照成的空白页
    if (isOuter && pocketPreferenceUtil.getRefreshOuterScreenFromDBFlag()) {
      let oldOuterBlankPageSize: number = PageInfoManager.getInstance().getBlankPageList(true).size;
      let currentBlankPageSize: number = newMaxPage - pageSet.size;
      let exceptionBlankPageSize = currentBlankPageSize - oldOuterBlankPageSize;
      // 存在异常空白页
      if (exceptionBlankPageSize > 0) {
        newMaxPage -= exceptionBlankPageSize;
      }
      log.showInfo(TAG, `getMaxPage pageSet: ${pageSet.size} oldOuterBlankPageSize: ${oldOuterBlankPageSize} ` +
        `exceptionBlankPageSize: ${exceptionBlankPageSize} newMax: ${newMaxPage} `);
    }
    return newMaxPage;
  }

  private getAndSetLayoutInfo(bundleInfoList: GridLayoutItemInfo[], sceneMsg?: string, isOuter?: boolean): void {
    this.mLauncherLayoutCacheManager.updateLayoutDescriptionRowAndColumn(this.getGridConfig(), DeviceHelper.isPad(),
      BusinessType.BUSINESS_BASIC_DESKTOP, isOuter);
    if (DeviceHelper.isPad()) {
      PadLaunchLayoutCacheManager.getInstance().initGridConfig(this.getGridConfig());
    }
    const isLegal = this.mLauncherLayoutCacheManager.checkIfLayoutRationality(this.getGridConfig());
    if (!isLegal) {
      HiDfxEventUtil.reportLauncherCacheAbnormal(sceneMsg, 'checkIfLayoutRationality is not legal');
    }
    this.checkIfDuplicatePosition(isLegal, sceneMsg, isOuter);
    this.updateLayoutInfo(bundleInfoList, isOuter);
    log.showInfo(TAG, 'getAndSetLayoutInfo isLegal: ' + isLegal);
  }

  private checkIfDuplicatePosition(isLegal: boolean, sceneMsg?: string, isOuter?: boolean): void {
    try {
      this.filterDuplicateAppAndCard(this.mLauncherLayoutCacheManager.getAllGridLayoutItemList(
        BusinessType.BUSINESS_BASIC_DESKTOP, isOuter), isOuter);
      let isPositionDuplicate: boolean = this.mLauncherLayoutCacheManager.checkIfDuplicatePosition(isOuter);
      if (isPositionDuplicate) {
        HiDfxEventUtil.reportLauncherCacheAbnormal(sceneMsg, 'checkIfDuplicatePosition is duplicate');
      }
      if (isLegal && !isPositionDuplicate) {
        return;
      }
      // 如果桌面元素位置存在重复，调整layoutInfo元素挤位顺序，先卡片、文件夹等大元素，再图标，避免大元素显示不全
      log.warn('the element position in layoutInfo is duplicated');
      HiDfxEventUtil.reportElementPositionAbnormal();
      if (!this.mIsNeedRearrange) {
        return;
      }
      if (DeviceHelper.isPC()) {
        this.mLauncherLayoutCacheManager.updateLayoutIfDuplicate();
        return;
      }
      this.mIsNeedRearrange = false;
      let reArrangeElements: GridLayoutItemInfo[] = this.mLauncherLayoutCacheManager
        .reArrangeLayoutInfo(LayoutViewModel.getInstance().getDesktopModel(), isOuter);
      this.batchUpdateAppItemLayoutInfo(reArrangeElements, undefined, isOuter);
      this.mIsNeedRearrange = true;
    } catch (error) {
      log.showInfo(TAG, 'checkIfDuplicatePosition failure with error %{public}s', error.message);
    }
  }

  private updateLayoutInfo(bundleInfoList: GridLayoutItemInfo[], isOuter?: boolean): void {
    const newApp: GridLayoutItemInfo[] = [];
    let bottomAppList: DockItemInfo[] = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
    log.showWarn(TAG, 'the mBundleInfoList size ' + bundleInfoList.length + ' bottomAppList size: ' + bottomAppList.length);
    //Detect newly installed apps
    for (const itemInfo of bundleInfoList) {
      if (this.unInstallList.has(`${itemInfo.bundleName}${itemInfo.appIndex ?? 0}`)) {
        continue;
      }
      if (MatchCardDataManager.isMatchCardApp(itemInfo as AppItemInfo, 'updateLayoutInfo')) {
        MatchCardDataManager.updateWaitAddFolderApps(itemInfo as AppItemInfo);
        continue;
      }
      let isNewApp = this.mLauncherLayoutCacheManager.checkIfNewInstalledApp(itemInfo, DeviceHelper.isPad(), isOuter);
      // 检测dock栏图标是否已加载
      for (const bottomApp of bottomAppList) {
        if (DeviceHelper.isPhoneOrPad() && bottomApp.itemType === CommonConstants.TYPE_APP &&
          bottomApp.keyName === itemInfo.keyName) {
          log.showWarn(TAG, `new app from dock: ${itemInfo.bundleName}`);
          isNewApp = false;
          break;
        }
      }
      if (isNewApp) {
        newApp.push(itemInfo);
      }
    }
    log.showWarn(TAG, 'the newApp size ' + newApp?.length);
    // Add new app
    this.batchUpdateAppItemLayoutInfo(newApp, undefined, isOuter);
    this.updateInstallingAppItem();
    log.showInfo(TAG, 'UpdateLayoutInfo complete ');
  }

  private updateInstallingAppItem(): void {
    if (this.mIsNeedUpdateInstallingApp) {
      this.mInstallingItem.forEach(installingItem => {
        if (installingItem.appStatus !== AppStatus.INSTALLED) {
          this.updateAppItemLayoutInfo(installingItem, false);
        }
      });
      this.mUninstallingItem.forEach(unInstallingItem => {
        if (unInstallingItem.appStatus !== AppStatus.INSTALLED) {
          let delItem: DeleteItemType = {
            bundleName: unInstallingItem.bundleName,
            keyName: unInstallingItem.keyName,
            abilityName: unInstallingItem.abilityName,
            moduleName: unInstallingItem.moduleName,
            appIndex: unInstallingItem.appIndex,
          };
          this.mLauncherLayoutCacheManager.deleteSameAppAndFolder(delItem, BusinessType.BUSINESS_BASIC_DESKTOP, true, false);
        }
      });
      log.showInfo(TAG, 'the new installing app %{public}d unInstalling app %{public}s', this.mInstallingItem.length,
        this.mUninstallingItem.length);
      this.mInstallingItem = [];
      this.mUninstallingItem = [];
      this.mIsNeedUpdateInstallingApp = false;
    }
  }

  public isCanCreateFolder(pageId?: number): boolean {
    let isPad = this.getDevice();
    if (!isPad) {
      return false;
    }
    let layoutDescription: LayoutDescription = this.mLauncherLayoutCacheManager.selectLayoutDescription();
    let first = layoutDescription.column;
    let second = layoutDescription.row;
    let item : ItemParameter = {
      area: [1, 1]
    };
    for (let y = 0; y < first; y++) {
      for (let x = 0; x < second; x++) {
        let positionX = isPad ? y : x;
        let positionY = isPad ? x : y;
        if (this.mLauncherLayoutCacheManager.isPositionValid(item, pageId ?? 0, positionX, positionY)) {
          return true;
        }
      }
    }
    return false;
  }

  public getNewFilePosition(col: number, row: number, pageId?: number): DragGridPosition | undefined {
    const page: number = pageId ?? 0;
    let positionOccupied = this.mLauncherLayoutCacheManager.isPositionOccupied(page, col, row);
    if (!positionOccupied) {
      let colAndRow: DragGridPosition = { column: col, row: row };
      return colAndRow;
    }
    let layoutDescription: LayoutDescription = this.mLauncherLayoutCacheManager.selectLayoutDescription();
    if (!layoutDescription) {
      return undefined;
    }
    let first = layoutDescription.column;
    let second = layoutDescription.row;
    let item : ItemParameter = {
      area: [1, 1]
    };
    for (let y = 0; y < first; y++) {
      for (let x = 0; x < second; x++) {
        let positionX = y;
        let positionY = x;
        if (this.mLauncherLayoutCacheManager.isPositionValid(item, page, positionX, positionY)) {
          let colAndRow: DragGridPosition = { column: positionX, row: positionY };
          return colAndRow;
        }
      }
    }
    return undefined;
  }

  private getRowOrColumn(layoutDescription: LayoutDescription, isPad: boolean): number {
    return isPad ? layoutDescription.column : layoutDescription.row;
  }

  private getStartCoordinates(item: GridLayoutItemInfo): StartInfo {
    let rst: StartInfo = {
      startColumn: item?.column ?? 0,
      startRow: item?.row ?? 0
    };
    return rst;
  }

  /**
   * 获取分页信息
   * @param page 可选参数，表示当前的页码，如果没有提供或者为undefined，则默认为0
   * @return 返回一个对象，包含开始页索引和页数
   */
  private getPageInfo(page?: number): PageInfo {
    let startPageIndex: number = 0;
    let pageCount: number = 0;
    // 无键盘走原始逻辑/有键盘使用键盘态判断当前页面
    if (this.keyBoardStatus === FeatureConstants.NO_KEYBOARD) {
      startPageIndex = page ?? 0;
      pageCount = this.mLauncherLayoutCacheManager.selectPageCount();
    } else {
      startPageIndex = this.keyBoardStatus;
      pageCount = startPageIndex + 1;
    }
    return { startPageIndex, pageCount };
  }

  /**
   * 批量更新文件夹和应用位置信息
   *
   * @param item 需要更新的文件夹或应用
   * @param newAddedList 新增的文件夹或应用列表
   * @param page 指定的页码，如果未指定，则使用默认页码
   */
  private updateFileFolderItemLayoutInfo(item: GridLayoutItemInfo, newAddedList: GridLayoutItemInfo[], page?: number): void {
    let pageInfo: PageInfo = this.getPageInfo(page);
    let startPageIndex = pageInfo.startPageIndex;
    let pageCount = pageInfo.pageCount;
    const layoutDescription: LayoutDescription = this.mLauncherLayoutCacheManager.selectLayoutDescription();
    const isPad = this.getDevice();
    const first = this.getRowOrColumn(layoutDescription, isPad);
    const second = this.getRowOrColumn(layoutDescription, !isPad);
    log.showInfo(TAG, `pageIndex:${this.mPageIndex}`);
    let isNeedNewPage = true;
    let startInfo: StartInfo = this.getStartCoordinates(item);
    let startColumn = startInfo.startColumn;
    let startRow = startInfo.startRow;

    const pageCycleCallback = (i: number, startColumn: number, startRow: number, isPad: boolean, first: number, second: number): boolean => {
      for (let y = startColumn; y < first; y++) {
        if (y > startColumn) {
          startRow = 0;
        }
        for (let x = startRow; x < second; x++) {
          const positionX = isPad ? y : x;
          const positionY = isPad ? x : y;
          if (this.processPositionValid(item, i, positionX, positionY, isPad, newAddedList, pageCount)) {
            isNeedNewPage = false;
            return true;
          }
        }
      }
      return false;
    };

    pageCycle: for (let i = startPageIndex; i < pageCount; i++) {
      if (pageCycleCallback(i, startColumn, startRow, isPad, first, second)) {
        break pageCycle;
      }
      startRow = item?.row ?? 0;
      for (let y = startColumn; y >= 0; y--) {
        if (y < startColumn) {
          startRow = second;
        }
        for (let x = startRow; x >= 0; x--) {
          const positionX = isPad ? y : x;
          const positionY = isPad ? x : y;
          if (this.processPositionValid(item, i, positionX, positionY, isPad, newAddedList, pageCount)) {
            isNeedNewPage = false;
            break pageCycle;
          }
        }
      }
    }
    if (isNeedNewPage) {
      this.handleNewPage(item, pageCount, layoutDescription);
    }
  }

  private processPositionValid(item: GridLayoutItemInfo, i: number, positionX: number, positionY: number, isPad: boolean,
    newAddedList: GridLayoutItemInfo[], pageCount: number): boolean {
    if (this.mLauncherLayoutCacheManager.isPositionValid(item, i, positionX, positionY)) {
      log.showInfo(TAG, `updateFileFolderItemLayoutInfo isPositionValid: x:${positionX} y: ${positionY} page: ${i}`);
      item.page = i;
      item.column = positionX;
      item.row = positionY;
      if (this.mLauncherLayoutCacheManager.insertGridLayoutItemInfo(item, BusinessType.BUSINESS_BASIC_DESKTOP, false, undefined, this.singleContext)) {
        newAddedList.push(item);
      }
      return true;
    } else {
      log.showInfo(TAG, 'updateFileFolderItemLayoutInfo position invalid');
      return false;
    }
  }

  private handleNewPage(item: GridLayoutItemInfo, pageCount: number, layoutDescription: LayoutDescription): void {
    if (pageCount >= layoutDescription.maxPage) {
      return;
    }
    item.page = pageCount;
    item.column = 0;
    item.row = 0;
    this.mLauncherLayoutCacheManager.insertGridLayoutItemInfo(item, BusinessType.BUSINESS_BASIC_DESKTOP, false, undefined, this.singleContext);
    this.mLauncherLayoutCacheManager.updatePageCount(pageCount + 1, BusinessType.BUSINESS_BASIC_DESKTOP, true);
  }

  /**
   * 卡片加桌时获取页码信息
   */
  private getPagesWhenAddCard(): number[] {
    if (this.isBigScreen && this.keyBoardStatus !== FeatureConstants.NO_KEYBOARD) {
      return [this.keyBoardStatus, this.keyBoardStatus];
    }
    let lockedPageNum: number =
      layoutLockUtil.isLocked('get startPage when add card') ?
        layoutLockUtil.getLockedPageNum(launcherStatusUtil.getShowOutLauncherStatus()) : 0;
    let pageNum: number = GridLayoutUtil.isLargeFoldExpanded() ? 2 : 1;
    // [0]为找位起始页；当前显示页为预置页时，从非预置页开始找位
    // [1]为当前显示页；为便于逻辑统一，当前显示页为预置页时，强制指定当前页为预置页最后一页
    log.showInfo(TAG, `getPagesWhenAddCard mTargetIndex: ${this.mTargetIndex}, lockedPageNum: ${lockedPageNum}, pageNum: ${pageNum}`);
    return [Math.max(this.mTargetIndex, lockedPageNum), Math.max(this.mTargetIndex, lockedPageNum - pageNum)];
  }

  private getCardItemLayoutInfo(cardItemInfo: CardItemInfo): boolean {
    let foldOpen: boolean = desktopUtil.isFoldExpandStatus() || this.isBigScreen;
    let pageInfoManager: PageInfoManager = PageInfoManager.getInstance();
    // 是否是三屏状态
    const displayCount: number = pageInfoManager.getDisplayCount();
    const isThreeScreen: boolean = displayCount === StyleConstants.DEFAULT_3;
    // 折叠屏展开态情况下，当前屏左屏开始搜索4页; 其他场景搜索2页
    let searchPageCount: number = foldOpen ? 4 : 2;
    searchPageCount = isThreeScreen ? displayCount * 2 : searchPageCount;
    // 展开态场景下，需要翻页时，页面索引差值至少为2
    let pageStep: number = foldOpen ? 2 : 1;
    pageStep = isThreeScreen ? displayCount : pageStep;
    let pages: number[] = this.getPagesWhenAddCard();
    let position: PageColumnInfo | null =
      this.getEnoughAreaPosition(pages[0], cardItemInfo.area ?? [], searchPageCount);
    if (!position) {
      if (!foldOpen) {
        cardItemInfo.page = pages[1] + 1;
      } else {
        let pageCount: number = this.mLauncherLayoutCacheManager.selectPageCount();
        // 折叠屏展开态情况下，最后一屏如果只有左屏，当前不会自动补右屏的空页，这种场景只需要新建一页
        cardItemInfo.page = ((pageCount % 2 !== 0) && (pages[1] >= pageCount - 3)) ?
          pageCount : pages[1] + 2;
        if (isThreeScreen) {
          cardItemInfo.page = pages[1] + displayCount;
        }
      }
      cardItemInfo.row = 0;
      cardItemInfo.column = 0;
      log.showInfo(TAG, `current needNewPage, page: ${cardItemInfo.page}`);
      return true;
    }
    log.showInfo(TAG, `get pageIndex: ${position.pageIndex}, row: ${position.row}, column: ${position.column}, this.mPageIndex: ${this.mPageIndex}, area: ${cardItemInfo.area}`);
    if ((position.pageIndex - this.mPageIndex) >= pageStep) {
      this.changeSwiperIndex(position.pageIndex);
    }
    cardItemInfo.page = position.pageIndex;
    cardItemInfo.row = position.row;
    cardItemInfo.column = position.column;
    return false;
  }

  private insertNewUpdateAppForPc(items: GridLayoutItemInfo[]): void {
    let isNeedRefreshDesktop = false;
    for (let i = 0; i < items.length; i++) {
      let item = items[i];
      if (this.mLauncherLayoutCacheManager.updateOneAppLayoutInfo(item, BusinessType.BUSINESS_BASIC_DESKTOP, true)) {
        isNeedRefreshDesktop = true;
      }
    }
    if (isNeedRefreshDesktop) {
      this.lightPagingFiltering(true, SceneMsgEnum.SCENE_MSG_INSERT_NEW_UPDATE_APP);
    }
  }

  public async insertNewUpdateApp(items: GridLayoutItemInfo[]): Promise<void> {
    let isNeedRefreshDesktop = false;
    for (let i = 0; i < items.length; i++) {
      let item = items[i];
      log.showInfo(TAG, 'insertNewUpdateApp, bundleName is %{public}s; keyName %{public}s', item.bundleName, item.keyName);
      if (this.mLauncherLayoutCacheManager.updateOneAppLayoutInfo(item, BusinessType.BUSINESS_BASIC_DESKTOP, true,
        false)) {
        isNeedRefreshDesktop = true;
        continue;
      }
      let relationNamesMap: Map<string, number> = new Map();
      relationNamesMap.set(item.bundleName + item.appIndex, 0);
      if (item.oldBundleNames && !CheckEmptyUtils.isEmptyArr(item.oldBundleNames)) {
        log.showInfo(TAG, 'insertNewUpdateApp install app oldBundleNames = %{public}s', item.oldBundleNames.join(','));
        // 这里只取第一个，打印一下包名信息，如果传递多个桌面涉及到删除其他应用的情况比较复杂，应用市场暂无该场景，只打印日志
        relationNamesMap.set(item.oldBundleNames[0] + item.appIndex, 1);
      }
      let residentList: DockItemInfo[] = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
      let appInDockIndex: number = residentList.findIndex(dockItem => relationNamesMap.has(dockItem.bundleName + dockItem.appIndex));
      let isFindInDock: boolean = false;
      if (appInDockIndex !== -1) {
        isFindInDock = true;
      } else {
        residentList.forEach((dockItem, index) => {
          if (dockItem.typeId === CommonConstants.TYPE_FOLDER) {
            let inFolderIndex: number =
              dockItem.layoutInfo?.flat().findIndex(itemInFolder => relationNamesMap.has(itemInFolder.bundleName + itemInFolder.appIndex)) ?? -1;
            if (inFolderIndex !== -1) {
              isFindInDock = true;
            }
          }
        });
      }
      if (!isFindInDock) {
        if (item.appStatus !== AppStatus.INSTALLED) {
          this.mInstallingItem.push(item); // 存储下载中应用，用于普通桌面与简易桌面切换
        }
        if (item.appStatus === AppStatus.UPDATING || item.appStatus === AppStatus.INSTALLED) {
          isNeedRefreshDesktop = true;
        } else {
          isNeedRefreshDesktop = this.updateAppItemLayoutInfo(item, false);
        }
      }
    }
    if (launcherStatusUtil.getShowOutLauncherStatus()) {
      this.refreshScreen(SceneMsgEnum.SCENE_MSG_INSERT_NEW_UPDATE_APP);
    } else if (isNeedRefreshDesktop) {
      this.lightPagingFiltering(true, SceneMsgEnum.SCENE_MSG_INSERT_NEW_UPDATE_APP);
    }
  }

  private checkToRemoveInvalidCards(itemList: GridLayoutItemInfo[]): void {
    log.showInfo(TAG, `checkToRemoveInvalidCards length: ${itemList.length}`);
    let deleteList: GridLayoutItemInfo[] = [];
    for (let i = itemList.length - 1; i >= 0; i--) {
      let item: GridLayoutItemInfo = itemList[i];
      if (item.typeId === CommonConstants.TYPE_CARD && CheckEmptyUtils.checkStrIsEmpty(item.cardId)) {
        log.showWarn(TAG, 'checkToRemoveInvalidCards id=%{public}d, bundle=%{public}s, ability=%{public}s, ' +
          'formName=%{public}s, page=%{public}d, col=%{public}d, row=%{public}d', item.id, item.bundleName,
          item.abilityName, item.cardName, item.page, item.column, item.row);
        deleteList.push(item);
        itemList.splice(i, 1);
      }
    }
    log.showInfo(TAG, TAG, `checkToRemoveInvalidCards deleteList: ${deleteList.length}, last: ${itemList.length}`);
    if (!CheckEmptyUtils.isEmptyArr(deleteList)) {
      LauncherLayoutCacheUtil.deleteLayoutInfoById(deleteList);
    }
  }

  /**
   * 批量更新应用位置信息
   *
   * @param itemList 找位更新的应用列表 bms获取的应用信息 | 构建的网格对象
   * @param batchUninstall 是否批量卸载场景，如果true则定制应用不回定制文件夹，如果缺失或false则走原来逻辑回定制文件夹
   * @param isOuter 是否是外屏
   */
  public batchUpdateAppItemLayoutInfo(itemList: GridLayoutItemInfo[], batchUninstall?: boolean,
    isOuter?: boolean): void {
    if (CheckEmptyUtils.isEmptyArr(itemList)) {
      return;
    }
    let pageCount: number = this.mLauncherLayoutCacheManager.selectPageCount(isOuter);
    let layoutDescription: LayoutDescription = this.mLauncherLayoutCacheManager.selectLayoutDescription(isOuter);
    let maxRow: number = layoutDescription.row;
    let maxCol: number = layoutDescription.column;
    let maxPage: number = layoutDescription.maxPage;
    let homePageIndex: number = PageInfoManager.getInstance().getHomePageIndex();
    // 基于主屏开始找位，先确定找位的起始页
    let startFindPage: number = scbBlankPositionUtils.getStartFindPageByHomePage(maxPage, isOuter);
    let itemLocation: ItemLocation = PageDesktopViewModelUtils.getStartFindItemLocation(startFindPage, 0, 0);
    let locationItemList: GridLayoutItemInfo[] = [];
    let isRetailEnable: boolean = false;
    try {
      isRetailEnable = systemParameterEnhance.getSync('const.dfx.enable_retail', 'false') === 'true';
    } catch (err) {
      log.showError(TAG, 'systemParameterEnhance error %{public}d: %{public}s', err.code, err.message);
    }
    log.showInfo(TAG, 'patchUpdateAppItemLayoutInfo pageCount: %{public}d maxPage: %{public}d, maxCol: %{public}d,' +
      ' maxRow: %{public}d startFindPage: %{public}d', pageCount, maxPage, maxCol, maxRow, startFindPage);
    let itemOverMaxPageList: GridLayoutItemInfo[] = [];
    let folderItem: GridLayoutItemInfo | undefined = FolderLayoutCacheManager.getInstance()
      .selectGridLayoutItemByFolderId(CommonConstants.PRESET_OpenHarmony_FOLDER_ID);
    for (const item of itemList) {
      log.showInfo(TAG, `newApp: ${item.bundleName} keyname: ${item.keyName}`);
      let isContactShortcut: boolean = ContactCacheManager.getInstance().isContactShortcut(item);
      if (isContactShortcut && folderItem) {
        FolderLayoutCacheManager.getInstance().insertAppItemToFolderLastItemByFolderId(folderItem.folderId,
          item, BusinessType.BUSINESS_BASIC_DESKTOP, true);
        continue;
      }
      // 已完成一轮找位后，还没有落位的图标放到 overMaxPageList中
      if (itemLocation.curPage - homePageIndex > maxPage) {
        itemOverMaxPageList.push(item);
        continue;
      }
      // 当前最后一屏新建页情况直接遍历赋值找位
      if (itemLocation.curPage >= pageCount && itemLocation.curPage < maxPage) {
        this.dealWithNewPageToPushElement(maxRow, maxCol, itemLocation, item, locationItemList);
        continue;
      }

      // 从已有页数空位找位放置true需要循环遍历继续找位，false已经找位成功
      let isNeedFindPosition: boolean = true;
      while (isNeedFindPosition) {
        // 如果已循环找位了一轮，则添加到 overMaxPageList中
        if (itemLocation.curPage - homePageIndex > maxPage) {
          itemOverMaxPageList.push(item);
          isNeedFindPosition = true;
          break;
        }
        // 当前最后一屏新建页直接变量赋值找位
        if (itemLocation.curPage >= pageCount && itemLocation.curPage < maxPage) {
          this.dealWithNewPageToPushElement(maxRow, maxCol, itemLocation, item, locationItemList);
          isNeedFindPosition = true;
          break;
        }
        isNeedFindPosition = !this.viewModelUtils.findBlankPositionFromOnePage(maxRow, maxCol, maxPage, item, itemLocation);
      }
      if (!isNeedFindPosition) {
        let realPageIndex = itemLocation.findPage % maxPage;
        let newItem: GridLayoutItemInfo = (item.typeId === CommonConstants.TYPE_APP) ?
          this.viewModelUtils.buildGridLayoutInfoFromItemInfo(item, realPageIndex, itemLocation.findCol, itemLocation.findRow) :
          PageDesktopViewModelUtils.updateGridLayoutInfoPosition(item, realPageIndex, itemLocation.findCol, itemLocation.findRow);
        newItem.container = CommonConstants.CONTAINER_DESKTOP;
        newItem.areaType = CommonConstants.TYPE_AREA_DESKTOP;
        locationItemList.push(newItem);
        this.checkToRemoveOverMaxPageItem(item.bundleName);
      }
    }
    if (!CheckEmptyUtils.isEmptyArr(locationItemList)) {
      this.checkToRemoveInvalidCards(locationItemList);
      this.mLauncherLayoutCacheManager.insertGridLayoutItemList(locationItemList, BusinessType.BUSINESS_BASIC_DESKTOP,
        true, isOuter);
      let curPage: number = this.mLauncherLayoutCacheManager.selectPageCount(isOuter);
      this.mLauncherLayoutCacheManager.updatePageCount(Math.max(itemLocation.findPage % maxPage + 1, curPage),
        BusinessType.BUSINESS_BASIC_DESKTOP, true, isOuter);
    }
    if (!CheckEmptyUtils.isEmptyArr(itemOverMaxPageList)) {
      this.dealItemListWithOverMaxPage(itemOverMaxPageList, maxPage, startFindPage);
    }
  }

  private dealWithNewPageToPushElement(maxRow: number, maxCol: number, itemLocation: ItemLocation,
    item: GridLayoutItemInfo, locationItemList: GridLayoutItemInfo[]): void {
    let layoutDescription: LayoutDescription = this.mLauncherLayoutCacheManager.selectLayoutDescription();
    let maxPage: number = layoutDescription.maxPage;
    this.viewModelUtils.findBlankPositionWithoutVerify(maxRow, maxCol, itemLocation);
    let realPageIndex = itemLocation.findPage % maxPage;
    let newItem: GridLayoutItemInfo = (item.typeId === CommonConstants.TYPE_APP) ?
      this.viewModelUtils.buildGridLayoutInfoFromItemInfo(item, realPageIndex, itemLocation.findCol, itemLocation.findRow) :
      PageDesktopViewModelUtils.updateGridLayoutInfoPosition(item, realPageIndex, itemLocation.findCol, itemLocation.findRow);
    this.checkToRemoveOverMaxPageItem(item.bundleName);
    locationItemList.push(newItem);
  }

  private checkToRemoveOverMaxPageItem(bundleName: string): void {
    if (this.overMaxPageItems.has(bundleName)) {
      this.overMaxPageItems.delete(bundleName);
    }
  }

  /**
   * 创建未OpenHarmony化文件夹时设置标志位，防止多批克隆应用接收时未OpenHarmony化文件夹还没创建完成
   *
   * @param isMakingFolder true正在创建文件夹，false未创建文件夹
   */
  public setIsMakingFolder(isMakingFolder: boolean): void {
    this.isMakingFolder = isMakingFolder;
    if (!this.isMakingFolder) {
      this.insertNewUpdateApp(this.newUpdateAppList);
      this.newUpdateAppList = [];
    }
  }

  /**
   * 更新应用位置信息
   *
   * @param item appItemInfo|gridLayoutInfo bms获取的应用信息 | 构建的网格对象
   * @returns 是否需要刷新桌面
   */
  public updateAppItemLayoutInfo(item: GridLayoutItemInfo | AppItemInfo, isOuter?: boolean): boolean {
    if (item.appStatus !== AppStatus.INSTALLED) {
      let tmpInfo = AppModel.getInstance().getAppInfoByBundleName(item.bundleName);
      if (item.appStatus === AppStatus.WAIT_FOR_HARMONY && !CheckEmptyUtils.isEmpty(tmpInfo)) {
        log.showWarn(TAG, `updateAppItemLayoutInfo ${item.bundleName} is exist`);
        return false;
      }
    }
    const uiType:ESObject = SCBWindowSceneConfig.getInstance().windowSceneConfig?.uiType;
    if (uiType === SCBConstants.UITYPE_PC &&
    this.mLauncherLayoutCacheManager.isAddAppOverMaxPage(this.mSettingsModel.getGridConfig())
    ) {
      log.showInfo(TAG, 'show toast add shortcut to desktop max');
      Prompt.showToast({
        message: this.mResourceManager.getStringByName('add_icon_to_desktop_max'),
        bottom: this.getToastBottom()
      });
      return false;
    }
    let pageCount: number = this.mLauncherLayoutCacheManager.selectPageCount(isOuter);
    let layoutDescription: LayoutDescription = this.mLauncherLayoutCacheManager.selectLayoutDescription(isOuter);
    let endFindPage: number = layoutLockUtil.isLocked() ? layoutDescription.maxPage : pageCount;
    let first: number;
    let second: number;
    let isPad = this.getDevice();
    if (isPad) {
      first = layoutDescription.column;
      second = layoutDescription.row;
    } else {
      first = layoutDescription.row;
      second = layoutDescription.column;
    }
    let startFindPage: number = scbBlankPositionUtils.getFindBlankStartPage(layoutDescription.maxPage, isOuter);
    if (isPad) {
      // 从第二屏开始查找空白位置
      for (let i = startFindPage; i < endFindPage; i++) {
        if (this.findBlankPosition(first, second, isPad, i, item as GridLayoutItemInfo, isOuter)) {
          if (this.overMaxPageItems.has(item.bundleName)) {
            log.showInfo(TAG, `updateAppItemLayoutInfo, overMaxPageItems delete bundleName: ${item.bundleName}, typeId: ${item.typeId}`);
            this.overMaxPageItems.delete(item.bundleName);
          }
          return true;
        }
      }
      // 大折叠如果只有一屏元素，新增元素也从第三屏开始创建
      pageCount = DeviceHelper.isFoldButNotSmallFoldAndSingleDisplay() && (pageCount < START_FIND_POSITION_BIG_FOLD) ?
        START_FIND_POSITION_BIG_FOLD : pageCount;
    } else {
      startFindPage = scbBlankPositionUtils.getStartFindPageByHomePage(layoutDescription.maxPage, isOuter);
      let desktopPosition: DesktopPosition = scbBlankPositionUtils.findBlankPosition(isOuter, item.bundleName);
      //如果有空位，则更新item的位置信息。
      if (desktopPosition.isFind) {
        if (this.overMaxPageItems.has(item.bundleName)) {
          log.showInfo(TAG,
            `updateAppItemLayoutInfo, overMaxPageItems delete bundleName: ${item.bundleName}, typeId: ${item.typeId}`);
          this.overMaxPageItems.delete(item.bundleName);
        }
        let realPage = desktopPosition.page;
        let column = desktopPosition.column;
        let row = desktopPosition.row;
        let gridlayoutItem: GridLayoutItemInfo = (item.typeId === CommonConstants.TYPE_APP) ?
          this.viewModelUtils.buildGridLayoutInfoFromItemInfo(item, realPage, column, row)
          : PageDesktopViewModelUtils.updateGridLayoutInfoPosition(item as GridLayoutItemInfo, realPage, column, row);
        LaunchLayoutCacheManager.getInstance()
          .insertGridLayoutItemInfo(gridlayoutItem, BusinessType.BUSINESS_APP_INSTALL, true, false);
        return true;
      }
    }
    log.showInfo(TAG, `findBlankPosition pageCount:${pageCount}, bundlerName: ${item.bundleName} add new page`);
    let addPage = this.checkPageAndInsertGridLayout(item as GridLayoutItemInfo, pageCount,
      layoutDescription, startFindPage, isOuter);
    return addPage !== layoutDescription.maxPage;
  }

  /**
   * 新建页面插入应用
   *
   * @param item appItemInfo|gridLayoutInfo bms获取的应用信息 | 构建的网格对象
   * @param pageCount新建页面值
   * @param layoutDescription 布局描述
   * @returns 找到空位返回插入的空白页；如果超过最大屏无空位需要合入文件夹，则返回最大页面数
   */
  private checkPageAndInsertGridLayout(item: GridLayoutItemInfo, pageCount: number, layoutDescription: LayoutDescription,
    startFindPage: number, isOuter?: boolean): number {
    let gridlayoutItem: GridLayoutItemInfo =
      (item.typeId === CommonConstants.TYPE_APP) ? this.viewModelUtils.buildGridLayoutInfoFromItemInfo(item,
        pageCount, 0, 0) : PageDesktopViewModelUtils.updateGridLayoutInfoPosition(item, pageCount, 0, 0);
    if (pageCount < layoutDescription.maxPage) {
      if (this.overMaxPageItems.has(item.bundleName)) {
        log.showInfo(TAG, `addNewPage, overMaxPageItems delete bundleName: ${item.bundleName}, typeId: ${item.typeId}`);
        this.overMaxPageItems.delete(item.bundleName);
      }
      this.mLauncherLayoutCacheManager.insertGridLayoutItemInfo(gridlayoutItem, BusinessType.BUSINESS_BASIC_DESKTOP,
        true, isOuter);
      this.mLauncherLayoutCacheManager.updatePageCount(layoutDescription.pageCount + 1,
        BusinessType.BUSINESS_BASIC_DESKTOP, true);
      return layoutDescription.pageCount + 1;
    } else {
      return this.dealWithOverMaxPage(item, layoutDescription, startFindPage);
    }
  }

  private dealItemListWithOverMaxPage(itemList: GridLayoutItemInfo[], maxPage: number, startFindPage: number): void {
    if (!this.mIsFinishedInitLayout) {
      log.showWarn(TAG, 'InitLayout not finished');
      this.addAppWhenMaxPage(itemList, startFindPage);
      return;
    }
    let newOverMaxPageItems: GridLayoutItemInfo[] = itemList.filter(item => !this.overMaxPageItems.has(item.bundleName));
    if (CheckEmptyUtils.isEmptyArr(newOverMaxPageItems)) {
      return;
    }
    log.showInfo(TAG, 'overMaxPageList add size %{public}d, filterSize %{public}d', itemList.length, newOverMaxPageItems.length);
    let isAdd = this.addAppWhenMaxPage(newOverMaxPageItems, startFindPage);
    if (!isAdd) {
      // 开机的时候不弹，第一次添加到19屏的时候才弹
      this.showNoSpaceToast();
      itemList.forEach((item: GridLayoutItemInfo) => {
        this.overMaxPageItems.add(item.bundleName);
      });
    }
  }

  public showNoSpaceToast(isDefaultStyle?: boolean): void {
    if (isDefaultStyle) {
      Prompt.showToast({
        message: this.mResourceManager.getStringByName('add_icon_to_desktop_max'),
      });
    } else {
      Prompt.showToast({
        message: this.mResourceManager.getStringByName('add_icon_to_desktop_max'),
        bottom: this.getToastBottom()
      });
    }
  }

  private dealWithOverMaxPage(item: GridLayoutItemInfo, layoutDescription: LayoutDescription, startFindPage: number): number {
    if (!this.mIsFinishedInitLayout) {
      log.showWarn(TAG, 'InitLayout not finished');
      this.addAppWhenMaxPage([item], startFindPage);
      return NumberConstants.CONSTANT_NUMBER_ZERO;
    }
    if (this.overMaxPageItems.has(item.bundleName)) {
      log.showInfo(TAG, 'overMaxPageItems has item %{public}s', item.bundleName);
      return NumberConstants.CONSTANT_NUMBER_ZERO;
    }
    let isAdd = this.addAppWhenMaxPage([item], startFindPage);
    if (!isAdd) {
      // 开机的时候不弹，第一次添加到19屏的时候才弹
      this.showNoSpaceToast();
      this.overMaxPageItems.add(item.bundleName);
    }
    return layoutDescription.maxPage;
  }

  // 检查当前页是不是有空余位置
  private findBlankPosition(first: number, second:number, isPad: boolean, page: number, item: GridLayoutItemInfo,
    isOuter?: boolean): boolean {
    let rowOffset : number = 0;
    if (DeviceHelper.isPad() && (page === 0)) {
      rowOffset = ROW_OFFSET_THREE;
    }

    for (let y = rowOffset; y < first; y++) {
      for (let x = 0; x < second; x++) {
        let positionX = isPad ? y : x;
        let positionY = isPad ? x : y;
        if (this.mLauncherLayoutCacheManager.isPositionValid(item, page, positionX, positionY, isOuter)) {
          log.showInfo(TAG, `updateAppItemLayoutInfo isPositionValid: x:${positionX} y:${positionY}`);
          if (!AppStorage.get('openFolderStatus') || AppStorage.get('openFolderStatus') === 0) {
            RdbStoreManager.getInstance().isElementExistInGridLayout(item.bundleName, item.abilityName,
              item.moduleName, item.appIndex, item.shortcutId, isOuter).then((flag) => {
              if (flag && (DeviceHelper.isPhone() || DeviceHelper.isPad())) {
                log.showWarn(TAG, `updateAppItemLayoutInfo: this item: ${item.keyName} is exist in gridLayout!`);
              } else {
                this.changeIndex(page);
              }
            });
          }

          let gridlayoutItem: GridLayoutItemInfo = (item.typeId === CommonConstants.TYPE_APP) ?
            this.viewModelUtils.buildGridLayoutInfoFromItemInfo(item, page, positionX, positionY) :
            PageDesktopViewModelUtils.updateGridLayoutInfoPosition(item, page, positionX, positionY);
          this.mLauncherLayoutCacheManager.insertGridLayoutItemInfo(gridlayoutItem,
            BusinessType.BUSINESS_BASIC_DESKTOP, true, isOuter);
          log.showInfo(TAG, `findBlankPosition page:${page}, bundlerName: ${item?.keyName} result: true`);
          return true;
        }
      }
    }
    log.showInfo(TAG, `findBlankPosition page:${page}, bundlerName: ${item.keyName} result: false`);
    return false;
  }

  /**
   * 满18屏后新增应用
   * @param addItem 新增的应用
   * @param startFindPage 开始找位起始页
   */
  public addAppWhenMaxPage(addItem: GridLayoutItemInfo[], startFindPage: number): boolean {
    let pageCount = LaunchLayoutCacheManager.getInstance().selectPageCount();
    log.showInfo(TAG, 'addAppWhenMaxPage addItemLen: %{public}d, startFindPage %{public}d, pageCount %{public}d',
      addItem.length, startFindPage, pageCount);
    for (let i = startFindPage; i < startFindPage + pageCount; i++) {
      let pageIndex = i % pageCount;
      let pageGridItems = LaunchLayoutCacheManager.getInstance().selectGridLayoutItemsByPage(pageIndex);
      // 每页的数据按照行列排序
      let pageItems: GridLayoutItemInfo[] = pageGridItems.filter((itemInfo: GridLayoutItemInfo) => {
        return this.canAddApp(itemInfo);
      }).sort((a, b) => {
        return a.row === b.row ? (a.column ?? 0) - (b.column ?? 0) : (a.row ?? 0) - (b.row ?? 0);
      });
      if (this.createOrAdd2Folder(addItem, pageItems)) {
        return true;
      }
    }
    return false;
  }

  private canAddApp(itemInfo: GridLayoutItemInfo): boolean {
    if (CheckEmptyUtils.isEmpty(itemInfo) ||
    FolderViewModel.isFolderFull(itemInfo) || NotHarmonyUtil.isNotHarmonyFolderById(itemInfo.folderId)) {
      return false;
    }
    return true;
  }

  // 合并或加入文件夹
  private createOrAdd2Folder(addItem: GridLayoutItemInfo[], pageItems: GridLayoutItemInfo[]): boolean {
    for (const itemInfo of pageItems) {
      if (CheckEmptyUtils.isEmpty(itemInfo)) {
        continue;
      }
      if (itemInfo.typeId === CommonConstants.TYPE_APP) {
        // 与应用合成小文件夹
        this.createFolder(addItem, itemInfo);
        return true;
      } else if (itemInfo.typeId === CommonConstants.TYPE_FOLDER) {
        if (FolderViewModel.isFolderFull(itemInfo)) {
          log.showInfo(TAG, 'createOrAdd2Folder folder full');
          continue;
        }
        let allAdded: boolean = this.addToFolder(addItem, itemInfo);
        if (allAdded) {
          return true;
        }
      }
    }
    return false;
  }

  private createFolder(addItem: GridLayoutItemInfo[], itemInfo: GridLayoutItemInfo): void {
    const folder: GridLayoutItemInfo = ContractedFolderCommonViewModel.getInstance()
      .createNewFolder('over 18 screen', itemInfo, addItem);
    this.toastCreateOrAdd2Folder(addItem, folder, true);
  }

  private addToFolder(addItem: GridLayoutItemInfo[], itemInfo: GridLayoutItemInfo): boolean {
    let toAddItem: GridLayoutItemInfo[] = addItem;
    let allAdded: boolean = true;
    let appCount: number = FolderViewModel.getAppCountWithoutAdd(itemInfo.layoutInfo);
    let maxAppCount: number = FolderViewModel.getMaxAppCount();
    if (appCount + addItem.length > maxAppCount) {
      toAddItem = addItem.splice(0, maxAppCount - appCount);
      allAdded = false;
    }
    // 加入文件夹
    this.mFolderMgr.addItemsToFolder('desktop add', toAddItem, itemInfo.folderId, false);
    this.toastCreateOrAdd2Folder(addItem, itemInfo, false);
    return allAdded;
  }

  private updateShortcutCacheWhenAppUpdate(bundleName: string, appIndex: number = 0, isOuter?: boolean): void {
    // 从BMS获取快捷方式信息
    let shortcutInfoList: ShortcutInfo[] | undefined = this.mAppModel.getShortcutInfo(bundleName);
    if (!shortcutInfoList || CheckEmptyUtils.isEmptyArr(shortcutInfoList)) {
      log.showWarn(TAG, `The app ${bundleName} does not have static shortcut.`);
      // 兼容克隆场景，应用无拖拽加桌快捷方式，有应用内加桌快捷方式
      shortcutInfoList = [];
    }
    // 获取布局缓存中需要更新的快捷方式信息
    let shortcutCacheList: GridLayoutItemInfo[] = LaunchLayoutCacheManager.getInstance()
      .getShortcutInfoFromLayoutCache(bundleName, appIndex, shortcutInfoList, isOuter);
    if (CheckEmptyUtils.isEmptyArr(shortcutCacheList)) {
      log.showWarn(TAG, 'The app does not have a shortcut icon in the layout.');
      return;
    }

    shortcutCacheList.forEach(item => {
      RdbStoreManager.getInstance().updateGridInfo(item, isOuter);
    });
  }

  public updateFormCacheWhenAppUpdate(bundleName: string, isOuter?: boolean): void {
    let allFormsInfo: GridLayoutItemInfo[] = this.mFormModel.getAllFormsInfoFromLayout(isOuter);
    let formInCache: GridLayoutItemInfo[] = allFormsInfo.filter(item => item.bundleName === bundleName);
    log.showInfo(TAG, `forms in cache length: ${formInCache.length}, bundleName: ${bundleName}, isOuter: ${isOuter}`);

    let appInfo: AppItemInfo | undefined = this.mAppModel.getAppInfoByBundleName(bundleName) ??
    this.mAtomicServiceAppModel.getAtomicInfoByBundleName(bundleName);
    let newFormInfos: CardItemInfo[] | undefined = this.mFormModel.getAppItemFormInfo(bundleName);
    if (!appInfo || !newFormInfos || CheckEmptyUtils.isEmptyArr(newFormInfos)) {
      log.showError(TAG, `no bundle in formModel(${newFormInfos?.length}) or appModel(${CheckEmptyUtils.isEmpty(appInfo)})`);
      return;
    }

    for (let cacheItem of formInCache) {
      // 从AppModel更新appLabel信息
      cacheItem.appLabelId = appInfo.appLabelId;
      // 从FormModel更新其他卡片信息
      let newFormInfo: CardItemInfo = newFormInfos.filter(newItem => newItem.cardName === cacheItem.cardName)?.[0];
      if (CheckEmptyUtils.isEmpty(newFormInfo)) {
        log.showError(TAG, `not match in cache: ${cacheItem.cardName}!`);
        continue;
      }
      cacheItem.supportDimensions = newFormInfo.supportDimensions;
      cacheItem.formConfigAbility = newFormInfo.formConfigAbility;
      cacheItem.isTransparent = newFormInfo.isTransparent;
      cacheItem.gameCardInfo = newFormInfo.gameCardInfo;
      cacheItem.intent = newFormInfo.intent;
    }
    this.mLauncherLayoutCacheManager.updateFormsCacheInfoByFormList(formInCache, BusinessType.BUSINESS_CARD, isOuter);
  }

  private toastCreateOrAdd2Folder(addItems: GridLayoutItemInfo[], folderInfo: GridLayoutItemInfo,
    isCreate: boolean): void {
    if (!addItems || addItems.length === 0) {
      log.showWarn(TAG, 'toastCreateOrAdd2Folder addItems invalid');
      return;
    }
    if (!folderInfo || !folderInfo.layoutInfo || folderInfo.layoutInfo.length === 0 ||
      folderInfo.layoutInfo[0].length === 0) {
      log.showWarn(TAG, 'toastCreateOrAdd2Folder folderInfo invalid');
      return;
    }
    const folderName: string = FolderCommonUtil.getRealFolderName(folderInfo.folderName);
    let item: GridLayoutItemInfo = addItems[addItems.length - 1];
    let firstName: string = item.appName ?? '';
    if (CheckEmptyUtils.isEmpty(firstName)) {
      let firstKey: string = `${item.appLabelId}${item.bundleName}${item.moduleName}`;
      firstName = ResourceManager.getInstance().getAppResourceCache(firstKey, 'name') as string;
    }
    let secondItem: GridLayoutItemInfo = folderInfo.layoutInfo[0][0];
    if (CheckEmptyUtils.isEmpty(secondItem)) {
      log.showWarn(TAG, 'toastCreateOrAdd2Folder secondItem invalid');
      return;
    }
    let secondName: string = secondItem.appName ?? '';
    if (isCreate && CheckEmptyUtils.isEmpty(secondName)) {
      let secondKey: string = `${secondItem.appLabelId}${secondItem.bundleName}${secondItem.moduleName}`;
      secondName = ResourceManager.getInstance().getAppResourceCache(secondKey, 'name') as string;
    }
    try {
      Prompt.showToast({
        message: isCreate ?
          $r('app.string.folder_create_toast', firstName, secondName, folderName, (folderInfo.page ?? 0) + 1) :
          $r('app.string.folder_add_toast', firstName, folderName, (folderInfo.page ?? 0) + 1)
      });
    } catch (e) {
      log.showError(TAG, 'toastCreateOrAdd2Folder error.');
    }
  }

  /**
   * @param info 布局信息
   * @param layoutDescription 布局描述
   * @param item appItemInfo|gridLayoutInfo bms获取的应用信息 | 构建的网格对象
   * @param isDeliverApp false未OpenHarmony化文件夹
   * @returns true找位成功，false找位失败
   */
  public updateElementLocation(layoutDescription: LayoutDescription, item: GridLayoutItemInfo,
    isDeliverApp: boolean = true): boolean {
    let deliverAppShowOuter: boolean | undefined = isDeliverApp ? false : undefined;
    let startFindPage: number = 0;
    let pageCount: number = 0;
    let findPositionByHomePage: boolean = false;
    if (this.keyBoardStatus === FeatureConstants.NO_KEYBOARD) {
      pageCount = layoutDescription.pageCount;
      // 未OpenHarmony化文件夹从最后一屏找位
      if (!isDeliverApp) {
        startFindPage = pageCount - 1;
      } else {
        startFindPage = scbBlankPositionUtils.getStartFindPageByHomePage(layoutDescription.maxPage, deliverAppShowOuter);
        findPositionByHomePage = true;
      }
    } else {
      startFindPage = this.keyBoardStatus;
      pageCount = startFindPage + 1;
    }
    let first: number;
    let second: number;
    let isPad = this.getDevice();
    if (isPad) {
      first = layoutDescription.column;
      second = layoutDescription.row;
    } else {
      first = layoutDescription.row;
      second = layoutDescription.column;
    }
    if (!findPositionByHomePage) {
      for (let i = startFindPage; i < pageCount; i++) {
        if (this.findAndUpdatePosition(first, second, isPad, i, item, isDeliverApp)) {
          this.deleteOverMaxPageItems(item);
          return true;
        }
      }
    } else {
      for (let i = startFindPage; i < pageCount + layoutDescription.maxPage; i++) {
        if (this.findAndUpdatePosition(first, second, isPad, i % layoutDescription.maxPage, item, isDeliverApp)) {
          this.deleteOverMaxPageItems(item);
          return true;
        }
      }
    }
    pageCount = DeviceHelper.isFoldButNotSmallFoldProduct() && (pageCount < START_FIND_POSITION_BIG_FOLD) ?
      START_FIND_POSITION_BIG_FOLD : pageCount;
    log.showWarn(TAG, `updateElementLocation pageCount:${pageCount}, bundlerName: ${item.bundleName} add new page`);
    let gridlayoutItem: GridLayoutItemInfo = PageDesktopViewModelUtils.updateGridLayoutInfoPosition(item, pageCount, 0, 0);
    if (pageCount < layoutDescription.maxPage && !DeviceHelper.isPC()) {
      if (this.overMaxPageItems.has(item.bundleName)) {
        log.showWarn(TAG, `addBlankPage, overMaxPageItems delete bundleName: ${item.bundleName}, typeId: ${item.typeId}`);
        this.overMaxPageItems.delete(item.bundleName);
      }
      this.mLauncherLayoutCacheManager.insertGridLayoutItemAndUpdatePosition(gridlayoutItem, BusinessType.BUSINESS_BASIC_DESKTOP, true);
      this.mLauncherLayoutCacheManager.updatePageCount(pageCount + 1, BusinessType.BUSINESS_BASIC_DESKTOP, true,
        deliverAppShowOuter);
      return true;
    }
    return false;
  }

  private deleteOverMaxPageItems(item: GridLayoutItemInfo) {
    if (this.overMaxPageItems.has(item.bundleName)) {
      log.showWarn(TAG, `updateElementLocation, overMaxPageItems delete bundleName: ${item.bundleName}, typeId: ${item.typeId}`);
      this.overMaxPageItems.delete(item.bundleName);
    }
  }

  // 检查当前页是不是有空余位置
  private findAndUpdatePosition(first: number, second: number, isPad: boolean, page: number, item: GridLayoutItemInfo,
    isDeliverApp: boolean = true): boolean {
    let deliverAppShowOuter: boolean | undefined = isDeliverApp ? false : undefined;
    let rowOffset : number = 0;
    if (DeviceHelper.isPad() && (page === 0)) {
      rowOffset = ROW_OFFSET_THREE;
    }

    for (let y = rowOffset; y < first; y++) {
      for (let x = 0; x < second; x++) {
        let positionX = isPad ? y : x;
        let positionY = isPad ? x : y;
        if (this.mLauncherLayoutCacheManager.isPositionValid(item, page, positionX, positionY, deliverAppShowOuter)) {
          log.showInfo(TAG, `findAndUpdatePosition isPositionValid: x:${positionX} y:${positionY}`);
          let gridlayoutItem: GridLayoutItemInfo = PageDesktopViewModelUtils.updateGridLayoutInfoPosition(item, page, positionX, positionY);
          this.addToLayout(gridlayoutItem, isDeliverApp);
          log.showInfo(TAG, `findAndUpdatePosition page:${page}, bundlerName: ${item?.bundleName} result: true`);
          return true;
        }
      }
    }
    log.showInfo(TAG, `findAndUpdatePosition page:${page}, bundlerName: ${item.bundleName} result: false`);
    return false;
  }

  private addToLayout(gridLayoutItem: GridLayoutItemInfo, isDeliverApp: boolean = true): void {
    if (DeviceHelper.isPC()) {
      gridLayoutItem.container = CommonConstants.CONTAINER_DESKTOP;
      this.mLauncherLayoutCacheManager.insertGridLayoutItemInfo(gridLayoutItem, BusinessType.BUSINESS_BASIC_DESKTOP, true);
    } else {
      this.mLauncherLayoutCacheManager.insertGridLayoutItemAndUpdatePosition(gridLayoutItem, BusinessType.BUSINESS_BASIC_DESKTOP, true);
    }
  }

  /**
   * 设备是否桌面宫格和Dock区显示相同应用
   *
   * @param isSupport
   */
  public setIsSupportLayoutAndDockSameIcon(isSupport: boolean) {
    this.isSupportLayoutAndDockSameIcon = isSupport;
  }

  regroupDataAppListChange(callbackList: [], event: string, bundleName: string, appIndex?: number): void {
    this.updateFormCacheWhenAppUpdate(bundleName);
    // 快捷图标更新,仅解决桌面上快捷方式没有更新问题
    this.updateShortcutCacheWhenAppUpdate(bundleName, appIndex, false);
    log.showWarn(TAG, `regroupDataAppListChange, ${event}, ${bundleName} ${appIndex}, ${this.waitingForInstallAni}`);
    if (this.viewModelUtils.isBundleNameAppExistInDock(bundleName, appIndex) && !this.isSupportLayoutAndDockSameIcon) {
      // 解决应用在dock，快捷方式在宫格不刷新的问题
      this.lightPagingFiltering(true);
      log.showWarn(TAG, `regroupDataAppListChange current app ${bundleName} is exist in dock`);
      return;
    }
    if (event === EventConstants.EVENT_PACKAGE_ADDED || event === EventConstants.EVENT_PACKAGE_CHANGED) {
      if (!CheckEmptyUtils.isEmptyArr(this.mInstallingItem)) {
        this.mInstallingItem = this.mInstallingItem.filter(item => item.bundleName !== bundleName);
      }
      let downloadStatusInfo: DownloadStatusInfo | undefined = AppGalleryDownloadManager.getInstance().getDownDownloadTaskInfo(bundleName);
      this.updateNewInstalledGridInfo(bundleName, appIndex ?? 0);
      if (downloadStatusInfo && !appIndex) {
        this.registerInstalledAniFinishCallback(bundleName, appIndex ?? 0);
        AppGalleryDownloadManager.getInstance().deleteDownloadTaskInfo(bundleName);
        AppGalleryDownloadManager.getInstance().deleteDownloadProgressInfo(bundleName);
      } else {
        this.updateContainerAppNewInstalled(bundleName, appIndex ?? 0);
      }
    } else if (!this.waitingForInstallAni) {
      this.updateBMSChangedApp(bundleName, appIndex);
    }
  }

  private updateContainerAppNewInstalled(bundleName: string, appIndex: number): void {
    let appInfo: AppItemInfo | undefined = AppModel.getInstance().getAppInfoByBundleName(bundleName);
    this.updateBMSChangedApp(bundleName, appIndex);
  }

  private updateNewInstalledGridInfo(bundleName: string, appIndex: number): void {
    //更新新安装数据
    let newApp: AppItemInfo | undefined = AppModel.getInstance().getAppInfoByBundleInfo({
      bundleName: bundleName,
      appIndex: appIndex ?? 0
    });
    // isSupportShare存于intent中，isSupportShare在AG发送501事件时存入缓存，安装时从缓存中取出存入数据库
    const itemList: GridLayoutItemInfo[] =
      LaunchLayoutCacheManager.getInstance().getAllSameBundleNameAppItem(bundleName);
    let itemInfo: GridLayoutItemInfo | undefined;
    for (let i = 0; i < itemList.length; i++) {
      if (appIndex === itemList[i].appIndex) {
        itemInfo = itemList[i];
        log.showInfo(TAG, `Get intent of itemInfo, itemInfo: ${itemInfo?.bundleName}, ${itemInfo?.appIndex}, ${itemInfo?.intent}`);
        break;
      }
    }
    log.showInfo(TAG, `newApp: ${JSON.stringify(newApp)}`);
    if (newApp) {
      let originItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      originItem.bundleName = newApp.bundleName;
      originItem.appName = newApp.appName;
      originItem.applicationName = newApp.applicationName;
      originItem.applicationLabelId = newApp.applicationLabelId;
      originItem.appIconId = newApp.appIconId;
      originItem.appLabelId = newApp.appLabelId;
      originItem.isUninstallAble = newApp?.isUninstallAble;
      originItem.isSystemApp = newApp?.isSystemApp;
      originItem.installTime = newApp.installTime;
      originItem.moduleName = newApp.moduleName;
      originItem.abilityName = newApp.abilityName;
      originItem.keyName = newApp.keyName;
      originItem.appIndex = newApp.appIndex;
      originItem.appStatus = AppStatus.INSTALLED;
      originItem.intent = itemInfo?.intent;
      log.showInfo(TAG, `originItem.moduleName = ${originItem.moduleName}, originItem.abilityName = ${originItem.abilityName}`);
      RdbStoreManager.getInstance().updateNewInstalledGridInfo(originItem, false);
    }
  }

  private cancelDownloadTask(gridLayoutItemInfo: GridLayoutItemInfo): void {
    if (gridLayoutItemInfo.appStatus === AppStatus.WAIT_FOR_HARMONY) {
      let extendInfo: Map<string, Object> = CommonUtils.jsonStrToMap(gridLayoutItemInfo.intent);
      AppInstallUtils.getInstance().cancelTask(extendInfo?.get('requestBundleName') as string);
    }
  }

  private registerInstalledAniFinishCallback(bundleName: string, appIndex: number): void {
    this.waitingForInstallAni = true;
    const installAniFinishEvent: string = `desktopInstallAniFinish${bundleName}`;
    const eventHub: ctx.EventHub = (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext)?.eventHub;
    if (installAniFinishEvent) {
      eventHub.off(installAniFinishEvent);
      eventHub.on(installAniFinishEvent, async(): Promise<void> => {
        eventHub.off(installAniFinishEvent);
        if (this.waitingForInstallAni) {
          this.waitingForInstallAni = false;
          this.updateBMSChangedApp(bundleName, appIndex);
        }
      });
      let appGalleryEventInfo: AppGalleryEventInfo = {
        bundleName: bundleName,
        eventType: InstallStatusChangeEvent.INSTALL_STATUS_CHANGE,
        status: AppStatus.INSTALLED as number,
      };
      eventHub.emit(`appGalleryStatusChange${bundleName}${appIndex}appCenter`, appGalleryEventInfo);
      eventHub.emit(`appGalleryStatusChange${bundleName}${appIndex}icon`, appGalleryEventInfo);
      eventHub.emit(`appGalleryStatusChange${bundleName}${appIndex}name`, appGalleryEventInfo);
      eventHub.emit(`appGalleryStatusChange${bundleName}${appIndex}folder`, appGalleryEventInfo);
      eventHub.emit(`appGalleryStatusChange${bundleName}${appIndex}smallFolder`, appGalleryEventInfo);
      log.showInfo(TAG, `registerInstalledAniFinishCallback for ${installAniFinishEvent}`);

      this.waitingForInstallAni = false;
      this.updateBMSChangedApp(bundleName, appIndex);
    }
  }

  /**
   * The application uninstallation result is displayed.
   *
   * @param resultCode: Application uninstallation result
   */
  informUninstallResult(resultCode: number, bundleName?: string): void {
    log.showInfo(TAG, 'informUninstallResult resultCode = ' + resultCode + ',bundleName = ' + bundleName);
    if (resultCode === CommonConstants.UNINSTALL_FORBID) {
      Prompt.showToast({
        message: this.mResourceManager.getStringByName('disable_uninstall')
      });
    } else if (resultCode === CommonConstants.UNINSTALL_SUCCESS) {
      Prompt.showToast({
        message: this.mResourceManager.getStringByName('uninstall_success')
      });
    } else {
      Prompt.showToast({
        message: this.mResourceManager.getStringByName('uninstall_failed')
      });
    }
  }

  /**
   * Open the app.
   *
   * @param abilityName
   * @param bundleName
   */
  openApplication(abilityName?: string, bundleName?: string, moduleName?: string, appIndex?: number): void {
    this.startAppWithIndex(abilityName ?? '', bundleName ?? '', moduleName ?? '', appIndex);
  }

  /**
   * Open Settings.
   */
  intoSetting(): void {
    log.showInfo(TAG, 'intoSetting');
    this.jumpToSetting();
  }

  /**
   * Changing the Desktop Page Number.
   *
   * @param newPageIndex: Page number
   */
  public changeIndexOnly(newPageIndex: number | undefined): void {
    if (typeof newPageIndex === 'undefined') {
      log.showError(TAG, `newPageIndex is undefined, ${newPageIndex}`);
      return;
    }

    this.updatePageIndex(newPageIndex);
    this.notifyFormsPageChanged();
    this.desktopContext?.eventHub.emit(CommonConstants.DESKTOP_RECOVER_STATE);
  }

  private updatePageIndex(newPageIndex: number | undefined): void {
    log.showWarn(TAG, `update newPageIndex is ${newPageIndex}, oldPageIndex is ${this.mPageIndex}`);
    if (newPageIndex === undefined || this.mPageIndex === newPageIndex) {
      log.showInfo(TAG, `newPageIndex is the same to mPageIndex, ${newPageIndex}`);
      return;
    }
    this.mOldPageIndex = this.mPageIndex;
    this.mPageIndex = newPageIndex;
    this.mTargetIndex = this.mPageIndex;
  }

  public recycleFormEventHandler(state: boolean): void {
    formLog.showInfo(TAG, `current recycleFormEventHandler, state = ${state}, currentStartApp = ${this.currentStartApp}`);
    if (state) {
      // 如果已经处于全屏启动状态，如果没有触发退出全屏，不重复处理回收逻辑
      if (!this.currentStartApp) {
        this.currentStartApp = true;
        if (this.isScreenLock) {
          formLog.showWarn(TAG, 'screen lock, do not handle recycle');
          return;
        }
        this.formRecycleWhenAppStartHandler(this.mPageIndex);
      }
    } else {
      if (this.currentStartApp) {
        this.currentStartApp = false;
        if (this.isScreenLock) {
          formLog.showWarn(TAG, 'screen lock, do not handle recover');
          return;
        }
        this.formRecoverWhenAppExitHandler(this.mPageIndex);
      }
    }
  }

  private formRecycleWhenAppStartHandler(pageIndex: number): void {
    this.startInvisibleTimer = setTimeout(() => {
      this.startInvisibleTimer = INVALID_TIMER;
      this.notifyFormsVisibilityOfPage(pageIndex, false);

      let allFormLayoutInfo: GridLayoutItemInfo[] = this.mFormModel.getAllFormsInfoFromLayout();
      this.handleRecycleFormsTimer(allFormLayoutInfo);
    }, INVISIBLE_DELAY_TIMER_WHEN_START_APP);
  }

  private handleRecycleFormsTimer(allFormLayoutInfo: GridLayoutItemInfo[]): void {
    if (this.startRecycleTimer !== INVALID_TIMER) {
      log.showWarn(TAG, `current is in recycle delay timer, not repeat`);
      return;
    }
    if (allFormLayoutInfo.length <= CARD_RECYCLE_LIMIT) {
      log.showWarn(TAG, 'cards num not reach limit, no need to recycle');
      return;
    }

    this.startRecycleTimer = setTimeout(() => {
      this.startRecycleTimer = INVALID_TIMER;
      let supportRecycleForm: boolean = this.gameEventListener.isSupportRecycleForm();
      if (!supportRecycleForm) {
        log.showInfo(TAG, 'gaming, not handle recover');
        return;
      }

      let allFormList: string[] = [];
      for (const item of allFormLayoutInfo) {
        // 三合一卡片不做回收
        if (this.isThreeInOneCard(item) && !this.isStaticMemoryScene()) {
          continue;
        }
        allFormList.push(item.cardId ?? '');
      }

      log.showInfo(TAG, `formHostNotifyToRecycle start, recycle_formIds: ${allFormList.toString()}`);
      this.mFormHostService.formHostNotifyToRecycle(allFormList);
    }, RECYCLE_DELAY_TIMER_WHEN_START_APP);
    log.showInfo(TAG, `handle app start, start form recycle timerId: ${this.startRecycleTimer}`);
  }

  private isStaticMemoryScene(): boolean {
    // return MemoryUtils.isMemoryScene() && MemoryManager.getInstance().checkIsStaticMemoryScene();
    return false;
  }

  private formRecoverWhenAppExitHandler(pageIndex: number): void {
    if (this.startInvisibleTimer !== INVALID_TIMER) {
      formLog.showInfo(TAG, `handle app exit, clear invisible timerId: ${this.startInvisibleTimer}`);
      clearTimeout(this.startInvisibleTimer);
      this.startInvisibleTimer = INVALID_TIMER;
    }

    if (this.startRecycleTimer !== INVALID_TIMER) {
      formLog.showInfo(TAG, `handle app exit, clear recycle timerId: ${this.startRecycleTimer}`);
      clearTimeout(this.startRecycleTimer);
      this.startRecycleTimer = INVALID_TIMER;
    }

    formLog.showInfo(TAG, `handle app exit, start form recover, pageIndex: ${pageIndex}`);
    this.freshCurPageVisibility(true);
    this.recoverFormsOfNeighborPage(pageIndex);
  }

  /**
   * 刷新当前页面卡片的可见性
   *
   * @param isVisible 是否可见
   */
  private freshCurPageVisibility(isVisible: boolean, isNeedFilter: boolean = true, isDelay: boolean = true): void {
    if (typeof isVisible === 'boolean' && !isVisible) {
      this.notifyFormsVisibilityOfPage(this.mPageIndex, false, false);
      this.handleDelayNotifyInVisibleFormsTimer(isDelay);
      this.isScreenLock = true;
      return;
    }

    this.isScreenLock = false;
    // 应用全屏启动状态下，不通知卡片可见
    const deskTopState: ScenePanelState | undefined = AppStorage.get('onDeskTopState');
    if (deskTopState && deskTopState === ScenePanelState.FULLSCENE) {
      log.showWarn(TAG, 'full scene, not notify form visible');
      return;
    }

    this.notifyFormsVisibilityOfPage(this.mPageIndex, true, false);
    this.handleDelayNotifyInVisibleFormsTimer(isDelay);
  }

  public folderStatusChange(pageIndex: number): void {
    if (this.currentStartApp) {
      log.showInfo(TAG, 'current start app, not handle');
      return;
    }

    if (this.isScreenLock) {
      log.showInfo(TAG, 'current screen lock, not handle');
      return;
    }

    log.showInfo(TAG, `folderStatusChange ${pageIndex}, notify visibility`);
    this.notifyFormsVisibilityOfPage(pageIndex, true);
    this.handleDelayNotifyInVisibleFormsTimer(false);
  }

  /**
   * 页面索引变化时卡片可见性与打点相关处理
   */
  private notifyFormsPageChanged(): void {
    if (this.currentStartApp) {
      log.showInfo(TAG, 'current start app, not handle');
      return;
    }

    this.notifyFormsVisibilityOfPage(this.mPageIndex, true);

    let foldOpen: boolean = desktopUtil.isFoldExpandStatus();
    if ((!foldOpen && (this.mPageIndex !== this.mOldPageIndex)) || (foldOpen && (this.mOldPageIndex - this.mPageIndex !== 1))) {
      // 上报页面不可见打点
      this.getFormsByPageIndex(this.mOldPageIndex).forEach((item: CardItemInfo) => {
        FormHiSysEventUtil.getInstance().exposureChange(item, false, false);
      });
    }

    // FMS无法保证卡片在100ms内恢复完成，提前恢复左右一屏卡片
    this.recoverFormsOfNeighborPage(this.mPageIndex);
    // 延迟通知其他页卡片不可见
    this.handleDelayNotifyInVisibleFormsTimer();
  }

  /**
   * 通知pageIndex的相邻页卡片恢复
   *
   * @param pageIndex 页面索引
   */
  private recoverFormsOfNeighborPage(pageIndex: number): void {
    let neighborCards: string[] = this.getNeighborPageCards(pageIndex);
    this.mFormHostService.formHostNotifyToRecover(neighborCards);
  }

  /**
   * 在当前page停留超过2s，通知其他页面的卡片不可见
   */
  private handleDelayNotifyInVisibleFormsTimer(isDelay: boolean = true): void {
    if (this.mPageInvisibleTimer !== INVALID_TIMER) {
      clearTimeout(this.mPageInvisibleTimer);
    }
    this.mPageInvisibleTimer = setTimeout(() => {
      this.mPageInvisibleTimer = INVALID_TIMER;

      // 通知用户不可见的卡片不可见, 直板机：非当前页，大屏幕机与BigScreenMachine：非当前页、非当前页隔壁一页
      let invisibleList: string[] = this.getOtherPageForms(this.mPageIndex);
      this.mFormHostService.formHostNotifyInvisible(invisibleList);
    }, isDelay ? DELAY_TIME_FOR_NOTIFY_PAGE_INVISIBLE : 0);
    log.showInfo(TAG, 'pageIndex %{public}d change to %{public}d, start a invisible forms timer, id: %{public}d',
      this.mOldPageIndex, this.mPageIndex, this.mPageInvisibleTimer);
  }

  /**
   * 通知当前页卡片的可见性
   */
  private notifyFormsVisibilityOfPage(pageIndex: number, isVisible: boolean, isNeedFilter: boolean = true): void {
    if (!this.isPageIndexValid(pageIndex)) {
      log.showWarn(TAG, `notify forms visible fail, invalid page index ${pageIndex}.`);
      return;
    }

    let formList: CardItemInfo[] = this.getFormsByPageIndex(pageIndex) as CardItemInfo[];
    let formIdList: string[] = [];
    let formBriefList : string[] = [];
    formList.forEach((item: CardItemInfo) => {
      const cardBriefInfo: string = `${item.cardId}_${item.bundleName}_${item.page}_${item.row}_${item.column}`;
      formIdList.push(item.cardId);
      formBriefList.push(cardBriefInfo);
      FormHiSysEventUtil.getInstance().exposureChange(item, isVisible, false);
    });

    if (isVisible) {
      this.mFormHostService.formHostNotifyVisible(formIdList, isNeedFilter, formBriefList);
    } else {
      this.mFormHostService.formHostNotifyInvisible(formIdList, isNeedFilter);
    }
  }

  /**
   * 获取桌面上所有的卡片列表
   */
  private getAllCardList(): string[] {
    let allFormList: string[] = this.mFormModel.getAllFormsInfoFromLayout().map(item => item.cardId ?? '');
    return allFormList;
  }

  /**
   * 获取某页的卡片列表, 直板机当前页，折叠屏当前页和相邻页
   *
   * @param pageIndex 页面索引
   */
  private getFormsByPageIndex(pageIndex: number): CardItemInfo[] {
    if (!this.isPageIndexValid(pageIndex)) {
      log.showWarn(TAG, `index ${pageIndex} is invalid`);
      return [];
    }

    let pageList: number[] = [];
    let isOuter: boolean = launcherStatusUtil.getShowOutLauncherStatus();
    const maxPage: number = PageInfoManager.getInstance().getPageCount(isOuter);
    for (let index = 0; index < maxPage; index++) {
      if (PageInfoManager.getInstance().isCurrentPageShow(pageIndex, index)) {
        pageList.push(index);
      }
    }
    log.showInfo(TAG, `index: ${pageIndex}, pageList: ${pageList}, is outer: ${isOuter}`);
    return this.getCardsBySinglePageIndex(pageList);
  }

  private getFormsByPageIndexList(pageIndexes: number[]): CardItemInfo[] {
    if (CheckEmptyUtils.isEmptyArr(pageIndexes)) {
      log.showWarn(TAG, 'the index is empty');
      return [];
    }

    let cardList: CardItemInfo[] = [];
    pageIndexes.forEach((index: number) => {
      cardList.push(...this.getFormsByPageIndex(index));
    })

    return cardList;
  }

  public getCurPageForms(): CardItemInfo[] {
    return this.getFormsByPageIndex(this.mPageIndex);
  }

  /**
   * 获取非当前可见页的卡片列表
   *
   * @param pageIndex 当前可见页面索引
   */
  private getOtherPageForms(pageIndex: number): string[] {
    let allFormList: string[] = this.getAllCardList();
    let visibleSet: Set<string> = new Set();
    this.getFormsByPageIndex(pageIndex).forEach(item => visibleSet.add(item.cardId));
    return allFormList.filter(cardId => !visibleSet.has(cardId));
  }

  /**
   * 获取相邻页的卡片列表
   *
   * @param pageIndex 页面索引
   */
  private getNeighborPageCards(pageIndex: number): string[] {
    let curDisplayPages: number = PageInfoManager.getInstance().getDisplayCount();
    let neighborPageList: number[] = [];
    let leftIndex: number = pageIndex - curDisplayPages;
    let rightIndex: number = pageIndex + curDisplayPages;
    if (this.isPageIndexValid(leftIndex)) {
      neighborPageList.push(leftIndex);
    }
    if (this.isPageIndexValid(rightIndex)) {
      neighborPageList.push(rightIndex);
    }
    const cardIds: string[] = this.getFormsByPageIndexList(neighborPageList).map((item: CardItemInfo) => {
      return item.cardId;
    });
    return cardIds;
  }

  private getCardsBySinglePageIndex(pageIndexes: number[]): CardItemInfo[] {
    let cards: CardItemInfo[] = [];
    let validIndexes: number[] = pageIndexes.filter(index => this.isPageIndexValid(index));
    if (CheckEmptyUtils.isEmptyArr(validIndexes)) {
      log.showWarn(TAG, 'the index is all invalid');
      return cards;
    }

    let allCards: GridLayoutItemInfo[] = FormLayoutCacheManager.getInstance().selectAllFormsAndFormStack();
    if (CheckEmptyUtils.isEmptyArr(allCards)) {
      log.showWarn(TAG, 'no cards in layout!');
      return cards;
    }

    for (const card of allCards) {
      if (!validIndexes.includes(card.page ?? CommonConstants.INVALID_VALUE)) {
        continue;
      }

      if (card.typeId === CommonConstants.TYPE_CARD) {
        cards.push(this.convertCardItemInfo(card));
      } else if (card.typeId === CommonConstants.TYPE_FORM_STACK) {
        card.layoutInfo?.[0]?.forEach((stackCard: GridLayoutItemInfo) => {
          cards.push(this.convertCardItemInfo(stackCard));
        });
      }
    }
    return cards;
  }

  private convertCardItemInfo(item: GridLayoutItemInfo): CardItemInfo {
    let cardItemInfo: CardItemInfo = new CardItemInfo();
    cardItemInfo.container = item.container;
    cardItemInfo.name = item.cardName;
    cardItemInfo.cardId = item.cardId ?? '';
    cardItemInfo.bundleName = item.bundleName;
    cardItemInfo.abilityName = item.abilityName;
    cardItemInfo.moduleName = item.moduleName ?? '';
    cardItemInfo.cardDimension = item.cardDimension ?? 0;
    cardItemInfo.page = item.page;
    cardItemInfo.row = item.row;
    cardItemInfo.column = item.column;
    cardItemInfo.area = item.area;
    cardItemInfo.gameCardInfo = item.gameCardInfo;
    return cardItemInfo;
  }

  private isPageIndexValid(pageIndex: number) : boolean {
    return pageIndex >= 0 && pageIndex < this.mLauncherLayoutCacheManager.selectPageCount();
  }

  requestForm(formId: string): void {
    log.showInfo(TAG, `formHost requestForm ${formId}`);
    try {
      formHost.requestForm(formId).then(() => {
        log.showInfo(TAG, 'formHost requestForm success');
      }).catch((error: Error) => {
        log.showError(TAG, `formHost requestForm error, message: ${error.message}, formId:${formId}`);
      });
    } catch (err) {
      log.showError(TAG, `formHost requestForm fail, err->${JSON.stringify(err)}, formId:${formId}`);
    }
  }

  notifyUnSelect(): void {
    AppStorage.setOrCreate('selectItem', '');
    this.initSelectStatus();
  }

  /**
   * set pageIndex to appStorage.
   */
  setPageIndex(): void {
    AppStorage.setOrCreate(desktopUtil.getPageIndex(), this.mPageIndex);
    // 若文件夹打开状态, 需要关闭
    if (AppStorage.get('openFolderStatus') !== CommonConstants.OPEN_FOLDER_STATUS_CLOSE) {
      AppStorage.setOrCreate('openFolderStatus', CommonConstants.FOLDER_STATUS_REQUEST_CLOSE);
    }
  }

  isBlankPage(targetIndex?: number): boolean {
    const pageIndex: number = targetIndex ?? this.mPageIndex;
    log.showInfo(TAG, `isBlankPage current index is ${pageIndex}`);
    // 在瀑布屏页面内
    if (!this.mGridAppsInfos?.length) {
      return false;
    }
    if (pageIndex >= this.mGridAppsInfos.length) {
      return false;
    }
    if (!CheckEmptyUtils.isEmptyArr(this.mGridAppsInfos) &&
      !CheckEmptyUtils.isEmptyArr(this.mGridAppsInfos[pageIndex]) &&
      this.mGridAppsInfos[pageIndex].length !== 0) {
      return false;
    }
    if (this.isBigScreen &&
      !CheckEmptyUtils.isEmptyArr(this.mGridAppsInfos[this.viewModelUtils.getNeighborPage(pageIndex)]) &&
      this.mGridAppsInfos[this.viewModelUtils.getNeighborPage(pageIndex)].length !== 0) {
      return false;
    }
    const displayCnt: number = PageInfoManager.getInstance().getDisplayCount();
    const neighborPage = EditModeUtils.getCurrentShowingPage(pageIndex, displayCnt);
    for (let i = 0; i < neighborPage.length; i++) {
      if (!CheckEmptyUtils.isEmptyArr(this.mGridAppsInfos[neighborPage[i]]) &&
        this.mGridAppsInfos[neighborPage[i]].length !== 0) {
        return false;
      }
    }
    return true;
  }

  isSingleItemPage(targetIndex?: number): boolean {
    const pageIndex: number = targetIndex ?? this.mPageIndex;
    log.showInfo(TAG, `isSingleItemPage current index is ${pageIndex}`);
    if (pageIndex >= this.mGridAppsInfos.length) {
      return false;
    }
    let appsInfosNumber: number = 0;
    if (this.isBigScreen) {
      if (!CheckEmptyUtils.isEmptyArr(this.mGridAppsInfos) &&
        !CheckEmptyUtils.isEmptyArr(this.mGridAppsInfos[pageIndex])) {
        appsInfosNumber += this.mGridAppsInfos[pageIndex].length;
      }
      if (!CheckEmptyUtils.isEmptyArr(this.mGridAppsInfos[this.viewModelUtils.getNeighborPage(pageIndex)])) {
        appsInfosNumber += this.mGridAppsInfos[this.viewModelUtils.getNeighborPage(pageIndex)].length;
      }
    } else {
      const displayCnt: number = PageInfoManager.getInstance().getDisplayCount();
      const neighborPage = EditModeUtils.getCurrentShowingPage(pageIndex, displayCnt);
      for (let i = 0; i < neighborPage.length; i++) {
        if (!CheckEmptyUtils.isEmptyArr(this.mGridAppsInfos) &&
          !CheckEmptyUtils.isEmptyArr(this.mGridAppsInfos[neighborPage[i]])) {
          appsInfosNumber += this.mGridAppsInfos[pageIndex].length;
        }
      }
    }
    if (appsInfosNumber === 1) {
      log.showWarn(TAG, `current index ${pageIndex} has only one item`);
      return true;
    }
    return false;
  }

  /**
   * Changing the Desktop Page Number.
   *
   * @param idx: Page number
   */
  changeIndex(idx: number): void {
    this.updatePageIndex(idx);
    log.showInfo(TAG, 'changeIndex ' + idx);
    this.setPageIndex();
  }

  /**
   * Get the Desktop Page Number.
   */
  getIndex(): number {
    return this.mPageIndex;
  }

  /**
   * Get the Desktop Page Swipe Target.
   */
  getTargetIndex(): number {
    return this.mTargetIndex;
  }

  /**
   * Set the Desktop Page Swipe Target.
   */
  setTargetIndex(target: number): void {
    this.mTargetIndex = target;
  }

  /**
   * Add a blank page.
   *
   * @param {boolean} isAddByDrag
   */
  addBlankPage(isAddByDrag: boolean): void {
    log.showInfo(TAG, 'addBlankPage' + this.mPageIndex);
    const displayCount = PageInfoManager.getInstance().getDisplayCount();
    let allPageCount = this.mLauncherLayoutCacheManager.selectPageCount() + displayCount;
    if (allPageCount > this.mLauncherLayoutCacheManager.selectMaxPageCount()) {
      if (this.isPad) {
        return;
      }
      Prompt.showToast({
        message:this.mResourceManager.getStringByName('add_black_page_to_desktop_max')
      });
      return;
    }
    this.isAddByDraggingFlag = isAddByDrag;
    this.mLauncherLayoutCacheManager.updatePageCount(allPageCount, BusinessType.BUSINESS_BASIC_DESKTOP, true);

    if (isAddByDrag) {
      this.addPageToAppGridInfo();
    } else {
      this.lightPagingFiltering(false, SceneMsgEnum.SCENE_MSG_ADD_BLANK_PAGE);
      this.updatePageIndex(allPageCount - 1);
      this.setPageIndex();
    }
  }

  addPageToAppGridInfo(): void {
    const desktopDataInfo: AppListInfo | undefined = AppStorage.get(desktopUtil.getAppListInfo());
    if (!desktopDataInfo) {
      return;
    }
    const displayCount = PageInfoManager.getInstance().getDisplayCount();
    for (let i = 0; i < displayCount; i++) {
      desktopDataInfo.appGridInfo.push([]);
    }
    this.mGridAppsInfos = desktopDataInfo.appGridInfo;
    // transfer desktopDataInfo is not update, so transfer a new array
    let tempDataInfo: AppListInfo = {
      appGridInfo: desktopDataInfo.appGridInfo,
      waterfallItemListInfo: desktopDataInfo.waterfallItemListInfo
    };
    log.showInfo(TAG, `tempDataInfo.appGridInfo.length:${tempDataInfo.appGridInfo.length}`);
    LayoutViewModel.getInstance().updateDesktopLayoutData(tempDataInfo, 'addPageToAppGridInfo');
  }

  addMiddlePageToAppGridInfo(): void {
    const desktopDataInfo: AppListInfo | undefined = AppStorage.get(desktopUtil.getAppListInfo());
    if (!desktopDataInfo) {
      return;
    }
    const curPageIndex = this.mPageDesktopModel.getPageIndex();
    let foldStatus: boolean = desktopUtil.isFoldExpandStatus();
    if (foldStatus) {
      if (PageInfoManager.getInstance().getDisplayCount() === NumberConstants.CONSTANT_NUMBER_THREE) {
        desktopDataInfo.appGridInfo.splice(curPageIndex + NumberConstants.CONSTANT_NUMBER_THREE, 0, [], [], []);
      } else {
        desktopDataInfo.appGridInfo.splice(curPageIndex + NumberConstants.CONSTANT_NUMBER_TWO, 0, [], []);
      }
    } else {
      desktopDataInfo.appGridInfo.splice(curPageIndex + 1, 0, []);
    }
    this.mGridAppsInfos = desktopDataInfo.appGridInfo;
    // transfer desktopDataInfo is not update, so transfer a new array
    let tempDataInfo: AppListInfo = {
      appGridInfo: desktopDataInfo.appGridInfo,
      waterfallItemListInfo: desktopDataInfo.waterfallItemListInfo
    };
    LayoutViewModel.getInstance().updateDesktopLayoutData(tempDataInfo, 'addMiddlePageToAppGridInfo');
  }

  /**
   * get the addByDragging flag
   */
  isAddByDragging(): boolean {
    return this.isAddByDraggingFlag;
  }

  /**
   * set the addByDragging flag
   *
   * @param {boolean} isAddByDragging
   */
  setAddByDragging(isAddByDragging: boolean): void {
    this.isAddByDraggingFlag = isAddByDragging;
  }

  /**
   * Get pageCount.
   *
   * @return {number} PageCount.
   */
  getGridPageCount(): number {
    return this.mLauncherLayoutCacheManager.selectPageCount();
  }

  /**
   * Set pageCount.
   *
   * @param {number} pageCount - PageCount.
   * @param {boolean} isOuter - is outer.
   */
  private setGridPageCount(pageCount: number, isOuter?: boolean): void {
    this.mLauncherLayoutCacheManager.updatePageCount(pageCount, BusinessType.BUSINESS_BASIC_DESKTOP, true, isOuter);
  }


  /**
   * Set device type.
   *
   * @param EType: Device type
   */
  setDevice(deiceType: string): void {
    this.mSettingsModel.setDevice(deiceType);
    this.isPad = deiceType === CommonConstants.PAD_DEVICE_TYPE;
  }

  /**
   * Get device type.
   */
  getDevice(): boolean {
    return this.isPad;
  }

  buildMixedMenuInfo(appInfo: AppItemInfo, openClickCallback?: Function): MenuInfo[] {
    let menuInfoList = new Array<MenuInfo>();
    let open: MenuInfo = new MenuInfo();
    open.menuType = CommonConstants.MENU_TYPE_FIXED;
    open.menuText = $r('app.string.app_menu_open');
    open.onMenuClick = (params: Map<string, Object>): void => {
      if (openClickCallback) {
        openClickCallback();
        this.initSelectStatus();
        this.selectItemClear();
      }
      ContractedFolderLayoutViewModel.getInstance().updateOpenFolderStatus(0);
      if (appInfo.shortcutId) {
        ShortcutViewModel.getInstance().onShortcutAppClick(appInfo);
      } else {
        params.set(SCBConstants.IS_START_BY_LAUNCHTYPE_CONFIG, true);
        this.jumpTo(appInfo.abilityName, appInfo.bundleName, appInfo.moduleName, params);
      }
    };
    menuInfoList.push(open);

    let mMenuInfo: MenuInfo = new MenuInfo();
    mMenuInfo.menuType = CommonConstants.MENU_TYPE_FIXED;
    mMenuInfo.menuText = $r('app.string.accessibility_notification_delete_bar');
    mMenuInfo.onMenuClick = (): void => {
      this.doDeleteEvent();
    };
    menuInfoList.push(mMenuInfo);
    return menuInfoList;
  }

  private onRemoveShortcut(appInfo: AppItemInfo, removeShortcutItem?: Function): void {
    log.showInfo(TAG, 'remove shortcut icon in desktop or folder');
    if (removeShortcutItem) {
      log.showInfo(TAG, 'remove from callback');
      removeShortcutItem();
    } else {
      // 快捷图标移除没有弹窗，需要等菜单动效结束再做移除动效
      this.desktopContext.eventHub.on(CommonConstants.EVENTHUB_MENU_DISAPPEAR, () => {
        this.desktopContext.eventHub.off(CommonConstants.EVENTHUB_MENU_DISAPPEAR);
        this.removeShortcutItem(appInfo);
      });
    }
    if (appInfo.container === CommonConstants.CONTAINER_DESKTOP) {
      log.showInfo(TAG, 'Remove shortcut of desktop execute autoAlign');
      this.autoAlignAfterUninstall([appInfo]);
    }
    HiSysEventUtil.reportDeleteShortcutMenu(appInfo.bundleName, appInfo.appName);
  }

  private getUninstallMenuText(item: AppItemInfo | GridLayoutItemInfo): Resource {
    if (this.isPad) {
      return $r('app.string.remove_from_desktop');
    }
    if (item.appIndex) {
      return $r('app.string.delete');
    }
    return $r('app.string.uninstall');
  }

  private buildShortcutMenuOnPc(menuList: MenuInfo[], appInfo: AppItemInfo, openClickCallback?: Function,
    removeShortcutItem?: Function): void {
    log.showInfo(TAG, `buildShortcutMenuOnPc bundleName=${appInfo.bundleName}, shortcutId=${appInfo.shortcutId}, container=${appInfo.container}`);
    const shortcutMenu = new MenuInfo();
    shortcutMenu.menuType = CommonConstants.MENU_TYPE_FIXED;
    shortcutMenu.menuImgSrc = '/common/pics/ic_public_remove.svg';
    shortcutMenu.menuText = this.mResourceManager.getStringByName('delete_form');
    shortcutMenu.onMenuClick = (): void => {
      this.onRemoveShortcut(appInfo, removeShortcutItem);
    };
    menuList.push(shortcutMenu);

    let open: MenuInfo = new MenuInfo();
    open.menuType = CommonConstants.MENU_TYPE_FIXED;
    open.menuImgSrc = '/common/pics/ic_public_add_norm.svg';
    open.menuText = $r('app.string.app_menu_open');
    open.onMenuClick = (params: Map<string, Object>): void => {
      if (openClickCallback) {
        openClickCallback();
      }
      ContractedFolderLayoutViewModel.getInstance().updateOpenFolderStatus(0);
      ShortcutViewModel.getInstance().onShortcutAppClick(appInfo);
    };
    menuList.push(open);
  }

  private createDeleteMenu(appInfo: AppItemInfo, deleteFun: Function): MenuInfo {
    const deleteMenu = new MenuInfo();
    deleteMenu.menuType = CommonConstants.MENU_TYPE_FIXED;
    deleteMenu.menuImgSrc = '/common/pics/ic_public_remove.svg';
    deleteMenu.menuText = $r('app.string.delete_app');
    deleteMenu.onMenuClick = (): void => {
      const appName = this.getAppName(appInfo);
      if (appName != null) {
        appInfo.appName = appName;
      }
      AppStorage.setOrCreate('uninstallAppInfo', appInfo);
      AppStorage.setOrCreate('showUninstallDialog', true);
      HiSysEventUtil.reportOpenDeleteAppDialog(appInfo.bundleName);
      this.desktopContext?.eventHub.off(CommonConstants.EVENTHUB_APP_MENU_DISAPPEAR);
      this.desktopContext?.eventHub.on(CommonConstants.EVENTHUB_APP_MENU_DISAPPEAR, () => {
        this.desktopContext?.eventHub.off(CommonConstants.EVENTHUB_APP_MENU_DISAPPEAR);
        log.showInfo(TAG, 'after disappear, do delete business');
        deleteFun();
      });
    };
    return deleteMenu;
  }

  public buildMenuDeleteInfo(appInfo: AppItemInfo, deleteFun: Function): MenuInfo[] {
    let menuInfoList = new Array<MenuInfo>();
    if (appInfo.typeId === CommonConstants.TYPE_APP &&
      !layoutLockUtil.isLockedPage(appInfo.page, 'get outerDeleteMenu', true) &&
      !lockLayoutManager.isLockLayout()) {
      const deleteMenu = this.createDeleteMenu(appInfo, deleteFun);
      menuInfoList.push(deleteMenu);
    }

    if (appInfo.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
      // 定制联系人快捷图标无法移除;演示样机预置页及预置页文件夹内的快捷方式无法移除
      if (ShortcutViewModel.getInstance().isContactsApp(appInfo.bundleName) || this.isInLockedPage(appInfo)) {
        return [];
      }
      const shortcutMenu = this.createDeleteMenu(appInfo, deleteFun);
      menuInfoList.push(shortcutMenu);
      return menuInfoList;
    }

    return menuInfoList;
  }

  private buildAppMenu(menu: MenuInfoType): MenuInfo[] {
    return this.buildMenuInfoList(menu.appInfo, menu.dialog, menu.removeDialog, menu.formDialog,
      menu.openClick, menu.removeShortcut);
  }

  private buildRemoveMenu(appInfo: AppItemInfo, removeDialog: CustomDialogController | null,
    menuInfoList: Array<MenuInfo>): void {
    let removeMenu: MenuInfo = new MenuInfo();
    removeMenu.menuType = CommonConstants.MENU_TYPE_FIXED;
    removeMenu.menuImgSrc = '/common/pics/ic_public_remove.svg';
    removeMenu.menuText = $r('app.string.delete_app');
    removeMenu.onMenuClick = (): void => {
      log.showInfo(TAG, `Launcher click menu item remove ${appInfo?.appLabelId} ${appInfo?.bundleName} ${appInfo?.moduleName}`);
      const appName: string = this.getAppName(appInfo);
      log.showInfo(TAG, 'buildMenuInfoList appName' + appName);
      if (!CheckEmptyUtils.isEmpty(appName)) {
        appInfo.appName = appName;
      }
      AppStorage.setOrCreate('uninstallAppInfo', appInfo);
      AppStorage.setOrCreate('showUninstallDialog', true);
      HiSysEventUtil.reportOpenDeleteAppDialog(appInfo.bundleName);
      removeDialog?.open();
    };
    removeMenu.menuEnabled = (!this.isInLockedPage(appInfo) && !lockLayoutManager.isLockLayout()) ?? false;
    if (removeMenu.menuEnabled) {
      menuInfoList.push(removeMenu);
    }
  }

  private buildUninstallMenu(appInfo: AppItemInfo, dialog: CustomDialogController | null,
    menuInfoList: Array<MenuInfo>): void {
    const uninstallMenu = new MenuInfo();
    uninstallMenu.menuType = CommonConstants.MENU_TYPE_FIXED;
    uninstallMenu.menuImgSrc = this.isPad ? '/common/pics/ic_public_remove.svg' : '/common/pics/ic_public_delete.svg';
    uninstallMenu.menuText = this.getUninstallMenuText(appInfo);
    uninstallMenu.onMenuClick = (): void => {
      log.showInfo(TAG, `Launcher click menu item uninstall ${appInfo?.appLabelId} ${appInfo?.bundleName} ${appInfo?.moduleName}`);
      const appName: string = this.getAppName(appInfo);
      log.showInfo(TAG, 'buildMenuInfoList appName' + appName);
      if (!CheckEmptyUtils.isEmpty(appName)) {
        appInfo.appName = appName;
      }
      AppStorage.setOrCreate('uninstallAppInfo', appInfo);
      AppStorage.setOrCreate('showUninstallDialog', true);
      this.reportOpenUninstallAppDialog(appInfo as GridLayoutItemInfo);
      dialog?.open();
    };
    uninstallMenu.menuEnabled = (appInfo.isUninstallAble && !this.isInLockedPage(appInfo) &&
      !lockLayoutManager.isLockLayout()) ?? false;
  }

  buildMenuInfoList(
    appInfo: AppItemInfo,
    dialog: CustomDialogController | null,
    removeDialog?: CustomDialogController | null,
    formDialog?: CustomDialogController | null,
    openClickCallback?: Function,
    removeShortcutItem?: Function): MenuInfo[] {
    let menuInfoList = new Array<MenuInfo>();
    if (DeviceHelper.isPC() && appInfo.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
      this.buildShortcutMenuOnPc(menuInfoList, appInfo, openClickCallback, removeShortcutItem);
      return menuInfoList;
    }
    if (appInfo.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
      // 定制联系人快捷图标无法移除;演示样机预置页及预置页文件夹内的快捷方式无法移除
      if (ShortcutViewModel.getInstance().isContactsApp(appInfo.bundleName) || this.isInLockedPage(appInfo)) {
        return [];
      }
      if (!lockLayoutManager.isLockLayout()) {
        const shortcutMenu = new MenuInfo();
        shortcutMenu.menuType = CommonConstants.MENU_TYPE_FIXED;
        shortcutMenu.menuImgSrc = '/common/pics/ic_public_remove.svg';
        shortcutMenu.menuText = this.mResourceManager.getStringByName('delete_form');
        shortcutMenu.onMenuClick = (): void => { this.onRemoveShortcut(appInfo, removeShortcutItem); };
        menuInfoList.push(shortcutMenu);
      }
      this.checkAddToOuterMenu(appInfo, menuInfoList);
      return menuInfoList;
    }

    this.mShortcutViewModel.checkShortCutInfo(appInfo, menuInfoList);

    if (this.isPad) {
      let open: MenuInfo = new MenuInfo();
      open.menuType = CommonConstants.MENU_TYPE_FIXED;
      open.menuImgSrc = '/common/pics/ic_public_add_norm.svg';
      open.menuText = $r('app.string.app_menu_open');
      open.onMenuClick = (params: Map<string, Object>): void => {
        if (openClickCallback) {
          openClickCallback();
        }
        ContractedFolderLayoutViewModel.getInstance().updateOpenFolderStatus(0);
        params.set(SCBConstants.IS_START_BY_LAUNCHTYPE_CONFIG, true);
        if (appInfo?.enableNewAppInstance) {
          params.set(SCBConstants.CREATE_NEW_APP_INSTANCE_KEY, true);
        }
        if ((appInfo.appIndex ?? 0) > 0) {
          params.set(SCBConstants.START_APP_CLONE_INDEX, (appInfo.appIndex ?? 0));
        }
        params.set(SCBConstants.OPEN_IN_NEW_WINDOW, true);
        this.jumpTo(appInfo.abilityName, appInfo.bundleName, appInfo.moduleName, params);
      };
      menuInfoList.push(open);
    }

    this.checkAddMultiWindowMenu(appInfo, menuInfoList);

    this.checkFormInfoList(appInfo, menuInfoList, formDialog);

    this.checkAddToOuterMenu(appInfo, menuInfoList);

    let appLockMenu: MenuInfo | undefined = AppLockUtils.getInstance().buildAppLockMenu(appInfo);
    if (appLockMenu !== undefined) {
      menuInfoList.push(appLockMenu);
    }

    this.checkAddToDockMenu(appInfo, menuInfoList);

    return menuInfoList;
  }

  private checkAddMultiWindowMenu(appInfo: AppItemInfo, menuInfoList: MenuInfo[]) {
    if (this.enableMultiWindowMenu(appInfo)) {
      let openFromFloatingWindow: MenuInfo = new MenuInfo();
      openFromFloatingWindow.menuType = CommonConstants.MENU_TYPE_FIXED;
      openFromFloatingWindow.menuImgSrc = '/common/pics/ic_public_add_norm.svg';
      openFromFloatingWindow.menuText = $r('app.string.app_menu_open_from_floating_window');
      openFromFloatingWindow.onMenuClick = (params: Map<string, Object>): void => {
        ContractedFolderLayoutViewModel.getInstance().updateOpenFolderStatus(0);
        params.set(SCBConstants.IS_START_BY_LAUNCHTYPE_CONFIG, true);
        if (appInfo?.enableNewAppInstance) {
          params.set(SCBConstants.CREATE_NEW_APP_INSTANCE_KEY, true);
        }
        if ((appInfo.appIndex ?? 0) > 0) {
          params.set(SCBConstants.START_APP_CLONE_INDEX, (appInfo.appIndex ?? 0));
        }
        params.set(SCBConstants.OPEN_IN_NEW_WINDOW, true);
        this.jumpToWithMode(SCBSceneMode.FLOATING, appInfo.abilityName, appInfo.bundleName, appInfo.moduleName, params);
      };
      menuInfoList.push(openFromFloatingWindow);
      log.showInfo(TAG, 'Launcher push menu item openFromFloatingWindow');
      let openFromSplitScreen: MenuInfo = new MenuInfo();
      openFromSplitScreen.menuType = CommonConstants.MENU_TYPE_FIXED;
      openFromSplitScreen.menuImgSrc = '/common/pics/ic_public_add_norm.svg';
      openFromSplitScreen.menuText = $r('app.string.app_menu_open_from_split_screen');
      openFromSplitScreen.onMenuClick = (params: Map<string, Object>): void => {
        ContractedFolderLayoutViewModel.getInstance().updateOpenFolderStatus(0);
        params.set(SCBConstants.IS_START_BY_LAUNCHTYPE_CONFIG, true);
        if (appInfo?.enableNewAppInstance) {
          params.set(SCBConstants.CREATE_NEW_APP_INSTANCE_KEY, true);
        }
        if ((appInfo.appIndex ?? 0) > 0) {
          params.set(SCBConstants.START_APP_CLONE_INDEX, (appInfo.appIndex ?? 0));
        }
        params.set(SCBConstants.OPEN_IN_NEW_WINDOW, true);
        this.jumpToWithMode(SCBSceneMode.PRIMARY, appInfo.abilityName, appInfo.bundleName, appInfo.moduleName, params);
      };
      menuInfoList.push(openFromSplitScreen);
      log.showInfo(TAG, 'Launcher push menu item openFromSplitScreen');
    }
  }

  private enableMultiWindowMenu(appInfo: AppItemInfo): boolean {
    let containerSessionList = SCBSceneSessionManager.getInstance().getAllContainerSessionList();
    let floatingSessionList = SCBSceneSessionManager.getInstance().getFloatingSessionList();
    let find = containerSessionList.findItemByBundleInfo(appInfo.abilityName, appInfo.bundleName, appInfo.moduleName);
    let top = containerSessionList.getTopActiveSession();
    let findFloat = floatingSessionList.findItemByBundleInfo(appInfo.abilityName, appInfo.bundleName, appInfo.moduleName);
    if (find?.isSplit || findFloat?.isFloat || top?.isSplit) {
      return false;
    }
    return true;
  }

  // 卸载打点
  private reportOpenUninstallAppDialog(appInfo: GridLayoutItemInfo): void {
  }

  private isInLockedPage(appInfo: AppItemInfo | GridLayoutItemInfo): boolean {
    // 桌面图标直接判断所在page；文件夹图标需要先判断是否在dock区内，再判断文件夹所在page
    let pageIndexInDesktop: number = appInfo.page ?? CommonConstants.INVALID_VALUE;
    let isInDock: boolean = false;
    if (this.mFolderMgr.isFolderOpen()) {
      const openFolderData: GridLayoutItemInfo = this.mFolderMgr.getOpenedFolder();
      pageIndexInDesktop = openFolderData.page ?? CommonConstants.INVALID_VALUE;
      isInDock = openFolderData.isInDock ?? false;
    }
    const msg: string = 'get app removeMenu';
    return layoutLockUtil.isLockedPage(pageIndexInDesktop, msg, true) || (isInDock && layoutLockUtil.isLocked(msg));
  }

  private checkFormInfoList(appInfo: AppItemInfo, menuInfoList: MenuInfo[],
    formDialog?: CustomDialogController | null): void {
    if (LayoutViewModel.getInstance().getDesktopModel() === DesktopLayoutState.SIMPLE_LAUNCHER_MODEL) {
      return;
    }
    const formInfoList = this.mFormModel.getAppItemFormInfo(appInfo.bundleName as string,
      item => this.mFormModel.isFormCenterSupportCard(item));
    if (!CheckEmptyUtils.isEmptyArr(formInfoList) && !appInfo.appIndex) {
      let addFormToDeskTopMenu = new MenuInfo();
      addFormToDeskTopMenu.menuType = CommonConstants.MENU_TYPE_FIXED;
      addFormToDeskTopMenu.menuImgSrc = '/common/pics/ic_form_center.svg';
      addFormToDeskTopMenu.menuText = $r('app.string.add_form_to_desktop');
      addFormToDeskTopMenu.onMenuClick = (appParams?: Map<string, Object>): void => {
        log.showInfo(TAG, 'Launcher click menu item into add form to desktop view');
        FormHiSysEventUtil.reportIntoFormManagerFromAppShortcutMenu(appInfo.bundleName as string);
        FormHiSysEventUtil.reportIntoFormType('0');
        this.mFormModel.doBeforeJumpToFormManager(String(appInfo.bundleName)).then(() => {
          this.mViewManager.jumpToFormManagerView(appInfo,
            Number(FormConstants.FORM_MANAGER_SHOW_FROM_DESKTOP_APP_RIGHT_MENU));
        });
      };
      menuInfoList.push(addFormToDeskTopMenu);
    } else {
      log.showWarn(TAG, `bundleName: ${appInfo.bundleName} not support card, formInfoList: ${formInfoList?.length}` +
        `, appIndex :${appInfo.appIndex}}`);
    }
  }

  private checkAddToOuterMenu(appInfo: AppItemInfo, menuInfoList: MenuInfo[]): void {
    return;
  }

  private checkAddToDockMenu(appInfo: AppItemInfo, menuInfoList: MenuInfo[]): void {
    if (this.isPad) {
      const addToDockMenu = new MenuInfo();
      addToDockMenu.menuType = CommonConstants.MENU_TYPE_FIXED;
      addToDockMenu.menuImgSrc = '/common/pics/ic_public_copy.svg';
      addToDockMenu.menuText = $r('app.string.app_center_menu_add_dock');
      addToDockMenu.onMenuClick = (): void => {
        const appName = this.getAppName(appInfo);
        log.showInfo(TAG, 'buildMenuInfoList appName' + appName);
        if (appName != null) {
          appInfo.appName = appName;
        }
        log.showInfo(TAG, 'Launcher click menu item add to dock');
        this.addToDock(appInfo);
      };
      menuInfoList.push(addToDockMenu);
    }
  }
  /**
   * 构建非安装状态应用长按菜单Map
   * @param bundleName 应用bundleName
   * @returns Map<AppStatus, MenuInfo[]>
   */
  public buildNotInstalledAppMenu(item: AppItemInfo, dialog: CustomDialogController, gravityAnimation?: Function): Map<AppStatus, MenuInfo[]> {
    let bundleName: string = item.bundleName;
    let appIndex: number = item.appIndex ? item.appIndex : 0;
    let notInstalledMenuMap: Map<AppStatus, MenuInfo[]> = new Map();
    let removeInfo: MenuInfo = this.getRemoveInfo(item, true, appIndex, dialog, gravityAnimation);
    if (!lockLayoutManager.isLockLayout()) {
      notInstalledMenuMap.set(AppStatus.PENDING, [removeInfo]);
      notInstalledMenuMap.set(AppStatus.WAIT_FOR_HARMONY,
        [this.getRemoveInfo(item, false, appIndex, dialog, gravityAnimation)]);
      notInstalledMenuMap.set(AppStatus.WAITING, [removeInfo]);
      notInstalledMenuMap.set(AppStatus.DOWNLOADING, [removeInfo]);
      notInstalledMenuMap.set(AppStatus.UPDATING, [removeInfo]);
      notInstalledMenuMap.set(AppStatus.WIFI_WAITING, [removeInfo]);
      notInstalledMenuMap.set(AppStatus.PAUSING, [removeInfo]);
      notInstalledMenuMap.set(AppStatus.INSTALL_WAITING, []);
      notInstalledMenuMap.set(AppStatus.INSTALLING, []);
    }
    return notInstalledMenuMap;
  }

  private getRemoveInfo(
    item: AppItemInfo,
    isRemove: boolean,
    appIndex: number,
    dialog: CustomDialogController,
    gravityAnimation?: Function): MenuInfo {
    let removeInfo: MenuInfo = new MenuInfo();
    removeInfo.menuType = CommonConstants.MENU_TYPE_FIXED;
    if (isRemove) {
      removeInfo.menuImgSrc = '/common/pics/ic_public_remove.svg';
      removeInfo.menuText = $r('app.string.delete_app');
    } else {
      removeInfo.menuImgSrc = '/common/pics/ic_public_delete.svg';
      removeInfo.menuText = $r('app.string.uninstall');
    }
    removeInfo.onMenuClick = (): void => {
      AppStorage.setOrCreate('uninstallAppInfo', item);
      this.isRemoveFlag = isRemove;
      log.showInfo(TAG, `item callerName: ${item.callerName}`);
      //克隆场景弹出对话框
      if (item.callerName === CommonConstants.SOURCE_CLONE ||
        item.callerName === CommonConstants.SOURCE_UPGRADE) {
        //弹出移除提示框
        dialog?.open();
      } else {
        this.removeNotInstall(item);
        // 移除下载中图标触发引力动效
        gravityAnimation?.(item);
      }
    };
    return removeInfo;
  }

  public removeNotInstall(moveInfo: AppItemInfo): void {
    if (moveInfo.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
      this.removeShortcutItem(moveInfo);
      return;
    }
    // 升级场景删除应用需要删除相应映射卡片
    this.deleteSceneBoardFormRelationInfo(moveInfo.bundleName);
    this.deleteNotInstallApp(this.isRemoveFlag, moveInfo.bundleName, moveInfo.appIndex);
    ContractedFolderLayoutViewModel.getInstance().updateOpenFolderStatus(CommonConstants.OPEN_FOLDER_STATUS_CLOSE);
  }

  /**
   * 克隆和升级删除占位卡片
   * @param bundleName 应用bundleName
   * @returns void
   */
  private deleteSceneBoardFormRelationInfo(bundleName: string): void {
    let remainingStackInfos: GridLayoutItemInfo[] = [];
    let deleteFormAndStackInfos: GridLayoutItemInfo[] = [];
    log.showInfo(TAG, `deleteFormAndStackInfos.length : ${deleteFormAndStackInfos.length}`);
    if (!CheckEmptyUtils.isEmptyArr(deleteFormAndStackInfos)) {
      // 删除缓存和数据库
      FormLayoutCacheManager.getInstance().deleteSceneBoardFormAndStackInfos(remainingStackInfos, deleteFormAndStackInfos,
        BusinessType.BUSINESS_BASIC_DESKTOP, true);
      // 删除空白页
      for (const deleteItem of deleteFormAndStackInfos) {
        let ret: boolean = this.mPageDesktopModel.deleteBlankPageFromLayoutInfo(deleteItem.page);
        if (!ret) {
          continue;
        }
        const curPageIndex = this.mPageDesktopModel.getPageIndex();
        log.showInfo(TAG, 'deleteAppItem' + curPageIndex);
        this.mPageDesktopModel.setPageIndex((curPageIndex > 0) ? (curPageIndex - 1) : curPageIndex);
      }
    }
  }

  public isNeedRemoveConfirmDiag(): boolean {
    return false;
  }

  buildCardMenuInfoList(formInfo: CardItemInfo, dialog: CustomDialogController | null,
    formManagerShowFrom: number, deleteFunc: () => void): Array<MenuInfo> {
    const menuInfoList = new Array<MenuInfo>();
    if (CheckEmptyUtils.isEmpty(formInfo)) {
      log.showError(TAG, 'buildCardMenuInfoList with invalid formInfo');
      return menuInfoList;
    }
    if ((dialog != null || deleteFunc != null) &&
      !layoutLockUtil.isLockedPage(formInfo.page ?? -1, 'get card removeMenu', true) &&
      LayoutViewModel.getInstance().getDesktopModel() !==
      DesktopLayoutState.SIMPLE_LAUNCHER_MODEL && !lockLayoutManager.isLockLayout()) {
      const deleteFormFromDeskTop = new MenuInfo();
      deleteFormFromDeskTop.menuType = CommonConstants.MENU_TYPE_FIXED;
      deleteFormFromDeskTop.menuImgSrc = '/common/pics/ic_public_remove.svg';
      deleteFormFromDeskTop.menuText = $r('app.string.delete_form');
      deleteFormFromDeskTop.onMenuClick = (): void => {
        log.showInfo(TAG, 'Launcher click menu item remove form to desktop view');
        this.reportClickCardMenuEvent(formInfo, ShortcutMenuClickType.REMOVE);
        const formAnimateData: FormAnimateData = { cardId: formInfo.cardId, isOpenRemoveFormDialog: true};
        AppStorage.setOrCreate('formAnimateData', formAnimateData);
        if (this.isNeedRemoveConfirmDiag() && deleteFunc != null) {
          this.desktopContext?.eventHub.off(CommonConstants.EVENTHUB_FORM_MENU_DISAPPEAR);
          this.desktopContext?.eventHub.on(CommonConstants.EVENTHUB_FORM_MENU_DISAPPEAR, () => {
            this.desktopContext?.eventHub.off(CommonConstants.EVENTHUB_FORM_MENU_DISAPPEAR);
            deleteFunc();
          });
        } else if (!this.isNeedRemoveConfirmDiag() && dialog != null) {
          AppStorage.setOrCreate('showUninstallDialog', true);
          dialog.open();
        }
      };
      menuInfoList.push(deleteFormFromDeskTop);
    }

    // 外屏桌面卡片长按只显示删除菜单
    if (launcherStatusUtil.getShowOutLauncherStatus()) {
      return menuInfoList;
    }

    this.checkAddFormToDeskTopMenu(formInfo, menuInfoList, formManagerShowFrom);

    // 主应用没有上锁 or 已经解除蒙版 or 天气时钟卡片 显示编辑菜单
    if (!CardLockManager.getInstance().mainAppHasLock(formInfo.bundleName) ||
    CardLockManager.getInstance().getLockedCardIsReleased(formInfo.bundleName, formInfo.cardId) ||
    this.isThreeInOneCard(formInfo) || OverflowFormInfoUtil.isGameCard(formInfo)
    ) {
      this.checkEditForm(formInfo, menuInfoList, formManagerShowFrom);
    }
    this.checkLockForm(formInfo, menuInfoList);

    return menuInfoList;
  }

  private checkAddFormToDeskTopMenu(formInfo: CardItemInfo, menuInfoList: MenuInfo[],
    formManagerShowFrom: number): void {
    if (LayoutViewModel.getInstance().getDesktopModel() === DesktopLayoutState.SIMPLE_LAUNCHER_MODEL ||
    formInfo.isFormDimension1x4) {
      return;
    }
    const addFormToDeskTopMenu: MenuInfo = new MenuInfo();
    addFormToDeskTopMenu.menuType = CommonConstants.MENU_TYPE_FIXED;
    addFormToDeskTopMenu.menuImgSrc = '/common/pics/ic_form_center.svg';
    addFormToDeskTopMenu.menuText = $r('app.string.add_form_to_desktop_more');
    addFormToDeskTopMenu.onMenuClick = (appParams?: Map<string, Object>): void => {
      log.showInfo(TAG, 'Launcher click menu item into add form to desktop view');
      this.reportClickCardMenuEvent(formInfo, ShortcutMenuClickType.FORM_MANAGER);
      log.showInfo(TAG, 'Launcher click menu item into add form to desktop view');
      this.mFormModel.doBeforeJumpToFormManager(String(formInfo.bundleName)).then(() => {
        this.mViewManager.jumpToFormManagerView(formInfo as AppItemInfo, formManagerShowFrom);
      });
    };

    if (formInfo.page !== CommonConstants.WATERFALL_PAGE_INDEX) {
      menuInfoList.push(addFormToDeskTopMenu);
    }
  }

  private checkEditForm(formInfo: CardItemInfo, menuInfoList: MenuInfo[], formEditShowFrom: number): void {
    if (formInfo.formConfigAbility && !CheckEmptyUtils.checkStrIsEmpty(formInfo.formConfigAbility) &&
    formInfo.formConfigAbility.startsWith(CommonConstants.FORM_CONFIG_ABILITY_PREFIX, 0)) {
      const editForm = new MenuInfo();
      editForm.menuType = CommonConstants.MENU_TYPE_FIXED;
      editForm.menuImgSrc = '/common/pics/ic_public_edit.svg';
      editForm.menuText = $r('app.string.form_edit');
      editForm.onMenuClick = (): void => {
        log.showInfo(TAG, `Launcher click menu item into form edit view:${formInfo.formConfigAbility}`);
        this.reportClickCardMenuEvent(formInfo, ShortcutMenuClickType.EDIT);
        this.doEditClickMenu(formInfo, formEditShowFrom);
      };
      menuInfoList.push(editForm);
    }
  }

  private doEditClickMenu(formInfo: CardItemInfo, formEditShowFrom: number): void {
    if (this.isPad) {
      this.mFormModel.doBeforeJumpToFormManager(String(formInfo.bundleName)).then(() => {
        this.doAfterEditMenuClick(formInfo, formEditShowFrom);
      });
    } else {
      this.desktopContext?.eventHub.off(CommonConstants.EVENTHUB_FORM_MENU_DISAPPEAR);
      this.desktopContext?.eventHub.on(CommonConstants.EVENTHUB_FORM_MENU_DISAPPEAR, () => {
        this.desktopContext?.eventHub.off(CommonConstants.EVENTHUB_FORM_MENU_DISAPPEAR);
        log.showInfo(TAG, 'after disappear, do jump business');
        this.mFormModel.doBeforeJumpToFormManager(String(formInfo.bundleName)).then(() => {
          this.doAfterEditMenuClick(formInfo, formEditShowFrom);
        });
      });
    }
  }

  private checkLockForm(formInfo: CardItemInfo, menuInfoList: MenuInfo[]): void {
    if (!CheckEmptyUtils.isEmpty(formInfo) && !CheckEmptyUtils.isEmpty(menuInfoList) &&
    CardLockManager.getInstance().mainAppHasLock(formInfo.bundleName) &&
      !this.isThreeInOneCard(formInfo) && !OverflowFormInfoUtil.isGameCard(formInfo)
    ) {
      log.showInfo(TAG, `start to build cardLock`);
      menuInfoList.push(CardLockUtils.getInstance().buildAppLockMenu(formInfo));
    }
  }

  private isThreeInOneCard(item: CardItemInfo | GridLayoutItemInfo): boolean {
    return THREE_IN_ONE_CARDS.has(`${item.cardName}-${item.bundleName}-${item.abilityName}-${item.moduleName}`);
  }

  private doAfterEditMenuClick(formInfo: CardItemInfo, formEditShowFrom: number): void {
    const bundleName: string = formInfo.bundleName;
    const abilityName: string = formInfo.formConfigAbility?.slice(CommonConstants.FORM_CONFIG_ABILITY_PREFIX.length)
      ?? '';
    log.showWarn(TAG, `doAfterEditMenuClick. bundleName: ${bundleName}, abilityName: ${abilityName}`);

    // 区分新旧编辑页
    if (this.mFormEditViewManager.isFormEditExtensionAbility(bundleName, abilityName)) {
      this.openFormEditView(formInfo, formEditShowFrom);
    } else {
      this.jumpToForm(abilityName, bundleName, formInfo.moduleName, formInfo.cardId);
    }
  }

  private openFormEditView(formInfo: CardItemInfo, formEditShowFrom: number): void {
    this.mViewManager.jumpToFormEditView(formInfo as AppItemInfo, formEditShowFrom);
  }

  reportClickCardMenuEvent(formInfo: CardItemInfo, menuType: ShortcutMenuClickType): void {
    if (CheckEmptyUtils.isEmpty(formInfo) || CheckEmptyUtils.isEmptyArr(formInfo.area) ||
    CheckEmptyUtils.isEmpty(formInfo.cardDimension) || CheckEmptyUtils.isEmpty(formInfo.page)) {
      log.showWarn(TAG, 'report click card shortcut menu UE event failed, params is invalid.');
      return;
    }
    let formStyleConfig: FormStyleConfig = FormViewModel.getInstance(this.singleContext).getFormStyleConfig();
    let dpSize: string = formStyleConfig.mFormWidth?.get(formInfo.cardDimension.toString()) + '*' +
    formStyleConfig.mFormHeight?.get(formInfo.cardDimension.toString());

    let event: ClickCardShortcutMenuEvent = {
      packageName: formInfo.bundleName,
      area: formInfo.area ?? [],
      dpSize: dpSize,
      formId: formInfo.cardId,
      moduleName: formInfo.moduleName,
      formName: formInfo.cardName,
      menuType: menuType,
      // 普通卡片
      infoType: 0,
      sourceType: Extend1Data.getCardSourceType(formInfo.extend1),
      formType: FormCommonUtil.getFormType(formInfo?.gameCardInfo),
    };
    FormHiSysEventReporter.reportGoIntoCardShortcutMenu(event);
    FormHiSysEventUtil.reportIntoFormType('1');
  }

  buildRenameMenuInfoList(convertFolder: Function | null, menuCallback: Function, menuText: string | Resource,
    isConvertToSmall: boolean, isCanRenameFolder: boolean): Array<MenuInfo> {
    const menuInfoList = new Array<MenuInfo>();
    if (isCanRenameFolder) {
      const renameMenu = new MenuInfo();
      renameMenu.menuType = CommonConstants.MENU_TYPE_FIXED;
      renameMenu.menuImgSrc = StyleConstants.DEFAULT_RENAME_IMAGE;
      renameMenu.menuText = this.mResourceManager.getStringByName('rename_folder');
      renameMenu.onMenuClick = (): void => {
        log.showInfo(TAG, 'Launcher click menu to rename');
        menuCallback();
      };
      menuInfoList.push(renameMenu);
    }
    if (convertFolder && LayoutViewModel.getInstance().getDesktopModel() !== DesktopLayoutState.SIMPLE_LAUNCHER_MODEL) {
      const convertMenu = new MenuInfo();
      convertMenu.menuType = CommonConstants.MENU_TYPE_FIXED;
      convertMenu.menuImgSrc = isConvertToSmall ? StyleConstants.DEFAULT_CONVERT_IMAGE : StyleConstants.DEFAULT_ENLARGE_IMAGE;
      convertMenu.menuText = menuText;
      convertMenu.onMenuClick = (): void => {
        log.showInfo(TAG, 'Launcher click menu to convert');
        convertFolder();
      };
      menuInfoList.push(convertMenu);
    }
    return menuInfoList;
  }

  /**
   * Get PageDesktopStyleConfig.
   */
  getPageDesktopStyleConfig(): PageDesktopGridStyleConfig {
    return this.pageDesktopStyleConfig;
  }

  getIconSize(): number {
    return this.pageDesktopStyleConfig.mIconSize;
  }

  /**
   * Get workSpaceWidth.
   */
  getWorkSpaceWidth(): number | undefined {
    return AppStorage.get('workSpaceWidth');
  }

  /**
   * Get workSpaceHeight.
   */
  getWorkSpaceHeight(): number | undefined {
    return AppStorage.get('workSpaceHeight');
  }

  /**
   * Set workSpaceWidth.
   *
   * @param workSpaceWidth
   */
  setWorkSpaceWidth(workSpaceWidth: number): void {
    AppStorage.setOrCreate('workSpaceWidth', workSpaceWidth);
  }

  /**
   * Set workSpaceHeight.
   *
   * @param workSpaceHeight
   */
  setWorkSpaceHeight(workSpaceHeight: string): void {
    AppStorage.setOrCreate('workSpaceHeight', workSpaceHeight);
  }

  /**
   * Get getAppPageStartConfig.
   */
  getAppPageStartConfig(): string {
    return this.mSettingsModel.getAppPageStartConfig();
  }


  private startAppWithIndex(abilityName: string, bundleName: string, moduleName: string, appIndex?: number): void {
    if (appIndex !== undefined && appIndex > 0) {
      let params: Map<string, Number> = new Map();
      params.set(SCBConstants.START_APP_CLONE_INDEX, appIndex);
      this.jumpTo(abilityName, bundleName, moduleName, params);
    } else {
      this.jumpTo(abilityName, bundleName, moduleName);
    }
  }

  /**
   * click event
   *
   * @param abilityName ability name
   * @param bundleName bundle name
   */
  onAppClick(abilityName: string, bundleName: string, moduleName: string, appIndex?: number): void {
    if (!this.isPad) {
      this.startAppWithIndex(abilityName, bundleName, moduleName, appIndex);
      return;
    }
    AppStorage.setOrCreate('selectDesktopAppItem', bundleName);
  }

  /**
   * double click event
   *
   * @param abilityName ability name
   * @param bundleName bundle name
   */
  private onAppDoubleClick(startAppItem: StartAppType): void {
    this.startAppWithIndex(startAppItem.abilityName ?? '', startAppItem.bundleName ?? '',
      startAppItem.moduleName ?? '', startAppItem.appIndex);
  }

  /**
   * other app publish card to pageDesktop
   *
   * @param parameters
   */
  async publishCardToDesktop(parameters: Record<string, object>): Promise<void> {
    log.showDebug(TAG, 'publishCardToDesktop');
    const formItem: CardItemInfo = await FormManager.getInstance().getFormCardItemByWant(parameters);
    // 桌面卡片超限时，负一屏点击添加到桌面场景当前在桌面拦截，后续返回错误码需求适配后，由负一屏实现弹窗逻辑
    if (this.mFormModel.checkIfCardExceedLimit()) {
      this.mFormModel.deleteFormByFormID(formItem.id);
      FormManager.getInstance().setPublishFormResult(formItem.id, formInfo.PublishFormErrorCode.NO_SPACE);
      return;
    }
    if (formItem.callerBundle === CommonConstants.INTELLIGENT_BUNDLE) {
      let resultCode: number = await this.createCardToDeskTop(formItem, undefined,
        (position: number[], page?: number, screenSelectType?: number) => {
          if (page === undefined || screenSelectType === undefined) {
            log.showWarn(TAG, `fail to report intelligent add card UE event, page=${page}, screenType=${screenSelectType}`);
            return;
          }
          FormViewModel.getInstance(this.singleContext).reportIntelligentAddCardEvent(formItem, position, page, screenSelectType);
        });
      FormManager.getInstance().setPublishFormResult(formItem.id, resultCode);
      return;
    }
    const wantParamInterface: AppFormWantParamInterface = await FormManager.getInstance().getAppFormWantParamInterface(parameters);
    if (!CheckEmptyUtils.isEmpty(wantParamInterface.appFormSnapshot)) {
      this.publishAppCardToDesktop(formItem, wantParamInterface);
      return;
    }
    log.showInfo(TAG, 'the card do not support animation, create it immediately.');
    let resultCode: number = await this.createCardToDeskTop(formItem);
    FormManager.getInstance().setPublishFormResult(formItem.id, resultCode);
  }

  /**
   * 应用内卡片加桌
   *
   * @param formItem 加桌卡片
   * @param wantParamInterface 应用加桌卡片动效参数
   */
  private async publishAppCardToDesktop(formItem: CardItemInfo, wantParamInterface: AppFormWantParamInterface): Promise<void> {
    log.showInfo(TAG, 'add app form to desktop.');
    FormCenterViewManager.getInstance().setOpenAddFormViewSource(CardAddType.APP);
    formItem.cardId = formItem.id ?? '';
    formItem.cardDimension = formItem.dimension;
    formItem.area = FormManager.getInstance().getCardSize(formItem.cardDimension);
    // 转化并存snapShot
    this.viewModelUtils.base64ToPixelMap(wantParamInterface.appFormSnapshot).then((pixelMap: image.PixelMap | null) => {
      if (pixelMap) {
        log.showInfo(TAG, 'snapshot from base64 string to pixelMap success.');
        const imageCacheKey: string = `${formItem.cardId}${formItem.bundleName}${formItem.moduleName}`;
        ResourceManager.getInstance().setAppResourceCache(imageCacheKey, 'cardSnapshot', pixelMap);
      } else {
        log.showWarn(TAG, 'snapshot from base64 string to pixelMap fail, pixelMap is null.');
      }
    }).catch(() => {
      log.showInfo(TAG, 'add app form to desktop fail, base64ToPixelMap error.');
      return;
    });

    // 关闭全搜
    if (sOutSideWindowMgr.isShowGlobalSearch()) {
      sOutSideWindowMgr.hideGlobalSearch(false);
    }

    // 关闭负一屏
    if (sOutSideWindowMgr.isShowNegative() && !sOutSideWindowMgr.getDesktopEnabled()) {
      GlobalContext.getContext()?.eventHub?.emit(EVENT_INTELLIGENT_CLOSE_SCB);
    }

    // 加桌做动效
    let resultCode = await this.createCardWithAnimation(
      formItem,
      CommonConstants.DRAG_FROM_APP,
      px2vp(wantParamInterface.appFormScreenX) + px2vp(wantParamInterface.appFormWidth) / 2,
      px2vp(wantParamInterface.appFormScreenY) + px2vp(wantParamInterface.appFormHeight) / 2,
      true
    );
    FormManager.getInstance().setPublishFormResult(formItem.id, resultCode);
  }

  private checkAndHandleMaxPage(layoutDescription: LayoutDescription, negId: number, cardId: string): boolean {
    if (layoutDescription.pageCount + 1 > layoutDescription.maxPage) {
      HiSysEventUtil.reportFullContinueAdding(DisplayConstants.DEFAULT_DISPLAY);
      promptAction.showToast({
        message: this.mResourceManager.getStringByName('add_icon_to_desktop_max'),
        showMode: 2
      });
      const dragItemType: number | undefined = AppStorage.get<number>('dragItemType');
      if (dragItemType && dragItemType === CommonConstants.DRAG_FROM_FORM_INTELLIGENT) {
        localEventManager.sendLocalEventSticky(EventConstants.EVENT_RESUME_INTELLIGENT_CARD, {
          'id': negId
        });
      }
      this.mFormModel.deleteForm(cardId);
      log.showWarn(TAG, 'createCardToDeskTop fail, maxPage');
      TraceUtil.endTrace(DomainName.SCB, TraceUtil.CORE_METHOD_CREATE_CARD);
      return true;
    }
    return false;
  }

  private getCardItemLayoutInfoForPad(cardItemInfo: CardItemInfo): boolean {
    let pages: number[] = this.getPagesWhenAddCard();
    let gridLayoutItem: GridLayoutItemInfo = cardItemInfo as object as GridLayoutItemInfo;
    let pageCount: number = this.mLauncherLayoutCacheManager.selectPageCount();
    // page[0]当前页，如果不是最后一页，需要判断当前页和下一页的加卡空位
    if (pageCount !== pages[0] + 1) {
      let findBlankPosition: boolean = this.mPageDesktopModel.findBlankPosition(pages[0], pages[0] + 2, gridLayoutItem);
      if (findBlankPosition) {
        cardItemInfo.page = gridLayoutItem.page;
        cardItemInfo.row = gridLayoutItem.row;
        cardItemInfo.column = gridLayoutItem.column;
        this.changeSwiperIndex(cardItemInfo.page ?? 0);
        return false;
      }
      cardItemInfo.column = 0;
      cardItemInfo.row = 0;
      cardItemInfo.landscapeRow = 0;
      cardItemInfo.landscapeColumn = 0;
      cardItemInfo.portraitRow = 0;
      cardItemInfo.portraitColumn = 0;
      cardItemInfo.page = pages[1] + 1;
      cardItemInfo.landscapePage = pages[1] + 1;
      cardItemInfo.portraitPage = pages[1] + 1;
      this.changeSwiperIndex(pages[1] + 1);
      return true;
    }
    // 如果是最后一页，只判断当前页，如果没有位置直接加页
    let findBlankPosition: boolean = this.mPageDesktopModel.findBlankPosition(pages[0], pages[0] + 1, gridLayoutItem);
    if (findBlankPosition) {
      cardItemInfo.page = gridLayoutItem.page;
      cardItemInfo.row = gridLayoutItem.row;
      cardItemInfo.column = gridLayoutItem.column;
      this.changeSwiperIndex(cardItemInfo.page ?? 0);
      return false;
    }
    cardItemInfo.column = 0;
    cardItemInfo.row = 0;
    cardItemInfo.landscapeRow = 0;
    cardItemInfo.landscapeColumn = 0;
    cardItemInfo.portraitRow = 0;
    cardItemInfo.portraitColumn = 0;
    cardItemInfo.page = pages[1] + 1;
    cardItemInfo.landscapePage = pages[1] + 1;
    cardItemInfo.portraitPage = pages[1] + 1;
    this.changeSwiperIndex(pages[1] + 1);
    return true;
  }

  /**
   * add card to pageDesktop
   *
   * @param appInfo
   */
  async createCardToDeskTop(formCardItem: CardItemInfo | GridLayoutItemInfo, callback?: Callback<void>,
    setPositionBack?: (position: number[], page?: number, screenSelectType?: number) => void): Promise<number> {
    TraceUtil.startTrace(DomainName.SCB, TraceUtil.CORE_METHOD_CREATE_CARD);
    if (JSON.stringify(formCardItem) === '{}' || CheckEmptyUtils.isEmpty(formCardItem)) {
      log.showInfo(TAG, 'createCardToDeskTop with null formCardItem');
      callback?.();
      TraceUtil.endTrace(DomainName.SCB, TraceUtil.CORE_METHOD_CREATE_CARD);
      this.desktopContext?.eventHub.emit('waitFormManagerResponse', FormManageResponse.CREATE_FORM_FAILED);
      return formInfo.PublishFormErrorCode.PARAM_ERROR;
    }
    // 关闭全搜
    if (sOutSideWindowMgr.isShowGlobalSearch()) {
      sOutSideWindowMgr.hideGlobalSearch(false);
    }
    if (this.keyBoardStatus !== FeatureConstants.NO_KEYBOARD) {
      formCardItem.page = this.keyBoardStatus;
    }
    const cardItemInfo = this.viewModelUtils.createNewCardItemInfo(formCardItem as CardItemInfo);
    cardItemInfo.container = CommonConstants.CONTAINER_DESKTOP;
    cardItemInfo.area = FormManager.getInstance().getCardSize(cardItemInfo.cardDimension, cardItemInfo.isFormDimension1x4);
    cardItemInfo.page = formCardItem.page ? formCardItem.page : 0;
    cardItemInfo.row = formCardItem.row ? formCardItem.row : 0;
    cardItemInfo.column = formCardItem.column ? formCardItem.column : 0;
    log.showInfo(TAG, `createCardToDeskTop page: ${cardItemInfo.page}, row: ${cardItemInfo.row}, column: ${cardItemInfo.column}`);

    let needNewPage: boolean = false;
    // row and column is undefined or null
    if (!formCardItem.row && formCardItem.row !== 0 && !formCardItem.column && formCardItem.column !== 0) {
      log.showInfo(TAG, 'createCardToDeskTop with null needNewPage');
      needNewPage = DeviceHelper.isPad() ? this.getCardItemLayoutInfoForPad(cardItemInfo) : this.getCardItemLayoutInfo(cardItemInfo);
    }
    log.showInfo(TAG, `createCardToDeskTop start, cardId:${formCardItem?.cardId}, bundleName: ${formCardItem?.bundleName}`);
    let layoutDescription: LayoutDescription = this.mLauncherLayoutCacheManager.selectLayoutDescription();
    let pageUpdateCallBack: Function | undefined = undefined;
    if (needNewPage) {
      if (this.checkAndHandleMaxPage(layoutDescription, (formCardItem as GridLayoutItemInfo).negativeId, cardItemInfo.cardId)) {
        callback?.();
        this.desktopContext?.eventHub.emit('waitFormManagerResponse', FormManageResponse.NO_ENOUGH_AREA);
        return formInfo.PublishFormErrorCode.NO_SPACE;
      } else {
        pageUpdateCallBack = (): void => {
          this.updatePageAfterCreateCardToDesktop(needNewPage, layoutDescription, cardItemInfo);
        };
      }
    }
    ContractedFolderCommonViewModel.getInstance().closeFolder('create card to desktop to close');
    launcherStatusUtil.drawerPageAnimatedOut();
    setPositionBack?.([cardItemInfo.row, cardItemInfo.column],
      this.keyBoardStatus !== FeatureConstants.NO_KEYBOARD ? this.keyBoardStatus : cardItemInfo.page,
      this.getScreenSelectType(needNewPage, this.mPageIndex, cardItemInfo.page));
    this.updateFormLabel(cardItemInfo);
    await this.updateAfterUpdateForm(needNewPage, cardItemInfo, pageUpdateCallBack, callback);
    // 回调结束后销毁临时状态
    this.createCardState = false;
    log.showInfo(TAG, 'createCardToDeskTop end');
    TraceUtil.endTrace(DomainName.SCB, TraceUtil.CORE_METHOD_CREATE_CARD);
    if (cardItemInfo.bundleName === CommonConstants.THEME_MANAGER_BUNDLE) {
      // 主题卡打点
      log.showInfo(TAG, 'themeCard added, start checkScbOnlineTheme');
      const serviceManager = new ThemeServiceManager(getContext(this) as common.UIAbilityContext);
      serviceManager.checkScbOnlineTheme();
    }
    let addCardResText: string = ResUtils.getInnerString($r('app.string.add_card_success_desktop'));
    let positionText: string = ResUtils.getInnerStringNumS($r('app.string.drag_drop'), '', String(cardItemInfo.row + 1),
      String(cardItemInfo.column + 1));
    let announcedText: string = `${addCardResText}${positionText}`;
    AccessibilityManager.getInstance().sendTextAnnouncedForAccessibility(announcedText, 'textAnnouncedAddCardToDesktop');
    return formInfo.PublishFormErrorCode.SUCCESS;
  }

  private needWriteRdb(cardId: string): boolean {
    // 单点修改PC加卡会连续两次更新数据库,概率出现第一次插入慢导致更新失败问题
    if (DeviceHelper.isPC() && this.mFormModel.isCardIdInvalid(cardId)) {
      return false;
    }
    return true;
  }

  private async updateAfterUpdateForm(needNewPage: boolean, cardItemInfo: CardItemInfo,
    pageUpdateCallBack?: Function, callback?: Callback<void>): Promise<void> {
    this.desktopContext?.eventHub.emit('waitFormManagerResponse', FormManageResponse.CREATE_FORM_SUCCESS);
    this.createCardState = true;
    if (!needNewPage) {
      callback?.();
    }
    // Push card into the layoutInfo
    pageUpdateCallBack?.();
    if (cardItemInfo.shortcutInfo === undefined || CheckEmptyUtils.isEmpty(cardItemInfo.shortcutInfo)) {
      FormLayoutCacheManager.getInstance().addCardItemToDesktop(cardItemInfo,
        BusinessType.BUSINESS_CARD, this.needWriteRdb(cardItemInfo.cardId));
      FormViewModel.getInstance().addFormInfoToFormList(cardItemInfo);
    } else {
      let shortcutInfo: ShortcutInfo = cardItemInfo.shortcutInfo;
      let appLabel: string = await ResourceManager.getInstance().getAppNameSync(shortcutInfo.labelId, shortcutInfo.bundleName,
        shortcutInfo.moduleName, cardItemInfo.appName, shortcutInfo.appIndex);
      let itemInfo: GridLayoutItemInfo = this.convertToGridLayoutItemInfo(cardItemInfo, appLabel);
      this.mLauncherLayoutCacheManager.insertGridLayoutItemInfo(itemInfo, BusinessType.BUSINESS_BASIC_DESKTOP, true);
    }
    this.lightPagingFiltering(true);
    if (needNewPage) {
      // 更新其他元素的页数
      callback?.();
    }
  }

  /**
   * 从卡片管理加桌快捷方式到桌面创建布局信息
   * @param cardItem 卡片信息
   * @param appLabel 快捷方式名称
   * @returns 快捷方式布局信息
   */
  private convertToGridLayoutItemInfo(cardItem: CardItemInfo, appLabel: string): GridLayoutItemInfo {
    // 创建布局信息
    let itemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
    let shortcutInfo: ShortcutInfo | undefined = cardItem.shortcutInfo;
    if (shortcutInfo === undefined || CheckEmptyUtils.isEmpty(shortcutInfo)) {
      return itemInfo;
    }
    // 无图标应用
    itemInfo.bundleName = shortcutInfo.bundleName ?? '';
    itemInfo.abilityName = shortcutInfo.hostAbility ?? '';
    itemInfo.appIndex = shortcutInfo.appIndex ?? 0;
    itemInfo.container = CommonConstants.CONTAINER_DESKTOP;
    itemInfo.moduleName = shortcutInfo.moduleName ?? '';
    itemInfo.isUninstallAble = true;

    //选中态,pc专用属性
    itemInfo.isSelect = false;
    itemInfo.container = CommonConstants.CONTAINER_DESKTOP;
    itemInfo.typeId = CommonConstants.TYPE_SHORTCUT_ICON;
    itemInfo.appIconId = shortcutInfo.iconId ?? 0;
    itemInfo.appLabelId = shortcutInfo.labelId;
    itemInfo.shortcutId = shortcutInfo.id;
    itemInfo.appName = shortcutInfo.sourceType === 0 ? shortcutInfo.label : appLabel;
    itemInfo.iconResource = shortcutInfo.sourceType === 0 ? shortcutInfo.icon : undefined;
    itemInfo.area = [1, 1];
    itemInfo.intent = `{"sourceType": "${shortcutInfo.sourceType}"}`;
    itemInfo.keyName = AppItemInfo.getKeyName(itemInfo);
    itemInfo.infoId = RdbStoreManager.getInstance().generateRandomUUID();
    (itemInfo as Object as AppItemInfo).appId = itemInfo.infoId;

    itemInfo.page = cardItem.page;
    itemInfo.row = cardItem.row;
    itemInfo.column = cardItem.column;

    return itemInfo;
  }

  private updatePageAfterCreateCardToDesktop(isNeedNewPage: boolean, layoutDescription: LayoutDescription,
    updateCard: CardItemInfo): void {
    let foldOpen: boolean = desktopUtil.isFoldExpandStatus() || this.isBigScreen;
    let pages: number[] = this.getPagesWhenAddCard();
    let pageInfoManager: PageInfoManager = PageInfoManager.getInstance();
    // 是否是三屏状态
    const displayCount: number = pageInfoManager.getDisplayCount();
    const isThreeScreen: boolean = displayCount === StyleConstants.DEFAULT_3;
    if (isNeedNewPage) {
      let pageCount: number = layoutDescription.pageCount;
      let onlyAddOne: boolean = false;
      if (foldOpen) {
        if ((pageCount % 2 !== 0) && (pages[1] >= pageCount - 3)) {
          pageCount = pageCount + 1;
          onlyAddOne = true;
        } else {
          pageCount = pageCount + (isThreeScreen ? displayCount : 2);
        }
      } else {
        pageCount = pageCount + 1;
      }

      if (onlyAddOne) {
        this.mLauncherLayoutCacheManager.updatePageCount(pageCount, BusinessType.BUSINESS_CARD, true);
      }

      let currentIndex: number = foldOpen ? (pages[1] + 1) : pages[1];
      currentIndex = isThreeScreen ? (pages[1] + NumberConstants.CONSTANT_NUMBER_TWO) : currentIndex;
      let pageAddNum: number = foldOpen ? NumberConstants.CONSTANT_NUMBER_TWO : 1;
      pageAddNum = isThreeScreen ? NumberConstants.CONSTANT_NUMBER_THREE : pageAddNum;
      let cardItemInfo: GridLayoutItemInfo = updateCard as object as GridLayoutItemInfo;
      this.mLauncherLayoutCacheManager.updateLayoutAfterAddPage(currentIndex, pageAddNum, BusinessType.BUSINESS_CARD, true,
        true, [cardItemInfo]);
      this.mLauncherLayoutCacheManager.updatePageCount(pageCount, BusinessType.BUSINESS_CARD, true);
    }
  }

  private getScreenSelectType(needNewPage: boolean, currentPageIndex: number, selectedPageIndex: number): number {
    if (needNewPage) {
      return ScreenSelectType.CREATE;
    }
    return currentPageIndex === selectedPageIndex ? ScreenSelectType.CURRENT : ScreenSelectType.NEXT;
  }

  /**
   * toast show default height
   */
  public getToastBottom(): number {
    if (DeviceHelper.isPC()) {
      return LayoutViewModel.getInstance().getDockHeight() + CommonConstants.TOAST_SHOW_DEFAULT_HEIGHT;
    }
    return NumberConstants.CONSTANT_NUMBER_ZERO_POINT_ONE_THREE * Number(AppStorage.get('screenHeight'));
  }

  /**
   * delete card from pageDesktop
   *
   * @param cardId
   */
  private async deleteFormItem(cardId: string): Promise<void> {
    log.showInfo(TAG, `deleteFormItem start.cardId=${cardId}`);
    this.mFormModel.deleteForm(cardId).then(() => {
      log.showInfo(TAG, `deleteFormItem success.cardId=${cardId}`);
      this.lightPagingFiltering(false, SceneMsgEnum.SCENE_MSG_DELETE_FORM_ITEM);
    }).catch((error: Error) => {
      log.showError(TAG, 'deleteFormItem, error:' + JSON.stringify(error));
    });
  }

  /**
   * delete card from pageDesktop
   *
   * @param cardId
   */
  private async deleteFormItemEvent4Intelligent(cardId: string): Promise<void> {
    log.showInfo(TAG, `deleteFormItemEvent4Intelligent start.cardId=${cardId}`);
    this.mFormModel.deleteForm(cardId, true).then(() => {
      log.showInfo(TAG, `deleteFormItemEvent4Intelligent success.cardId=${cardId}`);
      this.lightPagingFiltering(false, SceneMsgEnum.SCENE_MSG_DELETE_FORM_ITEM);
    }).catch((error: Error) => {
      log.showError(TAG, 'deleteFormItemEvent4Intelligent, error:' + JSON.stringify(error));
    });
  }

  private removeBottomBarInfo(pageDesktopInfo: GridLayoutItemInfo[], isOuter: boolean): void {
    let bottomAppList: DockItemInfo[] = [];
    if (!isOuter) {
      bottomAppList = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
    }
    log.showInfo(TAG, `removeBottomBarInfo bottomAppList length: ${bottomAppList.length}`);
    if (!CheckEmptyUtils.isEmptyArr(bottomAppList)) {
      for (let i = 0; i < bottomAppList.length; i++) {
        log.showInfo(TAG, `removeBottomBarInfo bottomAppList[${i}]: ${bottomAppList[i].keyName}`);
        if (bottomAppList[i].itemType === CommonConstants.TYPE_FOLDER) {
          let smallFolderAppList = bottomAppList[i].layoutInfo;
          if (!smallFolderAppList) {
            return;
          }
          for (let j = 0; j < smallFolderAppList.length; j++) {
            for (let k = 0; k < smallFolderAppList[j].length; k++) {
              log.showDebug(TAG, `removeBottomBarInfo smallFolderAppList[${j}][${k}]: ${JSON.stringify(smallFolderAppList[j][k])}`);
              const appInfo = pageDesktopInfo.find(item => {
                if (!smallFolderAppList) {
                  return;
                }
                if (!GridLayoutUtil.isAppInstalled(smallFolderAppList[j][k])) {
                  return item.bundleName === smallFolderAppList[j][k].bundleName && item.appIndex === smallFolderAppList[j][k].appIndex;
                }
                if (item.keyName === smallFolderAppList[j][k].keyName) {
                  return true;
                }
                return false;
              });
              if (appInfo) {
                const index = pageDesktopInfo.indexOf(appInfo);
                pageDesktopInfo.splice(index, 1);
              }
            }
          }
        }
        const appInfo = pageDesktopInfo.find(item => {
          if (!GridLayoutUtil.isAppInstalled(bottomAppList[i])) {
            return item.bundleName === bottomAppList[i].bundleName && item.appIndex === bottomAppList[i].appIndex;
          }
          if (item.keyName === bottomAppList[i].keyName) {
            return true;
          }
          return false;
        });
        if (appInfo) {
          const index = pageDesktopInfo.indexOf(appInfo);
          pageDesktopInfo.splice(index, 1);
        }
      }
    }
  }

  private changeAppInstallTime(appInfo: GridLayoutItemInfo): void {
    let pageDesktopInfo: GridLayoutItemInfo[] = this.mSettingsModel.getAppListInfo();
    pageDesktopInfo.forEach((item) => {
      if (item.bundleName === appInfo.bundleName && item.appIndex === appInfo.appIndex) {
        log.showInfo(TAG, `changeAppInstallTime, pageInfo: ${JSON.stringify(item)}`);
        log.showInfo(TAG, `changeAppInstallTime, appInfo: ${JSON.stringify(appInfo)}`);
        item.applicationLabelId = appInfo.applicationLabelId ?? item.applicationLabelId;
        item.appIconId = appInfo.appIconId ?? item.appIconId;
        item.appLabelId = appInfo.appLabelId ?? item.appLabelId;
        item.isUninstallAble = appInfo.isUninstallAble ?? item.isUninstallAble;
        item.isSystemApp = appInfo.isSystemApp ?? item.isSystemApp;
        item.moduleName = appInfo.moduleName ?? item.moduleName;
        item.abilityName = appInfo.abilityName ?? item.abilityName;
        item.appIndex = appInfo.appIndex ?? item.appIndex;
        item.appStatus = appInfo.appStatus ?? item.appStatus;
        item.intent = appInfo.intent ?? item.intent;
        item.installTime = String(new Date());
      }
    });
    this.mSettingsModel.setAppListInfo(pageDesktopInfo);
  }

  uninstallApp(uninstallBundleName: string, isUninstallable: boolean, appIndex?: number, forceUninstall?: boolean,
    showToast?: boolean): void {
    let tmpAppIndex = appIndex ?? 0;
    if (isUninstallable) {
      this.unInstallList.add(`${uninstallBundleName}${tmpAppIndex}`);
    }
    this.mUninstallListeners.forEach(listener => listener?.uninstallApp(uninstallBundleName, tmpAppIndex, ''));
    log.showInfo(TAG, `pagedesktopviewmode uninstallApp ${uninstallBundleName} ${tmpAppIndex} ${isUninstallable}`);
    super.uninstallApp(uninstallBundleName, isUninstallable, tmpAppIndex, forceUninstall, showToast);
    // 卸载主应用时，同步移除未安装完成的分身应用
    if (tmpAppIndex === 0) {
      this.deleteNotInstallApp(true, uninstallBundleName, tmpAppIndex, false);
    }
  }

  uninstallAppResult(bundleName: string, resultData: ResponseCode, appIndex?: number): void {
    this.mUninstallListeners.forEach(listener =>
    listener?.uninstallAppResult(bundleName, resultData?.code, appIndex, ''));
    // 卸载成功或失败，都把卸载的的缓存数据清理掉
    let isUnInstallApp: boolean = this.unInstallList.delete(`${bundleName}${appIndex ?? 0}`);
    if (isUnInstallApp && resultData?.code === -1 &&
      !this.isFail4LockedAppInFolder(bundleName, resultData?.errorCode)) {
      log.showInfo(TAG, `uninstallAppResult1 ${bundleName} ${appIndex} resultCode: ${resultData?.code}`);
      // 桌面上的应用卸载失败不需要重新加桌流程
      let selectItemInDesktop: GridLayoutItemInfo[] =
        LaunchLayoutCacheManager.getInstance().selectGridLayoutItemsByBundleNameAndAppIndex(bundleName, 0, false);
      if (!CheckEmptyUtils.isEmptyArr(selectItemInDesktop)) {
        return;
      }
      // 卸载失败需要清除文件夹和dock，同时应用重新在桌面找位。
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_FOLDER_PACKAGE_REMOVED, {
        bundleName: bundleName,
        keyName: undefined,
        appIndex: appIndex,
      });
      // delete app from dock
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_RESIDENT_DOCK_ITEM_DELETE, {
        bundleName: bundleName,
        keyName: undefined,
        isDeleteAppToUninstallFolder: true,
        appIndex: appIndex,
      });
      this.loadGridList(SceneMsgEnum.SCENE_MSG_UNINSTALL_APP);
    }
    log.showWarn(TAG, `uninstallAppResult ${bundleName} ${appIndex} resultCode: ${resultData?.code}`);
  }

  private isFail4LockedAppInFolder(bundleName: string, errorCode: number): boolean {
    return lockedAppUninstallModel.isUninstallLockedApp(bundleName) && errorCode === APP_LOCKED_ERROR_CODE;
  }

  public deletePage(page: number, isOuter: boolean): void {
    let ret: boolean = this.mPageDesktopModel.deleteBlankPageFromLayoutInfo(page, isOuter);
    if (ret) {
      const curPageIndex = this.mPageDesktopModel.getPageIndex(isOuter);
      log.showInfo(TAG, 'deletePageIndex' + curPageIndex);
      this.mPageDesktopModel.setPageIndex((curPageIndex > 0) ? (curPageIndex - 1) : curPageIndex, isOuter);
    }
  }

  public refreshScreen(sceneMsg: string = SceneMsgEnum.SCENE_MSG_DEFAULT_REFRESH): void {
    log.showInfo(TAG, `refreshScreen is executed when ${sceneMsg}`);
    this.highFrequencyStatistics.record('refreshScreen');
    let allGridLayoutItems = this.mLauncherLayoutCacheManager.getAllGridLayoutItemList(
      BusinessType.BUSINESS_BASIC_DESKTOP, false);
    this.mSettingsModel.setAppListInfo(allGridLayoutItems, false);
    // 将一维数组整理到不同的swiper中
    const allRankedAppInfos = this.integrateSwiper(allGridLayoutItems, false);
    let desktopLayoutInfo: GridAppListInfoNew = {
      appGridInfo: allRankedAppInfos.gridAppsInfos,
      waterfallItemListInfo: allRankedAppInfos.waterfallAppInfos
    };
    AppStorage.SetOrCreate('selectDesktopAppItem', '');
    AppStorage.SetOrCreate('selectItem', '');
    LayoutViewModel.getInstance().updateDesktopLayoutData(desktopLayoutInfo, 'refreshScreenForInnerScreen', false);
    log.showInfo(TAG, 'Refresh Inner Screen');
  }

  checkAndUpdateConfig(desktopFiles: DesktopFileInfo[]): void {
    log.showInfo(TAG, `checkAndUpdateConfig start, desktopFiles: ${desktopFiles.length}`);
    let updatedFileItems: GridLayoutItemInfo[] = [];
    let deletedItems: GridLayoutItemInfo[] = [];
    this.mLauncherLayoutCacheManager.checkAndDeleteNotInFileAndFolder(desktopFiles, updatedFileItems, deletedItems,
      BusinessType.BUSINESS_BASIC_DESKTOP);
    LauncherLayoutCacheUtil.updateItemWithContainerCallBack(updatedFileItems, CommonConstants.CONTAINER_DESKTOP);
    let newAddedList: GridLayoutItemInfo[] = new Array<GridLayoutItemInfo>();
    // add new file and folder
    this.addNewFileAndFolder(desktopFiles, newAddedList);
    // pc横屏新建文件，需要刷新竖屏重排位置
    newAddedList = LauncherLayoutCacheUtil.getChangeItems(newAddedList);
    RdbStoreManager.getInstance().insertGridLayoutInfo(newAddedList);
    localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_PAGEDESK_LIGHT_REFRESH, null);
    if (updatedFileItems.length !== 0) {
      log.showInfo(TAG, 'checkAndUpdateConfig: dispatchFileInfoUpdate');
      fileInfoUpdateManager.dispatchFileInfoUpdate(updatedFileItems);
    }
  }

  private addNewFileAndFolder(desktopFiles: DesktopFileInfo[], newAddedList: GridLayoutItemInfo[]): void {
    this.fileMapForInoByUri.clear();
    let isDesktopHasFreeSpace: boolean = true;
    for (let fileInfo of desktopFiles) {
      if (!fileInfo) {
        continue;
      }
      let itemInCache = this.mLauncherLayoutCacheManager.selectGridLayoutItemByIno(fileInfo.ino);
      if (itemInCache) {
        log.showInfo(TAG, `${itemInCache.infoName}/${itemInCache.infoId} is region folder, do not add file/folder`);
        continue;
      }
      this.fileMapForInoByUri.set(fileInfo.uri, fileInfo.ino ?? '');
      if (!isDesktopHasFreeSpace) {
        this.pasteSelectItems.remove(fileInfo.uri);
        continue;
      }
      if (!this.mLauncherLayoutCacheManager.isGridInfoHasMedia(fileInfo)) {
        let fileColumnAndRow: number[] = [];
        this.initFileColumnAndRow(fileColumnAndRow, fileInfo);
        let fileFolderItem: GridLayoutItemInfo = new GridLayoutItemInfo();
        fileFolderItem.keyName = fileInfo.ino;
        fileFolderItem.fileFolderName = fileInfo.fileName;
        fileFolderItem.uri = fileInfo.uri;
        fileFolderItem.typeId = CommonConstants.TYPE_FILE_FOLDER;
        fileFolderItem.container = CommonConstants.CONTAINER_DESKTOP;
        fileFolderItem.fileType = fileInfo.fileType;
        fileFolderItem.column = fileColumnAndRow[0];
        fileFolderItem.row = fileColumnAndRow[1];
        fileFolderItem.area = [1, 1];
        fileFolderItem.appIconId = fileInfo.thumbnail ?? 0;
        fileFolderItem.ino = fileInfo.ino;
        fileFolderItem.isSelect = false;
        fileFolderItem.size = fileInfo.size;
        fileFolderItem.ctime = fileInfo.ctime;
        fileFolderItem.mtime = fileInfo.mtime;
        fileFolderItem.infoId = fileInfo.ino;
        log.showInfo(TAG, `checkAndUpdateConfig fileFolderItem ino: ${fileFolderItem.ino}`);
        const beforeAddListLen: number = newAddedList.length;
        this.updateFileFolderItemLayoutInfo(fileFolderItem, newAddedList, fileInfo.page);
        this.multipleDragSettings.deleteDragItem(fileInfo.ino ?? '');
        if (newAddedList.length === beforeAddListLen) {
          // 找位前后新增长度相等，说明桌面已无空位
          this.pasteSelectItems.remove(fileInfo.uri);
          isDesktopHasFreeSpace = false;
        }
      }
    }
  }

  private initFileColumnAndRow(fileColumnAndRow: number[], fileInfo: DesktopFileInfo): void {
    if (!CheckEmptyUtils.isEmpty(fileInfo.column) && !CheckEmptyUtils.isEmpty(fileInfo.row)) {
      fileColumnAndRow[0] = fileInfo.column ?? 0;
      fileColumnAndRow[1] = fileInfo.row ?? 0;
    } else {
      const item: MultipleDragPosition | undefined = this.multipleDragSettings.getDragItemByUri(fileInfo.ino ?? '');
      fileColumnAndRow[0] = item?.position.column ?? 0;
      fileColumnAndRow[1] = item?.position.row ?? 0;
      fileInfo.page = item?.position.page ?? 0;
    }
  }

  /**
   * 获取桌面获焦状态
   *
   * @returns true/false
   */
  public getDesktopFocusState(): boolean {
    return this.mIsDesktopFocused;
  }

  private updateDesktopFocusState(status: boolean): void {
    log.showInfo(TAG, `updateDesktopFocusState: ${status}`);
    this.mIsDesktopFocused = status;
    if (this.fileFolderManager && status) {
      this.fileFolderManager?.tryToLoadDesktopFiles('updateDesktopFocusState');
    }

    // 仅需设置首个元素获焦
    let setFocusResult: boolean = false;
    for (let index = 0; index < this.lastSelectedItems.length; index++) {
      if (this.selectChangeListeners.has(this.lastSelectedItems[index])) {
        this.selectChangeListeners.get(this.lastSelectedItems[index])?.onFocusStatusChange(status);
        if (!setFocusResult) {
          setFocusResult = this.mFocusViewModel.setFocus(this.lastSelectedItems[0], true);
        }
      }
    }
    if (status) {
      this.focusFlag = false;
      setTimeout(() => {
        this.focusFlag = true;
      }, ON_FOCUS_CLICK_DELAY);
    }

    let renameFile: string | undefined = AppStorage.get('renameFile');
    if (renameFile === undefined || renameFile === '') {
      return;
    }
    let ino: string | undefined = this.getFileFolderInoFromUri(renameFile);
    if (!ino) {
      log.showWarn(TAG, `updateDesktopFocusState renameFileId:${renameFile}`);
      this.focusChangeListener.get(renameFile)?.onFocusChange();
      return;
    }
    log.showInfo(TAG, `updateDesktopFocusState ino:${ino}`);
    const focusChangeListener: FocusChangeListener | undefined = this.focusChangeListener.get(ino);
    if (!focusChangeListener) {
      log.showError(TAG, `focusChangeListener not exist ,ino :${ino}`);
      return;
    }
    focusChangeListener.onFocusChange();
  }

  private getFileFolderInoFromUri(uri: string): string | undefined {
    let allItemsInDesktop: GridLayoutItemInfo[] = this.allDesktopItemInfo;
    for (let index = 0; index < allItemsInDesktop.length; index++) {
      let item: GridLayoutItemInfo = allItemsInDesktop[index];
      if (item.typeId === CommonConstants.TYPE_FILE_FOLDER && item?.uri === uri) {
        return item?.ino;
      }
    }
    log.showWarn(TAG, `getFileFolderInoFromUri get ino on desktop failed`);
    return '';
  }

  public isPastedFile(uri: string): boolean {
    let isPaste: boolean = this.pasteSelectItems.has(uri);
    if (isPaste) {
      this.pasteSelectItems.remove(uri);
    }
    return isPaste;
  }


  getItemKeyByType(item: GridLayoutItemInfo, isOuterDesktop?: boolean): string {
    let key = '';
    if (CheckEmptyUtils.isEmpty(item)) {
      log.showError(TAG, 'getItemKeyByType item is empty!');
      return key;
    }
    if (GridLayoutUtil.isIconType(item.typeId)) {
      let isOuter = isOuterDesktop === undefined ? launcherStatusUtil.getShowOutLauncherStatus() : isOuterDesktop;
      key = isOuter ? item.keyName + '_OuterDesktop' : (item.keyName ?? '');
    } else if (item.typeId === CommonConstants.TYPE_FOLDER) {
      key = item.folderId ?? '';
    } else if (item.typeId === CommonConstants.TYPE_REGION_FOLDER) {
      key = item.folderId ?? '';
    } else if (item.typeId === CommonConstants.TYPE_FILE_FOLDER) {
      key = item.ino ?? '';
    } else {
      key = item.cardId ?? '';
    }
    return key;
  }

  private registerKeyEvent(listener: KeyEventListener): void {
    log.showInfo(TAG, 'registerKeyEvent');
    keyEventManager.registerKeyEventListener(listener, [
      KeyEventConstants.EVENT_ENTER,
      KeyEventConstants.EVENT_DELETE,
      KeyEventConstants.EVENT_F2,
      KeyEventConstants.EVENT_FORCE_DELETE,
      KeyEventConstants.EVENT_CTRL_C,
      KeyEventConstants.EVENT_CTRL_V,
      KeyEventConstants.EVENT_CTRL_X,
      KeyEventConstants.EVENT_CTRL_A,
      KeyEventConstants.EVENT_CTRL_D,
      KeyEventConstants.EVENT_CTRL_Z,
      KeyEventConstants.EVENT_CTRL_Y,
      KeyEventConstants.EVENT_CTRL_SHIFT_N,
      KeyEventConstants.EVENT_ALT_ENTER,
      KeyEventConstants.EVENT_DPAD_UP,
      KeyEventConstants.EVENT_SPACE
    ]);
  }

  public doEnterCurrentItemEvent(uri:string): void {
    log.showInfo(TAG, 'doEnterCurrentItemEvent');
    this.fileFolderManager?.openFileOrFolder(uri);
    this.initSelectStatus();
    this.selectItemClear();
  }

  public selectItemContainApp(): boolean {
    let selectedFiles: GridLayoutItemInfo[] = [];
    let selectedApps: GridLayoutItemInfo[] = [];
    this.filterSelectObject(selectedFiles, selectedApps);
    return selectedApps.length !== 0;
  }

  public selectItemLength(): boolean {
    return this.lastSelectedItems.length > 1;
  }

  private doEnterEvent(): void {
    log.showInfo(TAG, 'doEnterEvent');
    let selectedFiles: GridLayoutItemInfo[] = [];
    let selectedApps: GridLayoutItemInfo[] = [];
    this.filterSelectObject(selectedFiles, selectedApps);
    if (this.selectItemContainApp()) {
      if (this.selectItemLength()) {
        return;
      } else if (selectedApps.length === 1) {
        let selectApp: GridLayoutItemInfo = selectedApps[0];
        CloseAppManager.getInstance().setStartAppType(StartType.DESKTOP_APP);
        if (selectApp.shortcutId) {
          ShortcutViewModel.getInstance().onShortcutAppClick(selectApp as AppItemInfo);
        } else {
          this.jumpTo(selectApp.abilityName, selectApp.bundleName, selectApp.moduleName);
        }
      }
    }
    if (this.selectItemLength()) {
      // 1.框选或全选后按Enter位于N序列第一个文件打开
      // 2.多选后按Enter上一次点击的文件打开
      let selectedFile: string = this.filterSelectedFileItem();
      if (selectedFile === undefined || selectedFile === '') {
        log.showInfo(TAG, 'doEnterEvent no file item selected');
        return;
      }
      log.showInfo(TAG, `doEnterEvent latest focus null, doEnterEvent get itemInfo: ${!selectedFile}`);
      this.fileFolderManager?.openFileOrFolder(selectedFile);
    } else if (selectedFiles.length > 0) {
      this.fileFolderManager?.openFileOrFolder(selectedFiles[0]?.uri ?? '');
    }
    AppStorage.setOrCreate('lastFocusItem', undefined);
    this.initSelectStatus();
    this.selectItemClear();
  }

  private doCtrlShiftNEvent(): void {
    if (AppStorage.get('isDoingRename')) {
      return;
    }
    // 如果是磁吸态，传对应page
    const page: number = this.keyBoardStatus === -1 ? 0 : this.keyBoardStatus;
    if (!this.isCanCreateFolder(page)) {
      HiSysEventUtil.reportFullContinueAdding(DisplayConstants.DEFAULT_DISPLAY);
      Prompt.showToast({
        message: ResourceManager.getInstance().getStringByName('add_icon_to_desktop_max')
      });
      return;
    }
    this.createNewFolderToUri();
  }

  private createNewFolderToUri(uri?: string): void {
    this.fileFolderManager?.createNewFolder(uri).then(dirUri => {
      if (dirUri instanceof Error) {
        log.error('doCtrlShiftNEvent create new folder failed. err', dirUri);
        return;
      }
      log.showInfo(TAG, 'doCtrlShiftNEvent createNemFolder success');
      AppStorage.setOrCreate<string>('newCreateFolder', dirUri);
      this.fileFolderManager?.refreshDesktopFiles();
    });
  }

  public async doDeleteEvent(isForceDelete: boolean = false): Promise<void> {
    log.showInfo(TAG, 'doDeleteEvent: ' + isForceDelete);
    // get selectedFiles
    let selectedFiles: GridLayoutItemInfo[] = [];
    let selectedApps: GridLayoutItemInfo[] = [];
    this.filterSelectObject(selectedFiles, selectedApps);
    if (selectedFiles.length !== 0 ) {
      log.showInfo(TAG, `doDeleteEvent ${selectedFiles.length} files selected,`+
        `inos: ${selectedFiles.map(girdItemInfo => girdItemInfo.ino ?? '').join(',')}`);
      this.pasteSelectItems.clear();
      this.fileFolderManager?.deleteFileOrFolder(selectedFiles
        .map((file: GridLayoutItemInfo) => file.uri ?? ''), isForceDelete);
    }
    if (selectedApps.length !== 0) {
      log.showInfo(TAG, `doDeleteEvent ${selectedApps.length} apps selected`);
      this.deleteSelectApp(selectedApps);
    }
  }

  private async doCopyEvent(isActionCut: boolean = false): Promise<void> {
    let selectedFiles: string[] = this.filterSelectFileItem();
    log.showInfo(TAG, `doCopyEvent: selectedFiles is ${selectedFiles?.length}, isActionCut ${isActionCut}`);
    if (isActionCut) {
      // clear last cut
      this.setCutStatusChange(this.cutItems, false);
      this.cutItems = selectedFiles;
      // new arr
      this.fileFolderManager?.cutFiles(selectedFiles.slice());
      this.setCutStatusChange(this.cutItems, true);
    } else {
      this.setCutStatusChange(this.cutItems, false);
      this.fileFolderManager?.copyFiles(selectedFiles);
    }
  }

  private openFilePreview(): void {
    log.showInfo(TAG, 'openFilePreview');
    let selectedFiles: GridLayoutItemInfo[] = [];
    this.filterSelectObject(selectedFiles);
    if (selectedFiles.length < 1) {
      log.showInfo(TAG, 'no files selected, return');
      return;
    }
    // 1.框选或全选后按Alt+Enter位于N序列第一个文件打开详情
    // 2.单选后按Alt+Enter打开当前文件详情
    let selectFileUri: string | undefined =
      selectedFiles.length === 1 ? selectedFiles[0].uri : this.filterSelectedFileItem();
    if (CheckEmptyUtils.isEmpty(selectFileUri)) {
      log.showInfo(TAG, 'openFilePreview file Uri is empty');
      return;
    }
    this.fileFolderManager?.openFilePreview(selectFileUri);
    this.clearSelectStatus();
  }

  private openFileDetail(): void {
    log.showInfo(TAG, 'openFileDetail');
    let selectedFiles: GridLayoutItemInfo[] = [];
    this.filterSelectObject(selectedFiles);
    if (selectedFiles.length < 1) {
      log.showInfo(TAG, 'no files selected, return');
      return;
    }
    // 1.框选或全选后按Enter位于N序列第一个文件打开
    // 2.多选后按Enter上一次点击的文件打开
    let selectFileUri: string[] = selectedFiles.map(item => item.uri ?? '');
    if (CheckEmptyUtils.isEmpty(selectFileUri)) {
      log.showInfo(TAG, 'openFileDetail file Uri is empty');
      return;
    }
    this.fileFolderManager?.openFileDetail(selectFileUri);
    this.clearSelectStatus();
  }

  private clearSelectStatus(): void {
    AppStorage.setOrCreate('lastFocusItem', undefined);
    this.initSelectStatus();
    this.selectItemClear();
  }

  private doSelectFirstItem(): void {
    if (this.lastSelectedItems.length === 0) {
      let firstItem: GridLayoutItemInfo | undefined = this.allDesktopItemInfo.reduce((a, b) => {
        if ((a.column ?? 0) < (b.column ?? 0)) {
          return a;
        } else if ((a.row ?? 0) < (b.row ?? 0)) {
          return a;
        } else {
          return b;
        }
      });
      if (firstItem) {
        this.onSelectItemChange([this.getItemKeyByType(firstItem)], true);
        AppStorage.setOrCreate('lastFocusItem', firstItem);
      }
    }
  }

  /**
   * 菜单复制处理
   * @param selectedFiles 所选文件
   * @param isActionCut 是否剪切
   */
  public menuCopyAction(selectedFiles: string[], isActionCut: boolean = false): void {
    // 清除上次剪切态
    this.setCutStatusChange(this.cutItems, false);
    if (isActionCut) {
      this.cutItems = selectedFiles;
      this.setCutStatusChange(this.cutItems, true);
    }
  }

  public async doPasteEvent(regionFolder?: GridLayoutItemInfo): Promise<void> {
    log.showInfo(TAG, `doPasteEvent, on RegionFolder:${!!regionFolder}, cutItems length:${this.cutItems.length}`);
    if (this.cutItems.length <= 0) {
      this.selectItemClear();
    }
    const destUri = regionFolder?.uri;
    this.fileFolderManager?.pasteFiles(destUri);
    this.cutStatusChange(this.cutItems, false);
    this.cutItems = [];
  }

  private doSelectAllEvent(): void {
    log.showInfo(TAG, 'doSelectAllEvent');
    const isDrag: boolean = AppStorage.get<boolean>('isDrag') as boolean;
    if (isDrag) {
      log.showInfo(TAG, `can not select all when item is dragging`);
      return;
    }
    this.selectAllOrSomeDesktopItem();
    // except card items
    const keys: string[] = this.allDesktopItemInfo.filter((itemInfo) => {
      if (this.keyBoardStatus !== FeatureConstants.NO_KEYBOARD) {
        return ((itemInfo.typeId === CommonConstants.TYPE_APP ||
          itemInfo.typeId === CommonConstants.TYPE_SHORTCUT_ICON ||
          itemInfo.typeId === CommonConstants.TYPE_FILE_FOLDER) && itemInfo.page === this.keyBoardStatus);
      } else {
        return (itemInfo.typeId === CommonConstants.TYPE_APP ||
          itemInfo.typeId === CommonConstants.TYPE_SHORTCUT_ICON ||
          itemInfo.typeId === CommonConstants.TYPE_FILE_FOLDER);
      }
    }).map((itemInfo) => {
      return this.getItemKeyByType(itemInfo);
    });
    this.onSelectItemChange(keys, true);
  }

  private doRenameEvent(): void {
    log.showInfo(TAG, 'doRenameEvent');
    if (this.lastSelectedItems.length > 1) {
      log.showWarn(TAG, 'doRenameEvent, select item not single, cant rename');
      return;
    }
    const selectItemUri = this.filterSelectedFileItem();
    if (CheckEmptyUtils.checkStrIsEmpty(selectItemUri)) {
      log.showWarn(TAG, 'doRenameEvent, latest select item is null');
      return;
    }
    AppStorage.setOrCreate('renameFile', selectItemUri);
  }

  public doRevoke(): void {
    log.showInfo(TAG, 'doRevoke');
    this.fileFolderManager?.doRevoke();
  }

  public doReverseRevoke(): void {
    log.showInfo(TAG, 'doReverseRevoke');
    this.fileFolderManager?.doReverseRevoke();
  }

  public updateDesktopItemInfo(): void {
    this.allDesktopItemInfo =
      this.mLauncherLayoutCacheManager.getAllGridLayoutItemList(BusinessType.BUSINESS_BASIC_DESKTOP);
  }

  public getFileInfoMap(): Map<string, string> {
    return this.fileMapForInoByUri;
  }

  /**
   * filter selected object from all desktop items by typeId
   * filter performance need to be considered
   * @returns file object
   */
  public filterSelectObject(selectFiles?: GridLayoutItemInfo[], selectApps?: GridLayoutItemInfo[]): void {
    let allItemsInDesktop: GridLayoutItemInfo[] = this.allDesktopItemInfo;
    for (let index = 0; index < this.lastSelectedItems.length; index++) {
      for (let allItemIndex = 0; allItemIndex < allItemsInDesktop.length; allItemIndex++) {
        let item: GridLayoutItemInfo = allItemsInDesktop[allItemIndex];
        if (this.lastSelectedItems[index] === this.getItemKeyByType(item)) {
          this.pushSelectObject(item.typeId ?? -1, item, selectFiles, selectApps);
          break;
        }
      }
    }
    return;
  }

  /**
   * 隐藏超出当前屏幕区域的元素
   * @param gridItems 桌面元素
   * @returns 过滤后的桌面元素
   */
  public filterItemExceedCurrentScreen(gridItems: GridLayoutItemInfo[]): GridLayoutItemInfo[] {
    if (gridItems) {
      const mGridConfig: GridLayoutConfig = this.getGridConfig();
      const maxColumn: number = mGridConfig?.column as number;
      const maxRow: number = mGridConfig?.row as number;
      log.showInfo(TAG, `filterItemExceedCurrentScreen item is: max column: ${maxColumn}, max row: ${maxRow}`);
      return gridItems.filter((item: GridLayoutItemInfo) => {
        if (!item || item.row === undefined || item.column === undefined || !item.area) {
          log.showWarn(TAG, 'filterItemExceedCurrentScreen item undefined');
          return false;
        }
        const rowInGrid: boolean = item.row >= 0 && ((item.row + item.area[1] - 1) < maxRow);
        const columnInGrid: boolean = item.column >= 0 && ((item.column + item.area[0] - 1) < maxColumn);
        if (!rowInGrid || !columnInGrid) {
          log.showWarn(TAG, `item: ${item.infoId}, ${item.typeId}, column ${item.column}, row ${item.row}, area:${JSON.stringify(item.area)}`);
        }
        return rowInGrid && columnInGrid;
      });
    }
    return gridItems;
  }

  public filterItemInnerCurrentScreen(gridItems: GridLayoutItemInfo[]): GridLayoutItemInfo[] {
    if (gridItems) {
      const mGridConfig: GridLayoutConfig = this.getGridConfig();
      const maxColumn: number = mGridConfig?.column as number;
      const maxRow: number = mGridConfig?.row as number;
      log.showInfo(TAG, `filterItemInnerCurrentScreen item is: max column: ${maxColumn}, max row: ${maxRow}`);
      return gridItems.filter((item: GridLayoutItemInfo) => {
        if (!item || item.row === undefined || item.column === undefined || !item.area) {
          log.showWarn(TAG, 'filterItemInnerCurrentScreen item undefined');
          return false;
        }
        const rowInGrid: boolean = item.row >= 0 && ((item.row + item.area[1] - 1) >= maxRow);
        const columnInGrid: boolean = item.column >= 0 && ((item.column + item.area[0] - 1) >= maxColumn);
        return rowInGrid && columnInGrid;
      });
    }
    return gridItems;
  }

  private pushSelectObject(typeId: number, desktopItem: GridLayoutItemInfo,
    selectFiles?: GridLayoutItemInfo[], selectApps?: GridLayoutItemInfo[]): void {
    if (typeId === CommonConstants.TYPE_APP) {
      if (selectApps !== undefined) {
        selectApps.push(desktopItem);
      }
    } else if (typeId === CommonConstants.TYPE_FILE_FOLDER) {
      if (selectFiles !== undefined) {
        selectFiles.push(desktopItem);
      }
    } else if (typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
      if (selectApps !== undefined) {
        selectApps.push(desktopItem);
      }
    } else {
      log.showWarn(TAG, `pushSelectObject error type:${typeId} selected!`);
    }
    return;
  }

  private async deleteSelectApp(deleteAppList: GridLayoutItemInfo[]): Promise<void> {
    for (let index = 0; index < deleteAppList.length; index++) {
      let item = deleteAppList[index];
      if (item.typeId === CommonConstants.TYPE_APP) {
        this.deleteAppItem({
          bundleName: item.bundleName,
          keyName: item.keyName,
          abilityName: item.abilityName,
          moduleName: item.moduleName,
          appIndex: item.appIndex,
          typeId: CommonConstants.TYPE_APP
        });
      } else if (item.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
        this.onRemoveShortcut(item as AppItemInfo, () => this.removeShortcutItem(item as AppItemInfo));
      }
    }
    return;
  }

  // return uris
  public filterSelectFileItem(): string[] {
    let result: string[] = [];
    let allItemsInDesktop: GridLayoutItemInfo[] = this.allDesktopItemInfo;
    for (let index = 0; index < this.lastSelectedItems.length; index++) {
      for (let allItemIndex = 0; allItemIndex < allItemsInDesktop.length; allItemIndex++) {
        let item: GridLayoutItemInfo = allItemsInDesktop[allItemIndex];
        if (item.typeId === CommonConstants.TYPE_FILE_FOLDER &&
          item.ino === this.lastSelectedItems[index]) {
          result.push(item.uri ?? '');
          break;
        }
      }
    }
    return result;
  }

  public filterSelectedFileItem(): string {
    let result: string = '';
    let minColumn: number = Number.MAX_VALUE;
    let minRow: number = Number.MAX_VALUE;
    let allItemsInDesktop: GridLayoutItemInfo[] = this.allDesktopItemInfo;
    for (let index = 0; index < this.lastSelectedItems.length; index++) {
      for (let allItemsIndex = 0; allItemsIndex < allItemsInDesktop.length; allItemsIndex++) {
        let item: GridLayoutItemInfo = allItemsInDesktop[allItemsIndex];
        if (item.typeId === CommonConstants.TYPE_FILE_FOLDER && item.ino === this.lastSelectedItems[index]) {
          let itemColumn = item.column ?? 0;
          let itemRow = item.row ?? 0;
          if (itemColumn < minColumn || itemColumn === minColumn && itemRow < minRow) {
            minColumn = itemColumn;
            minRow = itemRow;
            result = item.uri ?? '';
          }
          log.showInfo(TAG, `currentcolumn: ${minColumn}, row: ${minRow}`);
          break;
        }
      }
    }
    return result;
  }

  public initSelectStatus(): void {
    this.desktopContext?.eventHub.emit(CommonConstants.DESKTOP_SELECT_STATUS_CHANGE, []);
  }

  public registerGridListener(listener: Object): void {
    this.gridListener = listener;
  }

  public unregisterGridListener(): void {
    this.gridListener = undefined;
  }

  public registerUninstallListener(listener: UninstallListener): void {
    let index = this.mUninstallListeners.indexOf(listener);
    if (index === INVALID_IDX) {
      this.mUninstallListeners.push(listener);
    }
  }

  public unregisterUninstallListener(listener: UninstallListener): void {
    let index = this.mUninstallListeners.indexOf(listener);
    if (index !== INVALID_IDX) {
      this.mUninstallListeners.splice(index, 1);
    }
  }

  public registerFocusChangeListener(key: string, listener: FocusChangeListener): void {
    if (this.focusChangeListener.has(key) && this.focusChangeListener.get(key) === listener) {
      log.showWarn(TAG, `registerFocusChangeListener focusChangeListener conflict. key = ${key}`);
      return;
    }
    this.focusChangeListener.set(key, listener);
  }

  public unregisterFocusChangeListener(key: string, listener: FocusChangeListener): void {
    if (!this.focusChangeListener.has(key)) {
      log.showWarn(TAG, `unregisterSelectChangeListener selectChangeListener not exist. key = ${key}`);
      return;
    }
    if (this.focusChangeListener.get(key) !== listener) {
      log.showWarn(TAG, `do not delete listener`);
      return;
    }
    this.focusChangeListener.delete(key);
  }

  public registerSelectChangeListener(key: string, listener: SelectChangeListener): void {
    if (this.selectChangeListeners.has(key)) {
      log.showWarn(TAG, `registerSelectChangeListener selectChangeListener conflict. key = ${key}`);
    }
    this.selectChangeListeners.set(key, listener);
  }

  public unregisterSelectChangeListener(key: string, listener?: SelectChangeListener): void {
    if (!this.selectChangeListeners.has(key)) {
      log.showWarn(TAG, `unregisterSelectChangeListener selectChangeListener not exist. key = ${key}`);
      return;
    }
    if (listener && this.selectChangeListeners.get(key) !== listener) {
      log.showWarn(TAG, 'unregisterSelectChangeListener, not same listener');
      return;
    }
    this.selectChangeListeners.delete(key);
    // if the item is selected now, remove it
    let index: number = this.lastSelectedItems.indexOf(key);
    if (index > INVALID_IDX) {
      this.lastSelectedItems.splice(index, 1);
    }
  }

  public onSelectItemChange(items: string[], selectStatus: boolean, isSingle = false): void {
    log.showDebug(TAG, `onSelectItemChange selectStatus: ${selectStatus}, items: ${items.length}, \
    lastSelectedItems:${this.lastSelectedItems.length}, isSingle: ${isSingle}`);
    if (selectStatus) {
      this.selectChange(items, isSingle);
    } else {
      this.unSelectChange(items);
    }

    let lastSelectedItems: string[] = AppStorage.get('lastSelectedItems') ?? [];
    if (lastSelectedItems.length === this.lastSelectedItems.length &&
      lastSelectedItems.toString() === this.lastSelectedItems.toString()) {
      return;
    }
    AppStorage.setOrCreate('lastSelectedItems', this.lastSelectedItems);
  }

  private selectChange(items: string[], isSingle = false): void {
    for (let index = 0; index < this.lastSelectedItems.length; index++) {
      log.showDebug(TAG, `selectChange indexOf ${!items.indexOf(this.lastSelectedItems[index])} ${this.selectChangeListeners.has(this.lastSelectedItems[index])}`);
      // if any item in lastSelectedItems is not in items, then unselect it.
      if (items.indexOf(this.lastSelectedItems[index]) === INVALID_IDX && this.selectChangeListeners.has(this.lastSelectedItems[index])) {
        if (!isSingle) {
          this.selectChangeListeners.get(this.lastSelectedItems[index])?.onSelectStatusChange(false);
          this.releaseSnapshot(this.multiSelectMap.get(this.lastSelectedItems[index]));
          this.multiSelectMap.delete(this.lastSelectedItems[index]);
        }
      }
    }

    let setFocusResult: boolean = false;
    for (let index = 0; index < items.length; index++) {
      if (this.selectChangeListeners.has(items[index])) {
        this.selectChangeListeners.get(items[index])?.onSelectStatusChange(true);
        this.selectChangeListeners.get(items[index])?.onFocusStatusChange(true);
        if (!setFocusResult) {
          setFocusResult = this.mFocusViewModel.setFocus(items[index], true);
        }
        try {
          if (this.multiSelectMap.size <= SNAPSHOT_MAP_COUNT && index < SNAPSHOT_MAP_COUNT) {
            this.setSnapShotMap(items[index]);
          }
        } catch (err) {
          log.showInfo(TAG, `setSnapShotMap err: ${err}`);
        }
      }
    }
    this.refreshLastSelectedItems(items, isSingle);
  }

  getCurrentTouchItem(item: GridLayoutItemInfo): image.PixelMap | undefined {
    let key: string = this.getItemKeyByType(item) as string;
    return this.multiSelectMap.get(key);
  }

  deleteCurrentItem(key: string): void {
    this.releaseSnapshot(this.multiSelectMap.get(key));
    this.multiSelectMap.delete(key);
  }

  isCurrentItemInMultiMap(key: string): boolean {
    return this.multiSelectMap.has(key);
  }

  isFirstSnapshotInMap(key: string): boolean {
    return this.multiSelectMap.keys().next().value === key;
  }

  async setSnapShotMap(key: string, forceUpdate: boolean = false): Promise<void> {
    let componentId = this.getComponentIdByIno(key);
    if (this.multiSelectMap.has(key)) {
      log.showInfo(TAG, 'SnapShotMap already set this key');
      if (forceUpdate) {
        this.deleteCurrentItem(key);
      } else {
        return;
      }
    }
    if (componentId === '') {
      log.showWarn(TAG, 'getComponentIdByIno return componentId is invalid');
      return;
    }
    // 延迟获取截图，防止拖到桌面的文件进入选中态时无法被截图
    await new Promise<void>(resolve => setTimeout(resolve, DELAY_OBTAIN_SNAPSHOT));
    let image = await this.getSnapshotWithRetry(componentId);
    if (image) {
      this.multiSelectMap.set(key, image);
    }
  }

  getComponentIdByIno(key: string): string {
    log.showInfo(TAG, `getComponentIdByKey: ${key}`);
    if (!this.allDesktopItemInfo) {
      return '';
    }
    let allItemsInDesktop: GridLayoutItemInfo[] = this.allDesktopItemInfo;
    for (let index = 0; index < allItemsInDesktop.length; index++) {
      let item: GridLayoutItemInfo = allItemsInDesktop[index];
      if ((item?.typeId === CommonConstants.TYPE_FILE_FOLDER && item?.ino === key) ||
        (item?.typeId === CommonConstants.TYPE_APP && this.getItemKeyByType(item) === key) ||
        item?.typeId === CommonConstants.TYPE_SHORTCUT_ICON && this.getItemKeyByType(item) === key) {
        return item?.componentId ?? '';
      }
    }
    log.showWarn(TAG, 'getFileFolderInoFromIno get key failed');
    return '';
  }

  /**
   * 截图带重试
   * @param componentId
   * @param maxRetries 默认重试3次
   * @param delay 间隔50ms
   * @returns
   */
  private async getSnapshotWithRetry(componentId: string, maxRetries = 3,
    delay = 50): Promise<image.PixelMap | undefined> {
    if (CommonUtils.isEmpty(componentId)) {
      log.showError(TAG, 'getSnapshotWithRetry fail empty componentId');
      return undefined;
    }
    let attempt = 0;
    while (attempt <= maxRetries) {
      const snapshot = await this.getSnapshotById(componentId);
      if (snapshot) {
        return snapshot;
      }
      await CommonUtils.sleep(delay);
      attempt++;
    }
    log.showError(TAG, `getSnapshotWithRetry failm, all ${maxRetries} retries exhausted for componentId: ${componentId}`);
    return undefined;
  }

  private async getSnapshotById(componentId: string | undefined): Promise<image.PixelMap | undefined> {
    try {
      return await componentSnapshot.get(componentId ?? '');
    } catch (error) {
      log.showError(TAG, `getSnapshot failed error: ${error.code} ${error.message}`);
      return undefined;
    }
  }

  private async releaseSnapshot(pixelMap: image.PixelMap | undefined): Promise<void> {
    try {
      if (pixelMap) {
        await pixelMap.release();
        pixelMap = undefined;
      }
    } catch (error) {
      log.showError(TAG, `releaseSnapshot failed error: ${error.code} ${error.message}`);
    }
  }

  getMultiSelectMap(): Map<string, image.PixelMap> {
    return this.multiSelectMap;
  }

  getDragEventData(containerItem?: GridLayoutItemInfo): UDC.UnifiedData {
    if (!this.fileFolderManager) {
      log.showWarn(TAG, 'fileFolderManager is not exists');
      this.fileFolderManager = fileFolderManagerFactory.getFileFolderManager();
    }
    const currentSelectFileItems = this.getCurrentSelectItemsInfo().filter(item =>
    item.typeId === CommonConstants.TYPE_FILE_FOLDER);
    return this.fileFolderManager?.getDragEventData(currentSelectFileItems);
  }

  getCurrentSelectItemsInfo(): GridLayoutItemInfo[] {
    let gridInfoList: GridLayoutItemInfo[] = [];
    let lastSelectItemsSet = new Set(this.lastSelectedItems);
    this.allDesktopItemInfo.forEach((desktopItem: GridLayoutItemInfo) => {
      if (desktopItem.typeId !== CommonConstants.TYPE_CARD &&
      lastSelectItemsSet.has(this.getItemKeyByType(desktopItem)) &&
        gridInfoList.indexOf(desktopItem) === INVALID_IDX) {
        desktopItem.isSelect = true;
        gridInfoList.push(desktopItem);
      }
    });
    // 起拖元素按照桌面宫格索引升序排列，落位时按照这个顺序落位
    gridInfoList.sort((a: GridLayoutItemInfo, b: GridLayoutItemInfo) => {
      if ((a.column ?? 0) < (b.column ?? 0)) {
        return -1;
      } else if ((a.column ?? 0) > (b.column ?? 0)) {
        return 1;
      } else {
        return (a.row ?? 0) - (b.row ?? 0);
      }
    });
    log.showInfo(TAG, `getCurrentSelectItemsInfo desktopItem: ${gridInfoList.length}`);
    return gridInfoList;
  }

  private refreshLastSelectedItems(items: string[], isSingle = false): void {
    log.showInfo(TAG, `refreshLastSelectedItems lastSelectedItems: ${this.lastSelectedItems.length}, items: ${items?.length}`);
    if (!isSingle) {
      this.lastSelectedItems = [];
    }
    for (let index = 0; index < items.length; index++) {
      if (items[index] && this.lastSelectedItems.indexOf(items[index]) === INVALID_IDX ) {
        this.lastSelectedItems.push(items[index]);
      }
    }
  }

  private unSelectChange(items: string[]): void {
    for (let index = 0; index < items.length; index++) {
      log.showDebug(TAG, `lastSelectedItems: ${JSON.stringify(this.lastSelectedItems)}`);
      let itemIndex = this.lastSelectedItems.indexOf(items[index]);
      if (this.selectChangeListeners.has(items[index])) {
        this.selectChangeListeners.get(items[index])?.onSelectStatusChange(false);
        this.releaseSnapshot(this.multiSelectMap.get(items[index]));
        this.multiSelectMap.delete(items[index]);
      }
      if (itemIndex !== INVALID_IDX) {
        this.lastSelectedItems.splice(itemIndex, 1);
      }
    }
  }

  public restoreAll(): void {
    log.showInfo(TAG, `this.mIsDesktopFocused: ${this.mIsDesktopFocused}, this.focusFlag: ${this.focusFlag}`);
    if (!this.multiDragStart && this.mIsDesktopFocused && this.focusFlag) {
      AppStorage.setOrCreate('selectDesktopAppItem', null);
      AppStorage.setOrCreate<string>('selectItem', '');
      PageDesktopViewModel.getInstance(this.singleContext).initSelectStatus();
      PageDesktopViewModel.getInstance(this.singleContext).selectItemClear();
      this.lastSelectedItems = [];
      this.mFocusViewModel.setFocus(FocusViewModel.DEFAULT_FOCUS + launcherStatusUtil.getShowOutLauncherStatus(), true);
    }
  }

  public setMultiDragStart(multiDragStart: boolean, tag?: string): void {
    log.showInfo(TAG, `set multiDragStart from ${this.multiDragStart} to ${multiDragStart}, tag ${tag}`);
    this.multiDragStart = multiDragStart;
  }

  public getMultiDragStart(): boolean {
    return this.multiDragStart;
  }

  public getCurrentSelectItems(): string[] {
    return this.lastSelectedItems;
  }

  public getLastSelectItems(): string[] {
    return this.getCurrentSelectItems();
  }

  public onDropItemsSelectChange(): void {
    let itemInfoList = AppStorage.get<GridLayoutItemInfo[]>('dragItemInfoList');
    let itemInfoListKey: string[] = [];
    if (Array.isArray(itemInfoList)) {
      log.showInfo(TAG, `dragItemInfoList, ${itemInfoList.length}`);
      itemInfoList.forEach((item) => {
        itemInfoListKey.push(this.getItemKeyByType(item));
      });
      this.onSelectItemChange(itemInfoListKey, true);
    }
    AppStorage.setOrCreate('dragItemInfoList', []);
  }

  public refreshPasteSelectedStates(items: string[]): void {
    log.showInfo(TAG, `refreshPasteSelectedStates: ${items?.length}`);
    this.pasteSelectItems.clear();
    let pastedInos: string[] = [];
    if (items) {
      items.forEach((item: string) => {
        let ino = this.fileMapForInoByUri.get(item);
        this.pasteSelectItems.add(item);
        if (!ino) {
          ino = this.fileFolderManager?.getFileInfoByUri(item)?.ino;
        }
        pastedInos.push(ino ?? '');
      });
      // when receive this, some file may exist all
      this.onSelectItemChange(pastedInos, true);
    }
  }

  public refreshFileItemIcon(): void {
    let fileItems: GridLayoutItemInfo[] = this.allDesktopItemInfo.filter((itemInfo) => {
      return itemInfo.typeId === CommonConstants.TYPE_FILE_FOLDER;
    });
    log.showInfo(TAG, `refreshFileItemIcon length: ${fileItems?.length}`);
    fileInfoUpdateManager.dispatchFileInfoUpdate(fileItems);
  }

  public selectItemClear(): void {
    log.showDebug(TAG, `selectItemClear lastSelectedItems: ${JSON.stringify(this.lastSelectedItems)}`);
    for (let index = 0; index < this.lastSelectedItems.length; index++) {
      if (this.selectChangeListeners.has(this.lastSelectedItems[index])) {
        this.selectChangeListeners.get(this.lastSelectedItems[index])?.onSelectStatusChange(false);
      }
    }
    this.lastSelectedItems = [];
    this.multiSelectMap.forEach((snapshot: image.PixelMap) => {
      this.releaseSnapshot(snapshot);
    });
    this.multiSelectMap.clear();
  }

  public cutItemClear(): void {
    log.showInfo(TAG, `cutItemClear, cutItems length:${this.cutItems.length}`);
    if (this.cutItems?.length > 0) {
      this.cutStatusChange(this.cutItems, false);
      this.cutItems = [];
    }
  }

  /**
   * 是否存在剪切态文件（夹）
   * @returns
   */
  public hasCutItems(): boolean {
    return this.cutItems.length > 0;
  }

  public setCutStatusChange(items: string[], isCut: boolean = false, isFromRegionFolder = false): void {
    log.showInfo(TAG, `setCutStatusChange: ${items.length}, ${isCut}`);
    this.cutStatusChange(items, isCut);
    this.cutItems = isCut ? items : [];
  }

  private cutStatusChange(items: string[], isCut: boolean = false): void {
    if (!items) {
      log.showError(TAG, 'cutStatusChange items null');
      return;
    }
    for (let index = 0; index < items.length; index++) {
      let ino = this.fileMapForInoByUri.get(items[index]) ?? '';
      log.showInfo(TAG, `cutStatusChange: ${index}`);
      if (this.selectChangeListeners.has(ino)) {
        this.selectChangeListeners.get(ino)?.onCutStatusChange(isCut);
      }
    }
  }

  /**
   * register form visible change listener
   *
   * @param cardId card id
   * @param listener form visible change listener
   */
  registerFormVisibleListener(cardId: string, listener: VisibleChangeListener): void {
    log.showInfo(TAG, `registerFormVisibleListener: ${cardId}`);
    let listeners = this.formVisibleListenerMap.get(cardId) ?? new ArrayList<VisibleChangeListener>();
    listeners.add(listener);
    this.formVisibleListenerMap.set(cardId, listeners);
  }

  /**
   * unregister form visible change listener
   *
   * @param cardId card id
   * @param listener form visible change listener
   */
  unRegisterFormVisibleListener(cardId: string, listener: VisibleChangeListener): void {
    log.showInfo(TAG, `unregisterFormVisibleListener: ${cardId}`);
    let listeners = this.formVisibleListenerMap.get(cardId);
    listeners?.remove(listener);
    if (listeners?.isEmpty()) {
      this.formVisibleListenerMap.delete(cardId);
    }
  }

  public registerSelectItemChangeListener(key: number, listener: SelectItemChangeListener): void {
    log.showInfo(TAG, `registerSelectItemChangeListener: ${key}`);
    this.selectItemChangeListenerMap.set(key, listener);
  }

  public unRegisterSelectItemChangeListener(): void {
    log.showInfo(TAG, 'unRegisterSelectItemChangeListener');
    this.selectItemChangeListenerMap.clear();
  }

  public selectAllOrSomeDesktopItem(selectPaste?: string[]): void {
    log.showInfo(TAG, 'selectAllItemChangeListener');
    if (this.selectItemChangeListenerMap.size === 0) {
      log.showError(TAG, 'selectItemChangeListener not register');
      return;
    }
    this.selectItemChangeListenerMap.forEach((selectItemChangeListener: SelectItemChangeListener) => {
      selectItemChangeListener.selectAllOrSomeDesktopItem(selectPaste);
    });
  }

  private sendFallBoxHideEvent(tag: string): void {
    log.showInfo(TAG, `${tag} sendFallBoxHideEvent notifyGridWhiteEdgeHide`);
    const pageIndex: number = desktopUtil.getPageIndexValue();
    (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext).eventHub
      .emit(`rect${pageIndex}`, false, false, [0, 0]);
    let foldStatus: boolean = desktopUtil.isFoldExpandStatus() || this.isBigScreen;
    if (foldStatus) {
      let neighborPage = pageIndex % StyleConstants.DEFAULT_2 === 0 ? pageIndex + StyleConstants.DEFAULT_1 :
        pageIndex - StyleConstants.DEFAULT_1;
      (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext).eventHub
        .emit(`rect${neighborPage}`, false, false, [0, 0]);
    }
  }

  /**
   * get the neighborPage for foldDevice
   *
   * @param page current page
   * @returns neighborPage
   */
  public getNeighborPage(page: number): number {
    return this.viewModelUtils.getNeighborPage(page);
  }

  private refreshPageDesktopFiles(desktopFileArray: DesktopFileInfo[]): void {
    this.checkAndUpdateConfig(desktopFileArray);
  }

  /**
   * 竖向 从右到左
   * @param area
   * @param column
   * @param row
   * @param curPage
   * @returns
   */
  private getItemIndexWithRight(area: number[], column: number, row: number, curPage: number):
  PageColumnInfo | null {
    for (let y = column - 1; y >= 0; y--) {
      for (let x = 0; x < row; x++) {
        if (this.mLauncherLayoutCacheManager.isPositionValid({ area }, curPage, y, x)) {
          return { pageIndex: curPage, row: x, column : y };
        }
      }
    }
    return null;
  }

  private getItemIndexWithAround(area: number[], startPage:number, searchPageCount: number):
  PageColumnInfo | null {
    log.showInfo(TAG, `getItemIndexWithAround：${startPage}, ${searchPageCount}, ${area}`);
    const layout: LayoutDescription = this.mLauncherLayoutCacheManager.selectLayoutDescription();
    searchPageCount = Math.min(layout.pageCount, searchPageCount);
    let curPage = startPage;
    for (let i = 0; i < searchPageCount; i++) {
      const itemIndex = this.getItemIndexWithRight(area, layout.column, layout.row, curPage);
      if (itemIndex !== null) {
        return itemIndex;
      }
      curPage++;
      curPage = curPage % layout.maxPage;
    }
    return null;
  }

  /**
   * 根据指定pageIndex和需要容纳下的空间大小，返回页面index及位置信息
   *
   * @param {number} pageIndex 指定页
   * @param {number[]} area 空间大小
   * @param {number} pageCountToSearch 从指定pageIndex开始往后搜索页数，默认1
   * @returns { page: number; row: number; column: number; } | null
   */
  getEnoughAreaPosition(pageIndex: number, area: number[], pageCountToSearch: number = 1): PageColumnInfo | null
  {
    if (this.isPad) {
      pageCountToSearch = this.keyBoardStatus === FeatureConstants.NO_KEYBOARD ? pageCountToSearch : 1;
      return this.getItemIndexWithAround(area, pageIndex, pageCountToSearch);
    }
    const layoutDescription: LayoutDescription = this.mLauncherLayoutCacheManager.selectLayoutDescription();
    const pageCount: number = layoutDescription.pageCount;
    const maxPageIndex: number = Math.min(pageIndex + pageCountToSearch - 1, pageCount - 1);
    let first: number;
    let second: number;
    let isPad = this.getDevice();
    if (isPad) {
      first = layoutDescription.column;
      second = layoutDescription.row;
    } else {
      first = layoutDescription.row;
      second = layoutDescription.column;
    }

    for (let i = pageIndex; i <= maxPageIndex; i++) {
      for (let y = 0; y < first; y++) {
        for (let x = 0; x < second; x++) {
          let positionX = isPad ? y : x;
          let positionY = isPad ? x : y;
          if (this.mLauncherLayoutCacheManager.isPositionValid({ area }, i, positionX, positionY)) {
            return { pageIndex: i, row: positionY, column : positionX };
          }
        }
      }
    }
    // 当前处于编辑模式下加号页时，直接在当前页找位
    if (editModeManager.isInEditMode() && this.mPageIndex >= pageCount) {
      return { pageIndex: pageIndex, row: 0, column : 0 };
    }

    return null;
  }

  async autoAlignAfterUninstall(appItemInfoArr: AppItemInfo[]): Promise<void> {
    if (launcherStatusUtil.getShowOutLauncherStatus()) {
      log.showWarn(TAG, 'autoAlign failure as getShowOutLauncherStatus false');
      return;
    }
    this.mAutoAlignStatus = await this.viewModelUtils.getAlignStatus();
    if (!this.mAutoAlignStatus) {
      log.showWarn(TAG, `autoAlign failure as autoAlignStatus is ${this.mAutoAlignStatus}`);
      return;
    }
    if (CheckEmptyUtils.isEmptyArr(appItemInfoArr)) {
      log.showWarn(TAG, 'autoAlign failure as appItemInfoArr is null');
      return;
    }
    let appItemInfoFixArr: AppItemInfo[] = [];
    for (let i = 0; i < appItemInfoArr.length; i++) {
      let mArea = appItemInfoArr[i].area;
      if ( mArea && mArea[0] === 1 && mArea[1] === 1) {
        appItemInfoFixArr.push(appItemInfoArr[i]);
      }
    }
    this.uninstallAppItemInfoArr = appItemInfoFixArr;
    log.showInfo(TAG, 'autoAlign autoAlignAfterUninstall uninstallAppItemInfoArr length: %{public}d', this.uninstallAppItemInfoArr.length);
    gravityAnimationListenerManager.registerListener(this.gravityListener);
  }

  /**
   * 自动对齐具体实现,在引力动效完成时调用
   *
   * @returns
   */
  autoAlignAndSqueezedAnimation(): void {
    if (ArrayUtils.isEmpty(this.uninstallAppItemInfoArr) || !this.uninstallAppItemInfoArr[0]) {
      log.showInfo(TAG, 'autoAlign exit because this.uninstallAppItemInfoArr is error');
      return;
    }
    log.showInfo(TAG, 'autoAlignAndSqueezedAnimation uninstallApp: %{public}s, uninstallApp appName: %{public}s, uninstallAppLength: %{public}d',
      this.uninstallAppItemInfoArr[0].bundleName, this.uninstallAppItemInfoArr[0].appName, this.uninstallAppItemInfoArr.length);
    let gridLayoutItemList: GridLayoutItemInfo[] = this.mLauncherLayoutCacheManager
      .selectItemListByPageAndArea(this.uninstallAppItemInfoArr[0].page, this.uninstallAppItemInfoArr[0].area);
    log.showInfo(TAG, 'autoAlign current page item num (before add): %{public}d', gridLayoutItemList.length);
    if (this.mdeleteItemList.length !== 0) {
      this.mdeleteItemList = [];
    }
    TraceUtil.startTrace(DomainName.HOME, TraceUtil.AUTO_ALIGN_DELETE_APP);
    for (let i = 0; i < this.uninstallAppItemInfoArr.length; i++) {
      this.mdeleteItemList.push(this.uninstallAppItemInfoArr[i] as object as GridLayoutItemInfo);
    }
    this.mdeleteItemList.forEach(deleteItem => {
      let appIndex = gridLayoutItemList.findIndex(pageItem => {
        return pageItem.keyName === deleteItem.keyName;
      });
      if (appIndex === -1) {
        log.showInfo(TAG, 'autoAlign current page add item bundleName: %{public}s appName: %{public}s', deleteItem.bundleName, deleteItem.appName);
        gridLayoutItemList.push(deleteItem);
      }
    });
    this.mGridLayoutItemList = gridLayoutItemList;
    log.showInfo(TAG, 'autoAlign current page all item num: %{public}d', this.mGridLayoutItemList.length);
    let autoAlignItem: SqueezeGridLayout[] = this.viewModelUtils.sortAndChangeForAutoAlign(this.mGridLayoutItemList, this.uninstallAppItemInfoArr);
    if (CheckEmptyUtils.isEmptyArr(autoAlignItem)) {
      log.showWarn(TAG, 'autoAlign failure as appItemInfo is Inactive');
    } else {
      autoAlignItem.forEach(item => this.mAutoAlignUpdateItem.push(item.updateItemsInfo));
      log.showInfo(TAG, 'current page need autoAlign item num: %{public}d', this.mAutoAlignUpdateItem.length);
      // 更新item的位置
      LaunchLayoutCacheManager.getInstance().updateGridLayoutItemsPositionById(this.mAutoAlignUpdateItem, BusinessType.BUSINESS_BASIC_DESKTOP, false, true);
      autoAlignItem.forEach(item => {
        DragEventManager.getInstance(launcherStatusUtil.getShowOutLauncherStatus())
          .startSqueezedInDesktop(item.keyName, [item.startPosition, item.endPosition]);
      });
      this.mdeleteItemList = [];
      this.uninstallAppItemInfoArr = [];
      this.mGridLayoutItemList = [];
      this.afterDeleteDesktopItem();
    }
    TraceUtil.endTrace(DomainName.HOME, TraceUtil.AUTO_ALIGN_DELETE_APP);
  }

  /**
   * 根据设备获取卡片的margin值
   * @returns 卡片的margin值
   */
  public getIconMarginVertical(): number {
    return this.getDevice() ? this.getPageDesktopStyleConfig()?.mIconMarginVertical : 0;
  }

  public voteBootEvent(voteScene?: string): void {
    this.cancelVoteTimeout();
    log.showInfo(TAG, `voteBootEvent for lockscreen begin with ${voteScene}`);
    try {
      systemParameter.setSync('bootevent.launcher.ready', 'true');
      LauncherStartup.getInstance().passStep(StartupStep.VOTE_FINISHED);
    } catch (err) {
      log.showInfo(TAG, `set voteBootEvent error with ${voteScene}`);
    }
    log.showInfo(TAG, `voteBootEvent for lockscreen end with ${voteScene}`);
  }

  public scheduleVoteTimeout(): void {
    log.showInfo(TAG, 'voteBootEvent timer begin');
    this.cancelVoteTimeout();
    this.voteTimeId = setTimeout(() => {
      this.voteBootEvent('Exception_PageDesktopTimeOutVote');
    }, this.voteTimeout);
  }

  private cancelVoteTimeout(): void {
    if (this.voteTimeId !== 0) {
      log.showInfo(TAG, 'voteBootEvent timer cancel');
      clearTimeout(this.voteTimeId);
      this.voteTimeId = 0;
    }
  }

  public initAfterModelChange(): void {
    if (this.mInstallingItem.length > 0 || this.mUninstallingItem.length > 0) {
      this.mIsNeedUpdateInstallingApp = true;
    }
    this.mPageIndex = 0;
    this.mTargetIndex = 0;
    LaunchLayoutCacheManager.getInstance().clearDesktopData(BusinessType.BUSINESS_BASIC_DESKTOP);
  }

  private trimDesktopItem(): GridLayoutItemInfo[] {
    let newGridLayoutItems: GridLayoutItemInfo[] = [];
    newGridLayoutItems = this.appGridLayoutItems.concat(this.folderGridLayoutItems, this.fileGridLayoutItems);
    newGridLayoutItems = this.filterItemExceedCurrentScreen(newGridLayoutItems);
    if (CheckEmptyUtils.isEmptyArr(newGridLayoutItems)) {
      return newGridLayoutItems;
    }
    const pageDesktopGridStyleConfig: PageDesktopGridStyleConfig = this.getPageDesktopStyleConfig();
    if (this.isBigScreen) {
      newGridLayoutItems = this.trimInBigScreen(newGridLayoutItems, pageDesktopGridStyleConfig);
    } else {
      newGridLayoutItems.sort((a: GridLayoutItemInfo, b: GridLayoutItemInfo) => {
        if (a.row === undefined || a.column === undefined || b.row === undefined || b.column === undefined) {
          log.showWarn(TAG, `${a.row}, ${a.column}, ${b.row}, ${b.column}, can't compare`);
          return 0;
        }
        const indexA: number = pageDesktopGridStyleConfig.mRows * a.column + a.row;
        const indexB: number = pageDesktopGridStyleConfig.mRows * b.column + b.row;
        return indexA - indexB;
      });
      this.coverPosition(newGridLayoutItems, pageDesktopGridStyleConfig, false);
    }
    return newGridLayoutItems;
  }

  private trimInBigScreen(newGridLayoutItems: GridLayoutItemInfo[],
    pageDesktopGridStyleConfig: PageDesktopGridStyleConfig): GridLayoutItemInfo[] {
    try {
      let foldStatus: display.FoldStatus = display.getFoldStatus();
      this.isExpandStatus = foldStatus === display.FoldStatus.FOLD_STATUS_EXPANDED;
    } catch (error) {
      log.showError(TAG, `get super fold status fail ${error?.code}, ${error?.message}`);
      return newGridLayoutItems;
    }
    if (this.isExpandStatus) {
      // 展开态横竖屏需要分别重新计算坐标
      newGridLayoutItems.sort((a: GridLayoutItemInfo, b: GridLayoutItemInfo) => {
        if (a.row === undefined || a.column === undefined || b.row === undefined || b.column === undefined ||
          a.page === undefined || b.page === undefined) {
          log.showWarn(TAG, `${a.row}, ${a.column}, ${b.row}, ${b.column}, can't compare`);
          return 0;
        }
        const isPortrait: boolean = AppStorage.get<boolean>('isPortrait') as boolean;
        if (isPortrait) {
          const indexA: number = a.page > 0 ? pageDesktopGridStyleConfig.mRows * (2 * a.column + 1) + a.row :
            pageDesktopGridStyleConfig.mRows * 2 * a.column + a.row;
          const indexB: number = b.page > 0 ? pageDesktopGridStyleConfig.mRows * (2 * b.column + 1) + b.row :
            pageDesktopGridStyleConfig.mRows * (2 * b.column) + b.row;
          return indexA - indexB;
        }
        const indexA: number =
          a.page > 0 ? pageDesktopGridStyleConfig.mRows * (pageDesktopGridStyleConfig.mColumns + a.column) + a.row :
            pageDesktopGridStyleConfig.mRows * a.column + a.row;
        const indexB: number =
          b.page > 0 ? pageDesktopGridStyleConfig.mRows * (pageDesktopGridStyleConfig.mColumns + b.column) + b.row :
            pageDesktopGridStyleConfig.mRows * b.column + b.row;
        return indexA - indexB;
      });
      this.coverPosition(newGridLayoutItems, pageDesktopGridStyleConfig, true);
      return newGridLayoutItems;
    }
    let curPageItems = newGridLayoutItems.filter((val) => {
      return val.page === this.sortOrTrimPage;
    });
    let otherPageItems = newGridLayoutItems.filter((val) => {
      return val.page !== this.sortOrTrimPage;
    });
    curPageItems.sort((a: GridLayoutItemInfo, b: GridLayoutItemInfo) => {
      if (a.row === undefined || a.column === undefined || b.row === undefined || b.column === undefined) {
        log.showWarn(TAG, `${a.row}, ${a.column}, ${b.row}, ${b.column}, can't compare`);
        return 0;
      }
      const indexA: number = pageDesktopGridStyleConfig.mRows * a.column + a.row;
      const indexB: number = pageDesktopGridStyleConfig.mRows * b.column + b.row;
      return indexA - indexB;
    });
    this.coverPosition(curPageItems, pageDesktopGridStyleConfig, false);
    newGridLayoutItems = curPageItems.concat(otherPageItems);
    return newGridLayoutItems;
  }


  private coverPosition(gridLayoutItemInfos: GridLayoutItemInfo[],
    pageDesktopGridStyleConfig: PageDesktopGridStyleConfig, isBigScreenInExpanded: boolean): void {
    if (CheckEmptyUtils.isEmptyArr(gridLayoutItemInfos)) {
      log.showError(TAG, 'grid layout item is empty');
      return;
    }
    const isPortrait: boolean = AppStorage.get<boolean>('isPortrait') as boolean;
    // 只有大屏幕机展开态column和row才需要*2
    const column = !isPortrait && isBigScreenInExpanded ? pageDesktopGridStyleConfig.mColumns * 2 :
      pageDesktopGridStyleConfig.mColumns;
    const row =
      isBigScreenInExpanded && isPortrait ? pageDesktopGridStyleConfig.mRows * 2 :
        pageDesktopGridStyleConfig.mRows;
    log.showInfo(TAG, `coverPosition  column:${column}, row:${row}`);
    let index: number = 0;
    for (let i = 0; i < column; i++) {
      for (let j = 0; j < row; j++) {
        const currentPage = isBigScreenInExpanded ?
          Math.floor(isPortrait ? j / pageDesktopGridStyleConfig.mRows : i / pageDesktopGridStyleConfig.mColumns) :
          this.sortOrTrimPage;
        const rowInCurrentPage = j % pageDesktopGridStyleConfig.mRows;
        const columnInCurrentPage = i % pageDesktopGridStyleConfig.mColumns;
        if (this.posOccupyArray[currentPage][rowInCurrentPage][columnInCurrentPage]) {
          continue;
        }
        gridLayoutItemInfos[index].column = columnInCurrentPage;
        gridLayoutItemInfos[index].row = rowInCurrentPage;
        gridLayoutItemInfos[index].page = currentPage;
        index++;
        if (index >= gridLayoutItemInfos.length) {
          log.showInfo(TAG, `coverPosition return newGridLayoutItems length: ${gridLayoutItemInfos.length}`);
          return;
        }
      }
    }
  }

  public desktopTrim(page: number): void {
    log.showInfo(TAG, `desktopTrim in ${page} page`);
    let ret: boolean = this.prepareSortParam();
    this.sortOrTrimPage = page;
    if (!ret) {
      this.clearSortParam();
      return;
    }
    let newGridLayoutItems: GridLayoutItemInfo[] = this.trimDesktopItem();
    newGridLayoutItems = newGridLayoutItems.concat(this.cardGridLayoutItems).concat(this.exceedScreenItems).concat(this.regionFolderGridLayoutItems);
    LaunchLayoutCacheManager.getInstance().updateGridLayoutItems(newGridLayoutItems,
      BusinessType.BUSINESS_BASIC_DESKTOP, true);
    this.lightPagingFiltering(false, SceneMsgEnum.SCENE_MSG_DESKTOP_TRIM);
    this.clearSortParam();
  }

  private sortDesktopItem(sortInfo: DesktopSortInfo): void {
    let ret: boolean = this.prepareSortParam();
    this.sortOrTrimPage = sortInfo.page;
    if (!ret) {
      this.clearSortParam();
      return;
    }
    log.showInfo(TAG, `sortDesktopItem sortRule: ${sortInfo?.sortRule}, isAscend: ${sortInfo?.isAscend}, page:${this.sortOrTrimPage}`);
    let newGridLayoutItems: GridLayoutItemInfo[] = [];
    switch (sortInfo?.sortRule) {
      case DesktopSortRule.SORT_BY_NAME:
        newGridLayoutItems = this.sortDesktopItemByName(sortInfo?.isAscend);
        break;
      case DesktopSortRule.SORT_BY_MODIFY_TIME:
        newGridLayoutItems = this.sortDesktopItemByModifiedTime(sortInfo?.isAscend);
        break;
      case DesktopSortRule.SORT_BY_CREATE_TIME:
        newGridLayoutItems = this.sortDesktopItemByCreatedTime(sortInfo?.isAscend);
        break;
      case DesktopSortRule.SORT_BY_SIZE:
        newGridLayoutItems = this.sortDesktopItemBySize(sortInfo?.isAscend);
        break;
      case DesktopSortRule.SORT_BY_TYPE:
        newGridLayoutItems = this.sortDesktopItemByType(sortInfo?.isAscend);
        break;
      default:
        log.showError(TAG, `sortDesktopItem invalid sortRule`);
        this.clearSortParam();
        return;
    }

    newGridLayoutItems = newGridLayoutItems.concat(this.cardGridLayoutItems).concat(this.exceedScreenItems).concat(this.regionFolderGridLayoutItems);
    this.dumpGridLayoutPosInfo(newGridLayoutItems);
    LaunchLayoutCacheManager.getInstance().updateGridLayoutItems(newGridLayoutItems,
      BusinessType.BUSINESS_BASIC_DESKTOP, true);
    this.lightPagingFiltering();
    this.clearSortParam();
  }

  public prepareSortParam(): boolean {
    try {
      const allGridLayoutItems: GridLayoutItemInfo[] = this.mLauncherLayoutCacheManager.getAllGridLayoutItemList(BusinessType.BUSINESS_BASIC_DESKTOP);
      const innerGridLayoutItems: GridLayoutItemInfo[] = this.filterItemExceedCurrentScreen(allGridLayoutItems);
      this.exceedScreenItems = this.filterItemInnerCurrentScreen(allGridLayoutItems);
      if (CheckEmptyUtils.isEmptyArr(allGridLayoutItems)) {
        log.showInfo(TAG, `prepareSortParam allGridLayoutItems is empty`);
        return false;
      }
      const pageDesktopGridStyleConfig: PageDesktopGridStyleConfig = this.getPageDesktopStyleConfig();
      let column: number = pageDesktopGridStyleConfig.mColumns;
      let row: number = pageDesktopGridStyleConfig.mRows;
      log.showInfo(TAG, `prepareSortParam column: ${column}, row: ${row}`);
      let length1 = this.isBigScreen ? 2 : 1;
      this.posOccupyArray =
        Array(length1).fill(false).map(() => Array(row).fill(false).map(() => Array(column).fill(false)));
      let length = innerGridLayoutItems.length;
      for (let i = 0; i < length; i++) {
        if (innerGridLayoutItems[i].typeId === CommonConstants.TYPE_APP ||
          innerGridLayoutItems[i].typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
          this.appGridLayoutItems.push(innerGridLayoutItems[i]);
          continue;
        }
        if (innerGridLayoutItems[i].typeId === CommonConstants.TYPE_FILE_FOLDER &&
          innerGridLayoutItems[i].fileType === FileType.TYPE_FOLDER) {
          this.folderGridLayoutItems.push(innerGridLayoutItems[i]);
          continue;
        }
        if (innerGridLayoutItems[i].typeId === CommonConstants.TYPE_FILE_FOLDER &&
          innerGridLayoutItems[i].fileType === FileType.TYPE_FILE) {
          this.fileGridLayoutItems.push(innerGridLayoutItems[i]);
          continue;
        }
        if (innerGridLayoutItems[i].typeId === CommonConstants.TYPE_CARD) {
          this.cardGridLayoutItems.push(innerGridLayoutItems[i]);
          this.recordGardPosInfo(innerGridLayoutItems[i]);
          continue;
        }
        if (allGridLayoutItems[i].typeId === CommonConstants.TYPE_REGION_FOLDER) {
          this.regionFolderGridLayoutItems.push(allGridLayoutItems[i]);
          this.recordGardPosInfo(allGridLayoutItems[i]);
          continue;
        }
      }
      if (!this.checkIsNeedSort()) {
        return false;
      }
      this.checkAppGridLayoutItems();
      log.showInfo(TAG, `prepareSortParam allGridLayoutItems length: ${allGridLayoutItems.length}`);
      this.dumpGridLayoutPosInfo(innerGridLayoutItems);
      return true;
    } catch (err) {
      log.showInfo(TAG, `prepareSortParam error，code: ${err?.code}, message: ${err?.message}`);
      return false;
    }
  }

  private checkIsNeedSort(): boolean {
    if (CheckEmptyUtils.isEmptyArr(this.appGridLayoutItems) && CheckEmptyUtils.isEmptyArr(this.folderGridLayoutItems) &&
    CheckEmptyUtils.isEmptyArr(this.fileGridLayoutItems)) {
      log.showInfo(TAG, `app folder file Items all empty`);
      return false;
    }
    return true;
  }

  private recordGardPosInfo(item: GridLayoutItemInfo): void {
    if (item.column === undefined || !item.area || item.row === undefined || item.page === undefined) {
      return;
    }
    try {
      for (let j = item.column; j < item.column + item.area[0]; j++) {
        for (let k = item.row; k < item.row + item.area[1]; k++) {
          this.posOccupyArray[item.page][k][j] = true;
        }
      }
    } catch (error) {
      log.showError(TAG, `recordGardPosInfo error, error.code: ${error?.code}, error.message: ${error?.message},
        page: ${item?.page}`);
    }
  }

  private dumpGridLayoutPosInfo(items: GridLayoutItemInfo[]): void {
    for (let item of items) {
      log.showInfo(TAG, `dump appName: ${item.appName}, ino: ${item.ino}, ` +
        `cardName: ${item.cardName}, column: ${item.column}, row: ${item.row}, ` +
        `page: ${item.page} ` + `size: ${item.size}, ctime: ${item.ctime}, mtime: ${item.mtime}`);
    }
  }

  private toastCantAdd(): void {
    const isPortrait: boolean = AppStorage.get<boolean>('isPortrait') as boolean;
    Prompt.showToast({
      message: $r(isPortrait ? 'app.string.cant_add_current_or_landscape' : 'app.string.cant_add_current_or_portrait')
    });
  }

  private checkAppGridLayoutItems(): void {
    let length = this.appGridLayoutItems.length;
    for (let i = 0; i < length; i++) {
      if (!this.appGridLayoutItems[i]) {
        continue;
      }
      if (CheckEmptyUtils.checkStrIsEmpty(this.appGridLayoutItems[i].appName) &&
        (!CheckEmptyUtils.checkStrIsEmpty(this.appGridLayoutItems[i].bundleName))) {
        this.appGridLayoutItems[i].appName =
          ResourceManager.getInstance().getBundleAppName(this.appGridLayoutItems[i].bundleName);
        log.showInfo(TAG, `checkAppGridLayoutItems appName: ${this.appGridLayoutItems[i].appName}`);
      }
    }
  }

  public getForeachKey(item: GridLayoutItemInfo, desktopIconChange: number,
    isGameEngineValid: boolean = false, disabledLiveFormCount: number = 0,
    isOuter: boolean = false): string {
    if (item.typeId === CommonConstants.TYPE_FOLDER) {
      // folder do not rebuild When dragging out item from folder
      // rebuild is not allowed when transition animate playing
      if (GridLayoutUtil.isSmallFolder(item)) {
        let folderKey: string = `${item.folderId}_${item.area}`;
        log.showInfo(TAG, `Small folderKey changed: ${folderKey}`);
        return folderKey + desktopIconChange;
      }
      return this.getFolderThemeKey(item, desktopIconChange);
    } else if (item.typeId === CommonConstants.TYPE_CARD) {
      if (item.gameCardInfo && disabledLiveFormCount > 0) {
        let isLiveFormDisabled: boolean = OverflowGrayAppManager.getInstance().isBundleNameInDisabledLiveFormSet(item.bundleName);
        return `${item.cardId}${item.cardName}${item.bundleName}${item.abilityName}${item.moduleName}` +
          `${item.appLabelId}${item.typeId}${item.area}${item.areaType}${item.formConfigAbility}` +
          `${item.formRefreshDate}${isGameEngineValid}${isLiveFormDisabled}`;
      }
      return `${item.cardId}${item.cardName}${item.bundleName}${item.abilityName}${item.moduleName}${item.appLabelId}` +
        `${item.typeId}${item.area}${item.areaType}${item.formConfigAbility}${item.formRefreshDate}`;
    } else if (item.typeId === CommonConstants.TYPE_FILE_FOLDER) {
      return `${item.id}${item.infoId}${item.ino}`;
    } else if (item.typeId === CommonConstants.TYPE_FORM_STACK && isOuter) {
      return `${item.formStackId}${item.bundleName}${item.abilityName}${item.moduleName}${item.appLabelId}` +
        `${item.typeId}${item.area}${item.areaType}${item.formConfigAbility}${item.formRefreshDate}`;
    } else if (item.typeId === CommonConstants.TYPE_FORM_STACK) {
      if (!item.layoutInfo) {
        return `${item.formStackId}${item.bundleName}${item.abilityName}${item.moduleName}${item.appLabelId}` +
          `${item.typeId}${item.area}${item.areaType}${item.formConfigAbility}${item.formRefreshDate}${desktopIconChange}`;
      }
      return `${item.formStackId}${item.bundleName}${item.abilityName}${item.moduleName}${item.appLabelId}` +
        `${item.typeId}${item.area}${item.areaType}${item.formConfigAbility}${item.formRefreshDate}${desktopIconChange}`;
    } else if (item.typeId === CommonConstants.TYPE_REGION_FOLDER) {
      return `${item.folderId}`;
    } else {
      return this.getAppIconKey(item, desktopIconChange);
    }
  }

  private getFolderThemeKey(item: GridLayoutItemInfo, desktopIconChange: number): string {
    let folderKey: string = `${item.folderId}_${item.area}'`;
    return folderKey + desktopIconChange;
  }

  private getAppIconKey(item: GridLayoutItemInfo, desktopIconChange: number): string {
    let result: string = `${item.bundleName}${item.moduleName}${item.abilityName}${item.typeId}${item.appIndex}${item.shortcutId}` +
      `${item.installTime}${item.appIconId}${item.appLabelId}`;
    if (DeviceHelper.isPC()) {
      result += `${item.appStatus}${desktopIconChange}`;
    } else if (item.appStatus === AppStatus.INSTALLED) {
      // 如果是手机只有appStatus的状态变成0，才触发1次上下树，其它状态变化不触发上下树
      result += '0';
    }
    return result;
  }

  public clearSortParam(): void {
    this.posOccupyArray = [];
    this.appGridLayoutItems = [];
    this.folderGridLayoutItems = [];
    this.fileGridLayoutItems = [];
    this.cardGridLayoutItems = [];
    this.regionFolderGridLayoutItems = [];
  }

  /**
   * 升序时按照应用图标、文件夹、文件排列；降序时，按照文件，文件夹、应用图标排列
   * @param isAscend 是否升序排列
   * @returns
   */
  private RearrangeItemsPostion(isAscend: boolean): GridLayoutItemInfo[] {
    let newGridLayoutItems: GridLayoutItemInfo[] = [];
    if (isAscend) {
      newGridLayoutItems = this.appGridLayoutItems.concat(this.folderGridLayoutItems, this.fileGridLayoutItems);
    } else {
      newGridLayoutItems = this.fileGridLayoutItems.concat(this.folderGridLayoutItems, this.appGridLayoutItems);
    }
    if (CheckEmptyUtils.isEmptyArr(newGridLayoutItems)) {
      return newGridLayoutItems;
    }
    try {
      let foldStatus: display.FoldStatus = display.getFoldStatus();
      this.isExpandStatus = foldStatus === display.FoldStatus.FOLD_STATUS_EXPANDED;
    } catch (error) {
      log.showError(TAG, `get super fold status fail ${error?.code}, ${error?.message}`);
      return newGridLayoutItems;
    }
    const isPortrait: boolean = AppStorage.get<boolean>('isPortrait') as boolean;
    const pageDesktopGridStyleConfig = this.getPageDesktopStyleConfig();
    // column折叠PC横屏 * 2，row折叠PC竖屏 * 2
    let column: number = this.isBigScreen && this.isExpandStatus && !isPortrait ? pageDesktopGridStyleConfig.mColumns * 2 :
      pageDesktopGridStyleConfig.mColumns;
    let row: number =
      this.isBigScreen && this.isExpandStatus && isPortrait ? pageDesktopGridStyleConfig.mRows * 2 :
        pageDesktopGridStyleConfig.mRows;
    let index: number = 0;
    for (let i = 0; i < column; i++) {
      for (let j = 0; j < row; j++) {
        const currentPage = this.isExpandStatus ?
          Math.floor(isPortrait ? j / pageDesktopGridStyleConfig.mRows : i / pageDesktopGridStyleConfig.mColumns) :
          this.sortOrTrimPage;
        const rowInCurrentPage = j % pageDesktopGridStyleConfig.mRows;
        const columnInCurrentPage = i % pageDesktopGridStyleConfig.mColumns;
        if (this.posOccupyArray[currentPage][rowInCurrentPage][columnInCurrentPage]) {
          continue;
        }
        while (!this.isExpandStatus && newGridLayoutItems[index].page !== currentPage) {
          // 如果是折叠态并且不是当前排序页的元素则跳过该元素
          index++;
          if (index >= newGridLayoutItems.length) {
            log.showInfo(TAG, `RearrangeItemsPostion return newGridLayoutItems length: ${newGridLayoutItems.length}`);
            return newGridLayoutItems;
          }
        }
        newGridLayoutItems[index].column = columnInCurrentPage;
        newGridLayoutItems[index].row = rowInCurrentPage;
        newGridLayoutItems[index].page = currentPage;
        index++;
        if (index >= newGridLayoutItems.length) {
          log.showInfo(TAG, `RearrangeItemsPostion return newGridLayoutItems length: ${newGridLayoutItems.length}`);
          return newGridLayoutItems;
        }
      }
    }
    return newGridLayoutItems;
  }

  private sortDesktopItemByName(isAscend: boolean = true): GridLayoutItemInfo[] {
    this.appGridLayoutItems = DesktopSortUtils.sortItemsByName(this.appGridLayoutItems, isAscend, true);
    this.folderGridLayoutItems = DesktopSortUtils.sortItemsByName(this.folderGridLayoutItems, isAscend, false);
    this.fileGridLayoutItems = DesktopSortUtils.sortItemsByName(this.fileGridLayoutItems, isAscend, false);
    return this.RearrangeItemsPostion(isAscend);
  }

  private sortDesktopItemByModifiedTime(isAscend: boolean = true): GridLayoutItemInfo[] {
    this.appGridLayoutItems = DesktopSortUtils.sortItemsByName(this.appGridLayoutItems, isAscend, true);
    this.folderGridLayoutItems = DesktopSortUtils.sortItemsByModifiedTime(this.folderGridLayoutItems, isAscend);
    this.fileGridLayoutItems = DesktopSortUtils.sortItemsByModifiedTime(this.fileGridLayoutItems, isAscend);
    return this.RearrangeItemsPostion(isAscend);
  }

  private sortDesktopItemByCreatedTime(isAscend: boolean = true): GridLayoutItemInfo[] {
    this.appGridLayoutItems = DesktopSortUtils.sortItemsByName(this.appGridLayoutItems, isAscend, true);
    this.folderGridLayoutItems = DesktopSortUtils.sortItemsByCreatedTime(this.folderGridLayoutItems, isAscend);
    this.fileGridLayoutItems = DesktopSortUtils.sortItemsByCreatedTime(this.fileGridLayoutItems, isAscend);
    return this.RearrangeItemsPostion(isAscend);
  }

  private sortDesktopItemBySize(isAscend: boolean = true): GridLayoutItemInfo[] {
    this.appGridLayoutItems = DesktopSortUtils.sortItemsByName(this.appGridLayoutItems, isAscend, true);
    this.folderGridLayoutItems = DesktopSortUtils.sortItemsBySize(this.folderGridLayoutItems, isAscend);
    this.fileGridLayoutItems = DesktopSortUtils.sortItemsBySize(this.fileGridLayoutItems, isAscend);
    return this.RearrangeItemsPostion(isAscend);
  }

  private sortDesktopItemByType(isAscend: boolean = true): GridLayoutItemInfo[] {
    this.appGridLayoutItems = DesktopSortUtils.sortItemsByName(this.appGridLayoutItems, isAscend, true);
    this.folderGridLayoutItems = DesktopSortUtils.sortItemsByName(this.folderGridLayoutItems, isAscend, false);
    this.fileGridLayoutItems = DesktopSortUtils.sortItemsByType(this.fileGridLayoutItems, isAscend);
    return this.RearrangeItemsPostion(isAscend);
  }
}