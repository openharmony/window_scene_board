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

import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { GlobalContext } from '@ohos/frameworkwrapper'
import {
  ResUtils,
  SCBSceneSessionManager
} from '@ohos/windowscene';
import FormStyleConstants from '@ohos/form/src/main/ets/default/common/constants/FormStyleConstants';
import { LazyDataSource } from '@ohos/launchercommon/Index';
import {
  AppItemInfo,
  DeviceState,
  FolderStyleConstants,
  LayoutViewModel,
  StyleConstants,
} from '@ohos/launchercommon/src/main/ets/TsIndex';
import { OuterAppManager } from '@ohos/launchercommon/src/main/ets/manager/OuterAppManager';
import {
  OuterIconCenterViewManager,
  OutIconCenterViewController
} from '@ohos/launchercommon/src/main/ets/manager/OuterIconCenterViewManager';
import { CommonConstants } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { systemParameter } from '@kit.BasicServicesKit';
import ServiceExtensionContext from 'application/ServiceExtensionContext';
import { EditModeConstants } from '@ohos/launchercommon';
import { ViewData } from '../viewmodel/OuterEditCenterObservedData';
import { OuterIconCenterViewData } from '../viewmodel/OuterIconCenterViewData';
import OuterCenterAppItem from './OuterCenterAppItem';
import EditModeStyleConstants from '../common/constants/EditModeStyleConstants';
import { SmallFoldStyleUtil } from '@ohos/launchercommon/src/main/ets/utils/SmallFoldStyleUtil';
import { curves, LengthMetrics } from '@kit.ArkUI';
import {
  EditSearchComponentParam,
  EditSearchShowState,
  EditSearchState,
  EditSearchStateMgr
} from '@ohos/launchercommon/src/main/ets/outerdesktop/viewmodel/EditSearchComponentData';
import { EditModeSearchComponent } from '@ohos/launchercommon/src/main/ets/outerdesktop/view/EditModeSearchComponent';
import {
  EditModeSearchOptions
} from '@ohos/launchercommon/src/main/ets/outerdesktop/viewmodel/EditModeSearchComponentEvent';
import {
  OuterIconCenterViewModel
} from '@ohos/launchercommon/src/main/ets/outerdesktop/viewmodel/OutIconCenterViewModel';

const TAG = 'OuterIconCenterView';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 外屏应用中心View
 */
@Component
export struct OuterIconCenterView {
  @StorageProp('lockReceived') @Watch('closeView') lockReceived: number = 0;
  @StorageLink('folderStatus') @Watch('closeView') folderStatus: number = DeviceState.DEFAULT_STATE;
  @Provide mBindSheetHeight: number = 0;
  @Provide clickIndex: number = 0;
  @Prop iconSize: number = StyleConstants.DEFAULT_APP_ICON_SIZE_WIDTH;
  @State mViewData: ViewData = new ViewData();
  @State isTipsRememberPopup: boolean = false;
  @State mTopAppInfoList: LazyDataSource<AppItemInfo> = new LazyDataSource<AppItemInfo>();
  @State mExperimentalAppInfoList: LazyDataSource<AppItemInfo> = new LazyDataSource<AppItemInfo>();
  @State mSearchResultTopAppInfoList: LazyDataSource<AppItemInfo> = new LazyDataSource<AppItemInfo>();
  @State mSearchResultExperimentalAppInfoList: LazyDataSource<AppItemInfo> = new LazyDataSource<AppItemInfo>();

