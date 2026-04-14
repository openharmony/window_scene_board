/*
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

import { LogDomain, LogHelper, Trace } from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import {
  localEventManager,
  AccessibilityManager,
  GlobalContext,
  HiSysEventUtil,
  ResourceManager,
} from '@ohos/frameworkwrapper';
import {
  GridLayoutItemInfo,
  StyleConfig,
  StyleConstants,
  PresetStyleConstants,
  EventConstants,
  ReceiveEventInfo,
  DeviceState,
  folderGesData,
  GridLayoutUtil,
  AppItemInfo,
  CommonConstants,
  FolderViewModel,
  layoutLockUtil,
  LayoutViewModel,
  FolderManager,
  FolderCommonConstants,
  OpenFolderStyleConfig,
  FolderStyleManager,
  BigFolderStyleConfig
} from '@ohos/launchercommon';
import { AppBubbleCommonParams, launcherVisualEffectMgr } from '@ohos/launchercommon/Index';
import { AppIconBadgeVm } from '@ohos/launchercommon/src/main/ets/launchericon/viewmodel/AppIconBadgeVm';
import { AddDialogBubbleNodeParams } from '../common/AddDialogBubbleNodeParam';
import FolderAddDialogConstant from '../common/constants/FolderAddDialogConstant';
import {
  FolderAddItemInfo,
  OpenFolderAddViewModel,
  FolderAddItemInfoType,
  folderAddSheetOther,
  sheetTitleRecommended
} from '../viewmodel/OpenFolderAddViewModel';
import { AddDialogBubble } from './AddDialogBubble';
import { MeasureText } from '@kit.ArkUI';
import common from '@ohos.app.ability.common';
import { desktopUtil, StateEx } from '@ohos/componenthelper';
import FeatureConstants from '../common/constants/FeatureConstants';
import { OpenFolderAppBubbleNodeManager } from './node/OpenFolderAppBubbleNodeManager';
import { KeyCode } from '@kit.InputKit';

const TAG = 'OpenFolderAddDialog';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

const DIALOG_TITLE_ID = 'OpenFolderAddDialog_Title';
const TRACE_DIALOG_CLOSE = 'ClickToCloseDialog';
const SCROLL_SPEED_SCALING = 0.7;
const SCROLL_START_CACHED_VALUE = 5;
const SCROLL_STOP_CACHED_VALUE = 1;

/**
 * 文件夹添加应用Dialog
 */
@Component
export default struct OpenFolderAddDialog {
  @StorageLink('showUninstallDialog') @Watch('showUninstallDialogChange') showUninstallDialog: boolean = false;
  @StorageLink('folderStatus') @Watch('folderStatusChange') folderStatus: number = DeviceState.DEFAULT_STATE;
  @StorageLink('currColorMode') @Watch('onColorModeChange') currColorMode: number =
    GlobalContext.getContext().config.colorMode as number;
  @StorageLink('openFolderStatus') @Watch('updateFolderData') openFolderStatus: number =
    FeatureConstants.OPEN_FOLDER_STATUS_CLOSE;
  @StorageProp('isAccessibilityMode') isAccessibilityMode: boolean = false;
  @State checkedAppList: GridLayoutItemInfo[] = [];
  @State allAppList: FolderAddItemInfo[] = [];
  @State folderAddDataSource: FolderAddDataSource = new FolderAddDataSource(this.allAppList);
  @State iconBadgeVm: AppIconBadgeVm = new AppIconBadgeVm();
  @State isHideDialog: boolean = false;
  @State dialogOpacity: StateEx<number> = launcherVisualEffectMgr.getDesktopDialogOpacity();

  @Prop isShow: boolean = false;
  public onIsShowChange:(newIsShow: boolean) => void = () => {};