  @State @Watch('outerIconCenterShowChange') outerIconCenterShow: boolean = false;
  @State showTopApps: boolean = false;
  @State showExperimentalApps: boolean = false;
  @State mSearchStateMgr: EditSearchStateMgr = EditSearchStateMgr.getInstance();
  @State showResultByTop: boolean = false;
  @State showResultByExperimental: boolean = false;
  @State showNoData: boolean = false;
  @State showResult: boolean = false;
  @State showNoResult: boolean = false;
  private scroller: Scroller = new Scroller();
  private mOuterIconCenterViewData: OuterIconCenterViewData = OuterIconCenterViewData.getInstance();
  private mOuterIconCenterViewModel: OuterIconCenterViewModel = OuterIconCenterViewModel.getInstance();
  private mOuterIconCenterViewManager: OuterIconCenterViewManager = OuterIconCenterViewManager.getInstance();
  private mOuterAppManager: OuterAppManager = OuterAppManager.getInstance();
  private mDockHeight: number = FormStyleConstants.MULTI_WINDOWS_DOCK_HEIGHT;
  private mSearchComponentParam: EditSearchComponentParam = new EditSearchComponentParam();
  private mDesktopContext?: ServiceExtensionContext = GlobalContext.getContext();
  private mEditModeSearchOptions: EditModeSearchOptions = new EditModeSearchOptions();
  private viewController: OutIconCenterViewController = {
    showView: (viewHeight?: number): void => {
      let sheetHeight: number | undefined = viewHeight;
      let isScreenLock: boolean =
        systemParameter.getSync(EditModeConstants.SCREEN_LOCK_BIND_SHEET, 'false') === 'true';
      if (isScreenLock) {
        let height: number = Number(systemParameter
          .getSync(EditModeConstants.SCREEN_LOCK_BIND_SHEET_HEIGHT, '0'));
        log.showInfo(`screenLockBindSheetHeight: ${height}`);
        if (height !== 0) {
          sheetHeight = height;
        }
      }
      if (this.outerIconCenterShow) {
        let bindSheetHeight: number = this.mViewData.bindSheetHeight;
        // 打桩高度有效：不为空且不等于0
        if (sheetHeight) {
          bindSheetHeight = sheetHeight as number;
        }
        this.mBindSheetHeight = bindSheetHeight;
        log.showInfo(`recovery formCenterView current height: ${this.mBindSheetHeight}`);
        return;
      }
      this.showView(sheetHeight);
    },
    hideView: () => {
      this.mBindSheetHeight = 0;
      OuterIconCenterViewManager.getInstance().setOuterAppIsEnable(true);
    },
    closeView: () => this.closeView(),
    backGestureHandler: () => this.backGestureHandler()
  }

  private searchIconOnClick = () => {
    this.setResultShowStatus(false, false);
    this.mSearchStateMgr.setShowState(EditSearchShowState.SHOW);
    this.showNoResult = false;
    this.showResult = true;
    this.showTopApps = false;
    this.showExperimentalApps = false;
  }

  private backIconOnClick = () => {
    this.setResultShowStatus(false, false);
    this.mSearchStateMgr.setShowState(EditSearchShowState.NOT_SHOW);
    this.showNoResult = false;
    this.recoverOuterAppView();
    this.showTopApps = this.mTopAppInfoList.totalCount() !== 0;
    this.showExperimentalApps = this.mExperimentalAppInfoList.totalCount() !== 0;
    this.showResult = false;
    this.showNoData = !this.showTopApps && !this.showExperimentalApps;
  }

  private closeIconOnClick = () => {
    this.closeView();
  }

  private setResultShowStatus(showResultByTop: boolean, showResultByExperimental: boolean) {
    this.showResultByTop = showResultByTop;
    this.showResultByExperimental = showResultByExperimental;
  }

  private outerIconCenterShowChange(): void {
    log.showWarn(`outerIconCenterShowChange: ${this.outerIconCenterShow}`);
  }

  /**
   * show view of OuterIconCenter
   *
   * @param bundleName bundleName
   * @param viewHeight viewHeight
   * @returns void
   */
  private async showView(viewHeight?: number): Promise<void> {
    // 初始化搜索模块
    this.mDesktopContext?.eventHub.emit(EditModeConstants.OUTER_RESET_SEARCH_COMPONENT, true);
    this.mViewData = this.mOuterIconCenterViewData.getViewData(false);
    await this.mOuterIconCenterViewModel.updateOuterIconCenterData();
    this.mBindSheetHeight = this.mViewData.bindSheetHeight;
    if (viewHeight !== undefined) {
      this.mBindSheetHeight = Number(viewHeight);
    }
    this.getShowInfo();
    this.mOuterIconCenterViewManager.setOuterIconCenterViewState(true);
    this.outerIconCenterShow = true;
    this.initEditSearchComponentParam();
    OuterIconCenterViewManager.getInstance().setOuterAppIsEnable(true);
  }

  /**
   * closeView
   */
  private closeView(): void {
    if (!this.outerIconCenterShow) {
      log.showWarn('closeView view is closed');
      return;
    }
    log.showWarn('close icon center View');
    this.mOuterIconCenterViewManager.setOuterIconCenterViewState(false);
    this.mSearchStateMgr.setShowState(EditSearchShowState.NOT_SHOW);
    this.setResultShowStatus(false, false);
    this.showResult = false;
    this.showNoResult = false;
    this.outerIconCenterShow = false;
    OuterIconCenterViewManager.getInstance().setOuterAppIsEnable(true);
  }

  private backGestureHandler(): void {
    if (!this.outerIconCenterShow) {
      return;
    }

    // 获焦状态下，只关闭键盘
    if (this.mSearchStateMgr.getState() === EditSearchState.FOCUSED) {
      this.mDesktopContext?.eventHub.emit(EditModeConstants.CLOSE_KEY_BOARD_OF_OUTER_EDIT_CENTER);
      return;
    }

    // 搜索框有内容,清除搜索框,返回标题栏
    if (this.mSearchStateMgr.getShowState() === EditSearchShowState.SHOW) {
      this.mDesktopContext?.eventHub.emit(EditModeConstants.OUTER_RETURN_TO_TITLE);
      this.recoverOuterAppView();
      return;
    }

    this.mDesktopContext?.eventHub.emit(CommonConstants.EVENTHUB_FORM_MANAGER_EXIT);
    log.showInfo('deal backGestureHandler');
    this.mOuterIconCenterViewManager.setOuterIconCenterViewState(false);
    this.outerIconCenterShow = false;
  }

  aboutToAppear(): void {
    log.showInfo('aboutToAppear');
    this.mOuterIconCenterViewData.updateViewDate(false);
    this.mOuterIconCenterViewManager.registerOuterIconCenterViewController(this.viewController);
    // 初始化EditModeSearch点击事件
    this.initEditModeSearchOptions()
  }

  aboutToDisappear(): void {
    log.showInfo('aboutToDisappear');
    this.mTopAppInfoList.clear();
    this.mExperimentalAppInfoList.clear();
    this.mOuterIconCenterViewManager.unRegisterOuterIconCenterViewController();
  }

  private initEditSearchComponentParam() {
    log.showInfo(`getAppInfoList length: ${this.mOuterIconCenterViewModel.getAppInfoList().length}`);
    this.mSearchComponentParam.fullAppList = this.mOuterIconCenterViewModel.getAppInfoList();
    this.mSearchComponentParam.allAppListByAdded = this.mOuterIconCenterViewModel.getAllListByAdded();
    this.mSearchComponentParam.afterSearchCallback = (bundleName?: string, searchResultList? :AppItemInfo[]) =>
    this.afterSearchCallback(bundleName, searchResultList);
  }

  /**
   * 搜索结果改变的回调
   *
   */
  private afterSearchCallback(bundleName?: string, searchResultList? :AppItemInfo[]): void {
    let topQualityPkgList: AppItemInfo[] = this.mOuterIconCenterViewModel.getTopQualityPkgList();
    let poorExperimentalPkgList: AppItemInfo[] = this.mOuterIconCenterViewModel.getPoorExperimentalPkgList();
    this.mSearchResultTopAppInfoList.clear();
    this.mSearchResultExperimentalAppInfoList.clear();
    this.initTipsImageStatus();
    if (bundleName === EditModeConstants.OUTER_EDIT_SEARCH_NO_RESULT_BY_IN_DESKTOP) {
      this.setResultShowStatus(false, false);
      this.showNoData = true;
      return;
    }
    if (bundleName === EditModeConstants.OUTER_EDIT_SEARCH_NO_RESULT) {
      this.setResultShowStatus(false, false);
      this.showNoResult = true;
      return;
    }
    if (bundleName === EditModeConstants.OUTER_EDIT_SEARCH_NO_VALUE) {
      this.setResultShowStatus(false, false);
      return;
    }
    log.showInfo(`afterSearchCallback searchResultList: ${searchResultList?.length}`);
    searchResultList?.forEach(searchResult => {
      let appItem: AppItemInfo | undefined = topQualityPkgList.find(topAppItem => {
        return (topAppItem.bundleName === searchResult.bundleName && topAppItem.appIndex === searchResult.appIndex);
      });
      if (!CheckEmptyUtils.isEmpty(appItem)) {
        this.mSearchResultTopAppInfoList.pushItem(searchResult);
      }
      appItem = poorExperimentalPkgList.find(experimentalAppItem => {
        return (experimentalAppItem.bundleName === searchResult.bundleName &&
          experimentalAppItem.appIndex === searchResult.appIndex);
      });
      if (!CheckEmptyUtils.isEmpty(appItem)) {
        this.mSearchResultExperimentalAppInfoList.pushItem(searchResult);
      }
    });
    this.setResultShowStatus(this.mSearchResultTopAppInfoList.totalCount() !== 0,
      this.mSearchResultExperimentalAppInfoList.totalCount() !== 0);
  }