  private paramsMap: Map<string, AddDialogBubbleNodeParams> = new Map();
  private checkedAppLength: number = 0;
  private openFolderData: GridLayoutItemInfo = FolderManager.getInstance().getOpenedFolder();
  private folderAddViewModel: OpenFolderAddViewModel = OpenFolderAddViewModel.getInstance();
  private folderName: string = this.folderAddViewModel.getRealFolderName(this.openFolderData.folderName ?? '');
  private bubbleParams: AppBubbleCommonParams = OpenFolderAppBubbleNodeManager.getInstance().getAppBubbleCommonParams();
  private dialogHeight: number = 0;
  private gridItemHeight: number = 0;
  private gridColumnTemplate: string = this.folderAddViewModel.getColumnsTemplate();
  private gridPadding: number = 0;
  private buttonWidth: number = 0;
  private openFolderItems: GridLayoutItemInfo[] = [];
  private buttonMaxFontSize: Length = FolderAddDialogConstant.BODY_L;
  private buttonMinFontSize: Length = 9;
  private titleFontSize: Length = FolderAddDialogConstant.SUBTITLE_L;
  private subTitleFontSize: Length = FolderAddDialogConstant.SUBTITLE_S;
  private isVerticalAlignButton: boolean = false;
  private isWallpaperBlurEffect: StateEx<boolean> = launcherVisualEffectMgr.isWallpaperBlurEffect;
  private title: string | Resource = $r('app.string.sheet_title_recommended');
  private folderItem: GridLayoutItemInfo = new GridLayoutItemInfo();
  private openedBy: string = FolderCommonConstants.OPEN_ADD_SHEET_ADD_BUBBLE;
  private userCancelled: boolean = false;
  private bigStyle: BigFolderStyleConfig =
    FolderStyleManager.getInstance().getFolderStyleConfig() ?? BigFolderStyleConfig.getInstance();
  @State gridCachedCount: number = 1;

  @State gridLayoutOptions: GridLayoutOptions = {
    regularSize: [1, 1],
    irregularIndexes: []
  };

  private readonly folderEventListener: ReceiveEventInfo = {
    onReceiveEvent: (event: string, params: ReceiveEventParam) => {
      log.showInfo(`receive event: ${event}`);
      if ((event === EventConstants.EVENT_EDIT_MODE_TOUCH_DOWN_ITEM) ||
          (event === EventConstants.EVENT_CLOSE_FOLDER_ADD_DIALOG)) {
        if (params?.folderStatusChang) {
          this.isHideDialog = true;
          log.showInfo('folderStatusChang to hide dialog');
        }
        this.onIsShowChange(false);
      }
    }
  };

  private updateFolderData(): void {
    if (this.openFolderStatus === FeatureConstants.FOLDER_STATUS_REQUEST_CLOSE) {
      log.showInfo('updateFolderData request close');
      this.onIsShowChange(false);
    }
  }

  private folderStatusChange(): void {
      log.showInfo(`UninstallDialog folderStatusChange: ${this.folderStatus}`);
      this.onIsShowChange(false);
  }

  private showUninstallDialogChange() {
    log.showInfo(`UninstallDialog showUninstallDialogChange showUninstallDialog: ${this.showUninstallDialog}`);
    if (!this.showUninstallDialog) {
      this.onIsShowChange(false);
    }
  }

  private onColorModeChange(): void {
    this.onIsShowChange(false);
  }

  private onGridItemClick(info: FolderAddItemInfo): void {
    if (!this.canSelectWhenLayoutLocked(info)) {
      return;
    }
    for (let clickItem of this.allAppList) {
      if (clickItem.itemInfo.keyName === info.itemInfo.keyName) {
        if (!clickItem.isChecked &&
          this.checkedAppList.length >= FolderViewModel.getMaxAppCount()) {
          FolderViewModel.showToast(CommonConstants.RES_FOLDER_ITEMS_FULL);
        } else {
          clickItem.isChecked = !clickItem.isChecked;
          log.showInfo(`onGridItemClick isChecked ${clickItem.isChecked} keyName ${clickItem.itemInfo.keyName}`);
        }
        break;
      }
    }
  }

  private canSelectWhenLayoutLocked(info: FolderAddItemInfo): boolean {
    if (!layoutLockUtil.isLocked()) {
      return true;
    }
    // 布局锁定时，预置页文件夹反选界面不响应点击事件
    if (layoutLockUtil.isLockedPage(this.openFolderData.page, 'openFolder add')) {
      return false;
    }
    let index: number = this.openFolderItems.findIndex(
      (item: GridLayoutItemInfo) => item.keyName === info.itemInfo.keyName);
    // 布局锁定时，非预置页文件夹反选界面点击预置页图标时不响应点击事件
    if (index < 0 && layoutLockUtil.isLockedPage(info.itemInfo.page, 'openFolder add item')) {
      return false;
    }
    return true;
  }

  private onCheckStateChange(isOn: boolean, info: FolderAddItemInfo): number {
    if (isOn) {
      if (!this.checkedAppList.some((item: GridLayoutItemInfo) => item.keyName === info?.itemInfo.keyName)) {
        let index: number = this.openFolderItems.findIndex(
          (item: GridLayoutItemInfo) => item.keyName === info?.itemInfo.keyName);
        if (index >= 0) {
          this.checkedAppList.splice(index, 0, info.itemInfo);
        } else {
          this.checkedAppList.push(info.itemInfo);
        }
      }
    } else {
      let index: number = this.checkedAppList.findIndex(item => item.keyName === info.itemInfo.keyName);
      if (index >= 0) {
        this.checkedAppList.splice(index, 1);
      }
    }
    for (let clickItem of this.allAppList) {
      if (clickItem.itemInfo.keyName === info.itemInfo.keyName) {
        clickItem.isChecked = isOn;
        break;
      }
    }
    if (this.checkedAppList.length !== this.checkedAppLength) {
      this.checkedAppLength = this.checkedAppList.length;
      if (this.isAccessibilityMode) {
        this.announceForCheckStatusChange(isOn);
      }
    }
    return this.checkedAppList.length;
  }

  // 无障碍模式下选中状态切换主动播报
  private announceForCheckStatusChange(isOn: boolean): void {
    const readerText = `${ResourceManager.getInstance().getStringByName(
      isOn ? 'app_checked' : 'app_not_checked')},` +
      `${ResourceManager.getInstance().getStringByName('add_to_folder', this.folderName)},` +
    GlobalContext.getContext()?.resourceManager
      .getPluralStringValueSync($r('app.plural.number_of_apps').id, this.checkedAppLength) || '';

    AccessibilityManager.getInstance().sendTextAnnouncedForAccessibility(readerText);
  }

  private onConfirmButtonClick(): void {
    Trace.start(TRACE_DIALOG_CLOSE);
    const categoryIds = this.extractCategoryIds();
    if (this.openedBy === FolderCommonConstants.OPEN_ADD_SHEET_CREATE_FOLDER) {
      HiSysEventUtil.reportFolderCreationRecommendOk(
        this.folderItem.folderId,
        this.folderItem.typeId,
        this.checkedAppList.length,
        categoryIds.toString(),
        this.folderItem.area?.join('x')
      );
    } else if (this.openedBy === FolderCommonConstants.OPEN_ADD_SHEET_ADD_BUBBLE) {
      HiSysEventUtil.reportFolderAddAppRecommendOk(
        this.folderItem.folderId,
        this.folderItem.typeId,
        this.checkedAppList.length,
        categoryIds.toString(),
        this.folderItem.area?.join('x')
      );
    }
    if (!this.isFolderDataChange()) {
      log.showInfo('onConfirmButtonClick data not change.');
      return;
    }
    log.showInfo('onConfirmButtonClick.');

    this.folderAddViewModel.refreshFolderApps(this.checkedAppList, this.folderItem);
  }