  private initTipsImageStatus() {
    this.showNoResult = false;
    this.showNoData = false;
  }

  private getShowInfo(): void {
    let topQualityPkgList: AppItemInfo[] = this.mOuterIconCenterViewModel.getTopQualityPkgList();
    let poorExperimentalPkgList: AppItemInfo[] = this.mOuterIconCenterViewModel.getPoorExperimentalPkgList();
    this.mTopAppInfoList.clear();
    this.mExperimentalAppInfoList.clear();
    this.mSearchResultTopAppInfoList.clear();
    this.mSearchResultExperimentalAppInfoList.clear();

    for (let topQualityPkg of topQualityPkgList) {
      this.mTopAppInfoList.pushItem(topQualityPkg);
    }
    for (let poorExperimental of poorExperimentalPkgList) {
      this.mExperimentalAppInfoList.pushItem(poorExperimental);
    }

    log.showInfo('getShowInfo OuterIconCenterViewModel' +
      `topQualityPkgList length: ${topQualityPkgList.length}` +
      `poorExperimentalPkgList length: ${poorExperimentalPkgList.length}`);
    this.showTopApps = this.mTopAppInfoList.totalCount() !== 0;
    this.showExperimentalApps = this.mExperimentalAppInfoList.totalCount() !== 0;
    this.showNoData = !this.showTopApps && !this.showExperimentalApps;
  }

  private destroyViewData(): void {
    // 确保页面置false之后再打开dock栏，否则dock会拉起失败
    this.mOuterIconCenterViewManager.closeOuterIconCenterView();
    this.mTopAppInfoList = new LazyDataSource<AppItemInfo>();
    this.mExperimentalAppInfoList = new LazyDataSource<AppItemInfo>();
  }

  private recoverOuterAppView(): void {
    log.showInfo('recoverOuterAppView');
    this.showResultByTop = false;
    this.showResultByExperimental = false;
    this.mSearchResultTopAppInfoList.clear();
    this.mSearchResultExperimentalAppInfoList.clear();
    this.mDesktopContext?.eventHub.emit(EditModeConstants.OUTER_RESET_SEARCH_DATA);
  }

  private initEditModeSearchOptions() {
    this.mEditModeSearchOptions.searchIconOnClick = this.searchIconOnClick;
    this.mEditModeSearchOptions.backIconOnClick = this.backIconOnClick;
    this.mEditModeSearchOptions.closeIconOnClick = this.closeIconOnClick;
  }

  private deleteItem(appItem: AppItemInfo, isTop: boolean) {
    if (isTop) {
      this.deleteItemByItem(this.mTopAppInfoList, appItem);
      this.deleteItemByItem(this.mSearchResultTopAppInfoList, appItem);
    } else {
      this.deleteItemByItem(this.mExperimentalAppInfoList, appItem);
      this.deleteItemByItem(this.mSearchResultExperimentalAppInfoList, appItem);
    }
  }

  private deleteItemByItem(appItemList: LazyDataSource<AppItemInfo>, appItem: AppItemInfo) {
    let index: number = appItemList.indexOf(appItem);
    if (index !== -1) {
      appItemList.deleteItemByIndex(index);
    }
  }