  /**
   * Extract category Ids from checked apps using existing category map
   * @returns Array of unique category Ids
  */
  private extractCategoryIds(): (number | undefined)[] {
    const categoryMap = this.folderAddViewModel.getRecommendedCategoryMap(this.checkedAppList);
    return Array.from(categoryMap.keys());
  }

  /**
   * 文件夹数据是否更新，无更新时点确认无需更新缓存
   *
   * @returns 文件夹数据是否更新
   */
  private isFolderDataChange(): boolean {
    if (this.checkedAppList.length !== this.openFolderItems.length) {
      return true;
    }
    for (let checkedItem of this.checkedAppList) {
      let isContains: boolean = this.openFolderItems.some((item: GridLayoutItemInfo) =>
        item.keyName === checkedItem.keyName);
      if (!isContains) {
        return true;
      }
    }
    return false;
  }

  private calculateLayout(): void {
    let dialogWidth: number = 0;
    if (StyleConfig.rootContainerStyle().width === '') {
      let screenWidth: number = AppStorage.get<number>('screenWidth') ?? 0;
      dialogWidth = screenWidth - StyleConstants.DEFAULT_16 * 2;
    } else {
      dialogWidth = StyleConfig.rootContainerStyle().width as number;
    }
    let iconSize: number = LayoutViewModel.getInstance().calculateDesktop().mIconSize ?? 0;
    const columnCount: number = this.folderAddViewModel.getDialogGridColumns();
    let padding: number = StyleConfig.rootContainerStyle().padding;
    let itemPadding: number = (dialogWidth - padding * 2 - iconSize * columnCount) / ((columnCount - 1) * 2);
    this.gridPadding = padding - itemPadding;
    if (DeviceHelper.isPad() || DeviceHelper.isFold()) {
      this.buttonWidth = ((dialogWidth - FolderAddDialogConstant.BUTTON_SPACE) - StyleConstants.DEFAULT_16 * 2) / 2;
    } else {
      this.buttonWidth = (dialogWidth - FolderAddDialogConstant.BUTTON_SPACE) / 2;
    }

    this.calculateFontSize();
    this.calculateButtonAlign();
  }

  private calculateFontSize(): void {
    try {
      let context: common.ExtensionContext = this.getUIContext().getHostContext() as common.ExtensionContext;
      let fontSizeScale: number = context.config?.fontSizeScale ?? 1;

      if (fontSizeScale > FolderAddDialogConstant.MAX_FONT_SCALE) {
        this.buttonMaxFontSize = FolderAddDialogConstant.BODY_L * FolderAddDialogConstant.MAX_FONT_SCALE + 'vp';
        this.buttonMinFontSize = FolderAddDialogConstant.BUTTON_MIN_FONT_SIZE *
          FolderAddDialogConstant.MAX_FONT_SCALE + 'vp';
        this.titleFontSize = FolderAddDialogConstant.SUBTITLE_L * FolderAddDialogConstant.MAX_FONT_SCALE + 'vp';
        this.subTitleFontSize = FolderAddDialogConstant.SUBTITLE_S * FolderAddDialogConstant.MAX_FONT_SCALE + 'vp';
      } else {
        this.buttonMaxFontSize = FolderAddDialogConstant.BODY_L + 'fp';
        this.buttonMinFontSize = FolderAddDialogConstant.BUTTON_MIN_FONT_SIZE + 'fp';
        this.titleFontSize = FolderAddDialogConstant.SUBTITLE_L + 'fp';
        this.subTitleFontSize = FolderAddDialogConstant.SUBTITLE_S + 'fp';
      }
    } catch (exception) {
      log.showError('calculateLayout calculateFontSize error');
    }
  }

  // 文字宽度过长时，按钮在竖直方向布局
  private calculateButtonAlign(): void {
    let maxWidth: number = vp2px(this.buttonWidth - StyleConstants.DEFAULT_18 * 2);
    this.isVerticalAlignButton = this.isTextWidthLarger(maxWidth, $r('app.string.cancel')) ||
      this.isTextWidthLarger(maxWidth, $r('app.string.confirm_dialog'));
  }

  private isTextWidthLarger(maxWidth: number, buttonValue: Resource): boolean {
    let textWidth: number = MeasureText.measureText({
      textContent: buttonValue,
      fontSize: this.buttonMaxFontSize
    });
    return textWidth >= maxWidth;
  }

  private getItemReuseId(item: FolderAddItemInfo): string {
    if (!GridLayoutUtil.isAppInstalled(item.itemInfo)) {
      return 'DialogBubbleDownload';
    } else if (item.itemInfo.bundleName === CommonConstants.CALENDAR_BUNDLE) {
      return 'DialogBubbleCalendar';
    } else if (item.itemInfo.bundleName === CommonConstants.CLOCK_BUNDLE) {
      return 'DialogBubbleClock';
    } else if (item.itemInfo.appIndex !== 0) {
      return 'DialogBubbleIndex';
    } else if (GridLayoutUtil.isShortcutToDesktopInApp(item.itemInfo)) {
      return 'DialogBubbleShortcutToDesktop';
    } else {
      return 'DialogBubble';
    }
  }

  getAddBubbleParams(item: FolderAddItemInfo): AddDialogBubbleNodeParams {
    if (this.paramsMap.has(item.itemInfo.keyName ?? item.itemInfo.bundleName)) {
      return this.paramsMap.get(item.itemInfo.keyName ?? item.itemInfo.bundleName) as AddDialogBubbleNodeParams;
    }
    let param: AddDialogBubbleNodeParams = new AddDialogBubbleNodeParams();
    param.item = item;
    param.onGridItemClick = this.onGridItemClick.bind(this);
    param.onCheckChange = this.onCheckStateChange.bind(this);
    this.paramsMap.set(item.itemInfo.keyName ?? item.itemInfo.bundleName, param);
    return param;
  }

  aboutToAppear(): void {
    this.calculateLayout();
    this.gridItemHeight = OpenFolderStyleConfig.getInstance().getOpenFolderStyle().iconSize +
    PresetStyleConstants.DEFAULT_ICON_NAME_MARGIN_TOP +
    FolderStyleManager.getInstance().getFolderStyleConfig().mOpenFolderAppNameHeight;
    if (this.openedBy === FolderCommonConstants.OPEN_ADD_SHEET_CREATE_FOLDER) {
      this.initCreateFolderAddSheet();
    } else {
      this.initAddBubbleSheet();
    }
    localEventManager.registerEventListener(this.folderEventListener,
      [EventConstants.EVENT_EDIT_MODE_TOUCH_DOWN_ITEM, EventConstants.EVENT_CLOSE_FOLDER_ADD_DIALOG]);
    folderGesData.setAddDialogOpening(true);
    this.gridLayoutOptions = {
      regularSize: [1, 1],
      irregularIndexes: this.folderAddDataSource.getIrregularIndexes()
    };
    this.checkedAppLength = this.checkedAppList.length;
  }

  private initCreateFolderAddSheet(): void {
    this.checkedAppList = this.folderItem.layoutInfo?.flat() ?? [];
    this.title = ResourceManager.getInstance().getStringByName('sheet_sub_title_similar');
    this.openFolderItems = [...this.checkedAppList];
    this.allAppList = this.folderAddViewModel.getAllFolderAddItemInfos(this.checkedAppList, false);
    HiSysEventUtil.reportFolderCreationOpenRecommend(
      this.allAppList.length,
      this.folderItem.folderId,
      this.folderItem.typeId,
    );
    this.folderAddDataSource.refreshData(this.allAppList);
  }

  private initAddBubbleSheet(): void {
    this.title = ResourceManager.getInstance().getStringByName('sheet_title_recommended');
    this.checkedAppList = this.folderAddViewModel.getContainsItemList();
    this.openFolderItems = [...this.checkedAppList];
    this.allAppList = this.folderAddViewModel.getAllFolderAddItemInfos(this.checkedAppList, true);
    HiSysEventUtil.reportFolderCreationOpenRecommend(
      this.allAppList.length,
      this.openFolderData.folderId,
      this.openFolderData.typeId
    );
    this.folderAddDataSource.refreshData(this.allAppList);
  }