  @Builder
  premiumAppTitleBuilder() {
    Column() {
      Text($r('app.string.premium_apps'))
        .draggable(false)
        .textAlign(TextAlign.Start)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(1)
        .fontSize(SmallFoldStyleUtil
          .getScaleSize(EditModeStyleConstants.OUTER_EDIT_CATEGORIZE_APP_FONT_SIZE
            , SmallFoldStyleUtil.LEVEL_BIG_3_FONT_SIZE_SCALE))
        .fontColor($r('sys.color.ohos_id_color_text_secondary'))
        .fontWeight(FontWeight.Medium)
        .fontFamily('HarmonyHeiTi')
    }
    .id(`${TAG}_title1_column`)
    .alignItems(HorizontalAlign.Start)
    .justifyContent(FlexAlign.Center)
    .width('100%')
    .margin({
      bottom: EditModeStyleConstants.OUTER_EDIT_CATEGORIZE_APP_TITLE_MANAGE,
    })
    .constraintSize({ minHeight: EditModeStyleConstants.OUTER_EDIT_CATEGORIZE_TITLE_HEIGHT })
  }

  @Builder
  experimentalAppTitleBuilder() {
    Row() {
      Text($r('app.string.experimental_apps'))
        .draggable(false)
        .textAlign(TextAlign.Start)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(1)
        .fontSize(SmallFoldStyleUtil
          .getScaleSize(EditModeStyleConstants.OUTER_EDIT_CATEGORIZE_APP_FONT_SIZE
            , SmallFoldStyleUtil.LEVEL_BIG_3_FONT_SIZE_SCALE))
        .fontColor($r('sys.color.ohos_id_color_text_secondary'))
        .fontWeight(FontWeight.Medium)
        .fontFamily('HarmonyHeiTi')
      Image($r('app.media.ic_public_detail'))
        .draggable(false)
        .width(EditModeStyleConstants.OUTER_EDIT_EXPERIMENTAL_APP_IMAGE_SIZE)
        .height(EditModeStyleConstants.OUTER_EDIT_EXPERIMENTAL_APP_IMAGE_SIZE)
        .margin({
          start: LengthMetrics.vp(EditModeStyleConstants.OUTER_EDIT_EXPERIMENTAL_APP_IMAGE_MARGIN)
        })
        .fillColor($r('sys.color.ohos_id_color_text_primary'))
        .onClick(() => {
          this.isTipsRememberPopup = !this.isTipsRememberPopup;
          log.showInfo(`isSimRememberPopup = ${this.isTipsRememberPopup}`);
        })
        .bindPopup(this.isTipsRememberPopup, {
          message: ResUtils.getInnerString($r('app.string.lab_application')),
          messageOptions: {
            font: { size: EditModeStyleConstants.OUTER_EDIT_EXPERIMENTAL_APP_PROMPT_MESSAGE_SIZE
              , family: 'HarmonyHeiTi', weight: FontWeight.Regular }
          },
          placement: Placement.Top,
          offset: {
            x: EditModeStyleConstants.OUTER_EDIT_EXPERIMENTAL_APP_PROMPT_MESSAGE_OFFSET_X
          },
          onStateChange: (e) => {
            if (!e.isVisible) {
              this.isTipsRememberPopup = false;
            }
          }
        })
    }
    .id(`${TAG}_title2_column`)
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.Start)
    .constraintSize({ minHeight: EditModeStyleConstants.OUTER_EDIT_CATEGORIZE_TITLE_HEIGHT })
    .width('100%')
    .margin({
      top: this.showTopApps ? 0 : EditModeStyleConstants.OUTER_EDIT_CATEGORIZE_APP_TITLE_MANAGE,
        bottom: EditModeStyleConstants.OUTER_EDIT_CATEGORIZE_APP_TITLE_MANAGE,
    })
  }

  @Builder
  appListBindSheetBuilder() {
    Column() {
      Column() {
        EditModeSearchComponent({ titleName:$r('app.string.add_apps_to_outer_page')
        , mSearchComponentParam: this.mSearchComponentParam, mEditModeSearchOptions: this.mEditModeSearchOptions})
      }
      .margin({ top: EditModeConstants.OUTER_SEARCH_COMPONENT_TOP_MARGIN })
      .height(EditModeConstants.OUTER_SEARCH_COMPONENT_HEIGHT)
      .width(EditModeConstants.OUTER_SEARCH_COMPONENT_WIDTH)
      .justifyContent(FlexAlign.Center)
      Stack({ alignContent: Alignment.Top }) {
        this.appScrollBuild();
        if (this.showNoData) {
          this.notDataBuild();
        }
        if (this.showNoResult) {
          this.notSearchBuild();
        }
      }
    }
  }

  @Builder
  notSearchBuild() {
    Column() {
      Image($r('app.media.search_no_result'))
        .height(EditModeConstants.OUTER_TIPS_IMAGE_SIZE)
        .width(EditModeConstants.OUTER_TIPS_IMAGE_SIZE)
        .draggable(false)

      Text($r('app.string.not_have_add_app'))
        .font({ size: EditModeConstants.OUTER_TIPS_TEXT_SIZE
        , family: 'HarmonyHeiTi', weight: FontWeight.Regular })
        .fontSize(FormStyleConstants.SEARCH_RESULT_EMPTY_FONT_SIZE)
        .fontColor($r('sys.color.font_tertiary'))
        .draggable(false)
        .textAlign(TextAlign.Center)

    }
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .height(EditModeConstants.OUTER_CENTER_DATA_HEIGHT)
    .offset({ y: -4 })
    .width('100%')
  }

  @Builder
  notDataBuild() {
    Column() {
      Image($r('app.media.ic_public_no_installation_package'))
        .height(EditModeConstants.OUTER_TIPS_IMAGE_SIZE)
        .width(EditModeConstants.OUTER_TIPS_IMAGE_SIZE)
        .draggable(false)

      Text($r('app.string.external_screen_app_added'))
        .font({ size: EditModeConstants.OUTER_TIPS_TEXT_SIZE
        , family: 'HarmonyHeiTi', weight: FontWeight.Regular })
        .fontColor($r('sys.color.font_tertiary'))
        .draggable(false)
        .textAlign(TextAlign.Center)
    }
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .height(EditModeConstants.OUTER_CENTER_DATA_HEIGHT)
    .offset({ y: -4 })
    .width('100%')
  }

  @Builder
  appScrollBuild() {
    Stack() {
      this.buildAppListBindSheetBuilder();
      ScrollBar({ scroller: this.scroller, direction: ScrollBarDirection.Vertical, state: BarState.Auto })
        .margin({
          bottom: EditModeStyleConstants.OUTER_APP_CENTER_SCROLL_BAR_BOTTOM_MARGIN
        })
    }
    .alignContent(Alignment.TopEnd)
    .width('100%')
    .height(EditModeStyleConstants.OUTER_APP_CENTER_LIST_HEIGHT)
  }

  @Builder
  buildGridAppList(isTop: boolean, appList: LazyDataSource<AppItemInfo>) {
    LazyForEach(appList, (item: AppItemInfo, index: number) => {
      GridItem() {
        OuterCenterAppItem({
          appItem: item,
          idIndex: index,
          itemWidth: FolderStyleConstants.DEFAULT_FOLDER_APP_SIZE,
          iconSize: this.iconSize,
          matchedText: this.mSearchStateMgr.getMatchedValue(),
          addAppToDeskTopCallBack: (): void => {
            animateTo({
              curve: curves.springMotion(EditModeStyleConstants.OUTER_APP_ITEM_SCALE_RESPONSE
                , EditModeStyleConstants.OUTER_ICON_SCALE_DAMPING_FRACTION)
            }, () => {
              this.deleteItem(item, isTop);
            })
            this.mSearchComponentParam.fullAppList.splice(this.mSearchComponentParam.fullAppList.indexOf(item), 1);
            if (this.showResult) {
              this.showResultByTop = this.mSearchResultTopAppInfoList.totalCount() !== 0;
              this.showResultByExperimental = this.mSearchResultExperimentalAppInfoList.totalCount() !== 0;
              this.showNoData = !this.showResultByTop && !this.showResultByExperimental;
            } else {
              this.showExperimentalApps = this.mExperimentalAppInfoList.totalCount() !== 0;
              this.showTopApps = this.mTopAppInfoList.totalCount() !== 0;
              this.showNoData = !this.showTopApps && !this.showExperimentalApps;
            }
          }
        })
      }
      .alignSelf(ItemAlign.Start)
      .onClick(() => {
        log.showInfo(`onClick item: ${item.bundleName} index: ${index}`);
        if (this.clickIndex === index) {
          return;
        }
        this.clickIndex = index;
      })
    }, (item: AppItemInfo, index: number): string => {
      return `APP_${item.bundleName}_${String(index)}`;
    })
  }

  @Builder
  buildTopAppList(appList: LazyDataSource<AppItemInfo>) {
    if (this.showTopApps || this.showResultByTop) {
      GridItem() {
        this.premiumAppTitleBuilder();
      }
      .oneLineGridItemStyle();
      this.buildGridAppList(true, appList);
    }
  }

  @Builder
  buildExperimentalAppList(appList: LazyDataSource<AppItemInfo>) {
    if (this.showExperimentalApps || this.showResultByExperimental) {
      GridItem() {
        this.experimentalAppTitleBuilder();
      }
      .oneLineGridItemStyle();
      this.buildGridAppList(false, appList);
    }
  }

  /**
   * 构建APP应用列表
   */
  @Builder
  buildAppListBindSheetBuilder() {
    Grid(this.scroller) {
      if (this.showResult) {
        this.buildTopAppList(this.mSearchResultTopAppInfoList);
        this.buildExperimentalAppList(this.mSearchResultExperimentalAppInfoList);
      } else {
        this.buildTopAppList(this.mTopAppInfoList);
        this.buildExperimentalAppList(this.mExperimentalAppInfoList);
      }
      GridItem() {}
      .oneLineGridItemStyle()
      .height(EditModeStyleConstants.OUTER_APP_CENTER_END_SPACE_HEIGHT);
    }
    .edgeEffect(EdgeEffect.Spring)
    .columnsTemplate(EditModeStyleConstants.OUTER_EDIT_APP_MANAGE_GRID_COLUMNS_TEMPLATE)
    .width('100%')
    .scrollBar(BarState.Off)
    .friction(EditModeStyleConstants.OUTER_EDIT_APP_MANAGE_SCROLL_BAR_FRICTION)
    .columnsGap(EditModeStyleConstants.OUTER_EDIT_APP_MANAGE_GRID_COLUMNS_GAP)
    .rowsGap(EditModeStyleConstants.OUTER_EDIT_APP_MANAGE_GRID_ROWS_GAP)
    .padding({
      top: EditModeStyleConstants.OUTER_EDIT_APP_MANAGE_GRID_PADDING_TOP,
      left: EditModeStyleConstants.OUTER_EDIT_APP_MANAGE_GRID_PADDING_SIDES,
      right: EditModeStyleConstants.OUTER_EDIT_APP_MANAGE_GRID_PADDING_SIDES,
    })
    .height(EditModeStyleConstants.OUTER_APP_CENTER_LIST_HEIGHT)
  }

  build() {
    Stack()
      .position({ x: 0, y: 0 })
      .id(`${TAG}_Stack`)
      .bindSheet($$this.outerIconCenterShow, this.appListBindSheetBuilder(), {
        width: this.mViewData.bindSheetWidth,
        showClose: false,
        dragBar: false,
        blurStyle: BlurStyle.COMPONENT_ULTRA_THICK,
        backgroundColor: Color.Transparent,
        detents: [this.mBindSheetHeight, 0],
        mode: SheetMode.EMBEDDED,
        scrollSizeMode: ScrollSizeMode.CONTINUOUS,
        onAppear: () => {
          log.showInfo('outerIconCenterShow bindSheet onAppear');
        },
        onDisappear: () => {
          log.showInfo(`outerIconCenterShow bindsheet onDisappear`);
          this.mOuterIconCenterViewManager.setOuterIconCenterViewState(false);
          this.outerIconCenterShow = false;
          this.showResult = false;
          this.showNoResult = false;
          if (!this.outerIconCenterShow) {
            this.destroyViewData();
          }
        }
      })
  }
}

@Extend(GridItem)
function oneLineGridItemStyle() {
  .columnStart(EditModeStyleConstants.OUTER_APP_CENTER_GRID_START)
  .columnEnd(EditModeStyleConstants.OUTER_APP_CENTER_GRID_END)
}