  aboutToDisappear(): void {
    if (this.userCancelled) {
      if (this.openedBy === FolderCommonConstants.OPEN_ADD_SHEET_CREATE_FOLDER) {
        HiSysEventUtil.reportFolderCreationRecommendCancel(
          this.folderItem.folderId,
          this.folderItem.typeId
        );
      } else if (this.openedBy === FolderCommonConstants.OPEN_ADD_SHEET_ADD_BUBBLE) {
        HiSysEventUtil.reportFolderAddAppRecommendCancel(
          this.folderItem.folderId,
          this.folderItem.typeId
        );
      }
    }
    Trace.end(TRACE_DIALOG_CLOSE);
    localEventManager.unregisterEventListener(this.folderEventListener);
    folderGesData.setAddDialogOpening(false);
    this.paramsMap.clear();
  }

  @Builder
  DialogTitleBuilder(title: Resource | string, paddingTop: string, paddingBottom: string) {
    Text(title)
      .draggable(false)
      .fontWeight(FontWeight.Bold)
      .fontColor($r('sys.color.font_primary'))
      .fontFamily(FolderAddDialogConstant.FONT_FAMILY_ohos)
      .width('100%')
      .id(DIALOG_TITLE_ID)
      .padding({
        top: paddingTop,
        bottom: paddingBottom,
        left: this.bigStyle.mBindSheetTitlePadding,
        right: this.bigStyle.mBindSheetTitlePadding
      })
      .margin({ bottom: paddingBottom })
      .fontSize(this.titleFontSize)
      .textAlign(TextAlign.Start)
      .lineBreakStrategy(LineBreakStrategy.BALANCED)
  }

  @Builder
  DialogSubTitleBuilder(title: string, paddingTop: string) {
    Text(title)
      .draggable(false)
      .fontColor($r('sys.color.font_secondary'))
      .fontWeight(FontWeight.Regular)
      .fontFamily(FolderAddDialogConstant.FONT_FAMILY_ohos)
      .width('100%')
      .id(DIALOG_TITLE_ID)
      .maxLines(FolderAddDialogConstant.DIALOG_TITLE_MAX_LINES)
      .fontSize(this.subTitleFontSize)
      .textOverflow({ overflow: TextOverflow.Ellipsis })
      .textAlign(TextAlign.Start)
      .padding({ top: paddingTop, bottom: FolderAddDialogConstant.GRID_SUBTITLE_PADDING_BOTTOM,
        left: this.bigStyle.mBindSheetTitlePadding, right: this.bigStyle.mBindSheetTitlePadding })
  }

  @Builder
  DialogGridBuilder() {
    Grid(undefined, this.gridLayoutOptions) {
      LazyForEach(this.folderAddDataSource, (item: FolderAddItemInfo) => {
        if (item.type === FolderAddItemInfoType.Title) {
          GridItem() {
            if (item.catName === folderAddSheetOther) {
              this.DialogTitleBuilder($r('app.string.folder_add_sheet_other'),
                FolderAddDialogConstant.OTHER_TITLE_PADDING_TOP,
                FolderAddDialogConstant.GRID_TITLE_PADDING_BOTTOM)
            } else if (item.catName === sheetTitleRecommended) {
              this.DialogTitleBuilder(this.title, FolderAddDialogConstant.TITLE_PADDING_TOP,
                FolderAddDialogConstant.GRID_ITEM_DEFAULT_PADDING_BOTTOM)
            } else {
              this.DialogSubTitleBuilder(this.folderAddViewModel.getRealFolderName(`#${item.catName}`),
                item.subTitlePaddingTop)
            }
          }
        }
        if (item.type === FolderAddItemInfoType.GridItem) {
          this.DialogGridItemBuilder(item)
        }
      }, (item: FolderAddItemInfo) => item.itemInfo.keyName)
    }
    .columnsTemplate(this.gridColumnTemplate)
    .padding({ left: this.bigStyle.mBindSheetGridPadding, right: this.bigStyle.mBindSheetGridPadding,
      bottom: FolderAddDialogConstant.GRID_MARGIN_BOTTOM })
    .height(0)
    .layoutWeight(1)
    .cachedCount(this.gridCachedCount)
    .onScrollFrameBegin((offset: number, scrollState: ScrollState) => {
      if (scrollState === ScrollState.Fling) {
        return {offsetRemain: offset * SCROLL_SPEED_SCALING}
      }
      return {offsetRemain: offset}
    })
    .onScrollStart(()=>{
      this.gridCachedCount = SCROLL_START_CACHED_VALUE;
    })
    .onScrollStop(()=>{
      this.gridCachedCount = SCROLL_STOP_CACHED_VALUE;
    })
    .edgeEffect(EdgeEffect.Spring)
  }

  @Builder
  DialogGridItemBuilder(item: FolderAddItemInfo) {
    GridItem() {
      AddDialogBubble({
        params: this.getAddBubbleParams(item),
        folderName: this.folderName,
      })
        .reuseId(this.getItemReuseId(item))
    }
    .margin({ top: FolderAddDialogConstant.GRID_ITEM_PADDING_TOP,
      bottom: FolderAddDialogConstant.GRID_ITEM_PADDING_BOTTOM })
    .width(this.bubbleParams.appItemWidth)
    .height(this.gridItemHeight)
  }

  @Builder
  LeftButtonBuilder(textResource: Resource) {
    Button(textResource, { type: ButtonType.Capsule, stateEffect: true })
      .labelStyle({
        maxLines: 1,
        maxFontSize: this.buttonMaxFontSize,
        minFontSize: this.buttonMinFontSize,
        heightAdaptivePolicy: TextHeightAdaptivePolicy.MIN_FONT_SIZE_FIRST
      })
      .fontFamily(FolderAddDialogConstant.FONT_FAMILY_ohos)
      .fontColor($r('sys.color.font_emphasize'))
      .fontWeight(FontWeight.Medium)
      .backgroundColor($r('sys.color.comp_background_tertiary'))
      .width(this.isVerticalAlignButton ? '100%' : this.buttonWidth)
      .borderRadius(StyleConstants.PC_DIALOG_BUTTON_RADIUS)
      .padding({
        left: StyleConstants.DEFAULT_18,
        right: StyleConstants.DEFAULT_18,
        top: FolderAddDialogConstant.DEFAULT_BUTTON_PADDING,
        bottom: FolderAddDialogConstant.DEFAULT_BUTTON_PADDING
      })
      .onClick(() => {
        this.userCancelled = true;
        this.onIsShowChange(!this.isShow);
      })
  }

  @Builder
  RightButtonBuilder(textResource: Resource, onClickCallback?: Function) {
    Button(textResource, { type: ButtonType.Capsule, stateEffect: true })
      .labelStyle({
        maxLines: 1,
        maxFontSize: this.buttonMaxFontSize,
        minFontSize: this.buttonMinFontSize,
        heightAdaptivePolicy: TextHeightAdaptivePolicy.MIN_FONT_SIZE_FIRST
      })
      .fontFamily(FolderAddDialogConstant.FONT_FAMILY_ohos)
      .fontColor($r('sys.color.font_on_primary'))
      .fontWeight(FontWeight.Medium)
      .backgroundColor($r('sys.color.comp_background_emphasize'))
      .width(this.isVerticalAlignButton ? '100%' : this.buttonWidth)
      .borderRadius(StyleConstants.PC_DIALOG_BUTTON_RADIUS)
      .padding({
        left: StyleConstants.DEFAULT_18,
        right: StyleConstants.DEFAULT_18,
        top: FolderAddDialogConstant.DEFAULT_BUTTON_PADDING,
        bottom: FolderAddDialogConstant.DEFAULT_BUTTON_PADDING
      })
      .onClick(() => {
        this.userCancelled = false;
        this.onIsShowChange(!this.isShow);
        if (onClickCallback) {
          onClickCallback();
        }
      })
  }

  build() {
    Column() {
      Column() {
        this.DialogGridBuilder();
      }
      .layoutWeight(1)
      .onAppear(() => {
        if (this.isAccessibilityMode) {
          AccessibilityManager.getInstance().requestFocusAccessibility(DIALOG_TITLE_ID);
        }
      })
      if (this.isVerticalAlignButton) {
        Column({ space: FolderAddDialogConstant.BUTTON_SPACE }) {
          this.LeftButtonBuilder($r('app.string.cancel'))

          this.RightButtonBuilder($r('app.string.confirm_dialog'), () => {
            this.onConfirmButtonClick();
          })
        }
        .margin({
          right: FolderAddDialogConstant.BUTTON_MARGIN,
          top: FolderAddDialogConstant.BUTTON_MARGIN,
          left: FolderAddDialogConstant.BUTTON_MARGIN,
          bottom: FolderAddDialogConstant.BUTTON_MARGIN
        })
      } else {
        Row({ space: FolderAddDialogConstant.BUTTON_SPACE }) {
          this.LeftButtonBuilder($r('app.string.cancel'))

          this.RightButtonBuilder($r('app.string.confirm_dialog'), () => {
            this.onConfirmButtonClick();
          })
        }
        .margin({
          right: FolderAddDialogConstant.BUTTON_MARGIN,
          top: FolderAddDialogConstant.BUTTON_MARGIN,
          left: FolderAddDialogConstant.BUTTON_MARGIN,
          bottom: FolderAddDialogConstant.BUTTON_MARGIN
        })
      }
    }
    .margin({ bottom: DeviceHelper.isPad() || desktopUtil.isFoldExpandStatus() ?
    FolderAddDialogConstant.DEFAULT_ZERO_VP : FolderAddDialogConstant.AI_BAR_HEIGHT })
    .onKeyEvent((event?: KeyEvent) => {
      if (event?.keyCode === KeyCode.KEYCODE_BACK) {
        log.showInfo('keycode back hide dialog');
        this.onIsShowChange(false);
      }
    })
  }
}

/**
 * LazyForEach数据源
 */
class FolderAddDataSource implements IDataSource {
  private dataSource: FolderAddItemInfo[] = [];
  private dataChangeListeners: DataChangeListener[] = [];

  constructor(dataList: FolderAddItemInfo[]) {
    this.dataSource = dataList;
  }

  public totalCount(): number {
    return this.dataSource === null ? 0 : this.dataSource.length;
  }

  public getData(index: number): FolderAddItemInfo {
    let info: FolderAddItemInfo = index >= 0 && index < this.totalCount() ? this.dataSource[index] :
      new FolderAddItemInfo();
    return info;
  }

  public refreshData(dataList: FolderAddItemInfo[]) {
    this.dataSource = dataList;
    this.notifyDataReload();
  }

  public getIrregularIndexes(): number[] {
    const irregularIndexes : number[] = [];
    this.dataSource.forEach((item, index) => {
      if (item.type === FolderAddItemInfoType.Title) {
        irregularIndexes.push(index);
      }
    });
    return irregularIndexes;
  }

  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.dataChangeListeners.indexOf(listener) >= 0) {
      return;
    }
    this.dataChangeListeners.push(listener);
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos: number = this.dataChangeListeners.indexOf(listener);
    if (pos >= 0) {
      this.dataChangeListeners.splice(pos, 1);
    }
  }

  notifyDataReload(): void {
    this.dataChangeListeners.forEach(listener => {
      listener.onDataReloaded();
    })
  }
}

interface ReceiveEventParam {
  folderStatusChang: boolean
}