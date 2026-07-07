/**
 * Copyright (c) 2023-2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { LogDomain, LogHelper, StartType, SingleContext, CheckEmptyUtils } from '@ohos/basicutils';
import { SCBTransitionController, SCBTransitionManager, } from '@ohos/windowscene';
import { GlobalContext, WallpaperColorManager, DeviceHelper, TextColor } from '@ohos/frameworkwrapper';
import { DragExtraInfo, DragDataType, windowManager } from '@ohos/componentdrag';
import { dragSnapshotHelper, SnapshotType } from '@ohos/componenthelper';
import { DropAnimationScene, DropAnimationCancelReason, } from '@ohos/componentanimator';
import {
  PresetStyleConstants,
  StyleConstants,
  FileType,
  CommonConstants,
  LaunchLayoutCacheManager,
  GridLayoutUtil,
  layoutConfigManager,
  keyEventManager,
  vibratorMgr,
  BaseViewModel,
  DesktopFileInfo,
  PageDesktopModel,
  PageDesktopViewModelForPC,
  AppGridStyleConfig
} from '@ohos/launchercommon';
import { dropAnimationManager } from '@ohos/componentanimator/Index';
import { DragControllerParams } from '@ohos/componenthelper/Index';
import {
  dragTriggerUtil,
  nameAppearAnimate,
  PageDesktopViewModelProxy,
  IPageDesktopViewModel
} from '@ohos/launchercommon/Index';
import { ExtraData, SelectStatus, FileEventStatus } from '../common/FileFolderConstants';
import { RenameUtil } from '../utils/RenameUtil';
import { FileIconUtils } from '../utils/FileIconUtils';
import FileFolderManagerFactory from '../manager/FileFolderManagerFactory';
import fileInfoUpdateManager from '../FileInfoUpdateManager';
import { GridLayoutItemInfo } from '@ohos/launchercommon';
import { FileFolderMenu } from './FileFolderMenu';
import type ctx from '@ohos.app.ability.common';
import image from '@ohos.multimedia.image';
import measure from '@ohos.measure';
import { RefreshUriListener } from '../manager/FileFolderManager';
import { KeyCode } from '@ohos.multimodalInput.keyCode';
import { LengthMetrics } from '@kit.ArkUI';
import deviceInfo from '@ohos.deviceInfo';
import { FileFolderStyleConstants } from '../common/FileFolderStyleConstants';
import { FileFolderViewModel } from '../viewmodel/FileFolderViewModel';
import { PopupViewModel } from '../viewmodel/PopupViewModel';
import context from '@ohos.app.ability.common';

const NUM_HALF = 2;
const TAG = 'FileFolderComponent';
const MAX_INPUT_LEN = 255;
const HOVER_MENU_MAX_WIDTH = 604;
const CLICK_FILE_NAME_INTERVAL = 300;
const WIDTH_PERCENT_OF_DLP_IMAGE = 0.34;
const SVG_ANTIALIASING_OF_DLP_IMAGE = 0.35;
const LINE_BREAKABLE_FONT_SIZE = 1;
const BIND_POPUP_TARGET_SPACE = 8;
const HOVER_MENU_FONT_SIZE = 14;
const HOVER_MENU_VERTICAL_PADDING = 8;
const HOVER_MENU_LINE_HEIGHT = 19;
const HOVER_MENU_BORDER_RADIUS = 16;
const POPUP_TIP_SHOW_DELAY = 1000;
const POPUP_WIDTH_FROM_THE_SCREEN = 8;
const LONG_PRESS_DURATION = 500;
const NO_KEYBOARD_STATUS = -1;
const HOVER_TIP_TEXT_COLUMN_SPACE = 2;
let inputTextDelayTimer: number | null = null;
const FILE_MANGER_BUNDLE_NAME: string = 'com.ohos.filemanager';
const CLICK_DELAY: number = 300;
const POPUP_HORIZONTAL_RESERVED_DISTANCE = 7;
/**
 * 图片容器的高度
 */
const IMAGE_HEIGHT = 99;

/**
 * 图片容器的顶部外边距度
 */
const IMAGE_TOP_HEIGHT_MARGIN = 4;

/**
 * 图片容器的底部外边距度
 */
const IMAGE_BOTTOM_MARGIN = 1;
const RESET_LOCATED_GRIDITEM_ZINDEX_EVENT_SUFFIX = 'RESET_LOCATED_GRIDITEM_ZINDEX_EVENT';


@Component
export default struct FileFolderComponent {
  @Prop singleContext?: SingleContext;
  @State iconRadius: number = CommonConstants.INVALID_VALUE;
  @Link fileFolderItem: GridLayoutItemInfo;
  private itemKey: string = '';
  private log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG + this.fileFolderItem.ino);
  // response for F2 action
  @StorageLink('renameFile') @Watch('renameAction') renameFile: string = '';
  @StorageLink('newCreateFolder') newCreateFolder: string = '';
  @StorageLink('isExtensionSuffix') @Watch('updateShowName') isExtensionSuffix: boolean = true;
  @State inputText: string = '';
  @State showName: string = '';
  @State desktopMaxLines: number = PresetStyleConstants.DEFAULT_APP_NAME_LINES;
  @Link iconScale: number;
  @Prop @Watch('onItemSelectStateChange') isSelect: boolean = false;
  @Prop @Watch('onDesktopFocusChange') isGainFocus: boolean = false;
  @Consume selectStatus: number;
  @Consume @Watch('onFocusedChange') isFocused: boolean;
  controller: TextAreaController = new TextAreaController();
  private fileFolderManager = FileFolderManagerFactory.getFileFolderManager();
  mIconNameMarginTop: number = PresetStyleConstants.DEFAULT_ICON_NAME_MARGIN_TOP;
  nameSize: number = 0;
  nameWidth: number = 0;
  nameHeight: number = 0;
  @State iconSize: number = 0;
  private containerViewModel?: BaseViewModel;
  getContainerViewModel?: () => BaseViewModel;
  private mDesktopContext = GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext;
  private inputFocused: boolean = false;
  private isNameHover: boolean = false;
  @StorageProp('wallpaperChangeFlag') @Watch('wallpaperChange') wallpaperValue: boolean = true;
  @State animateScale: number = 1.0;
  @Prop nameFontColor: string | undefined = WallpaperColorManager?.getInstance()?.mTextColor?.mTextColor;
  @State nameOpacity: number = 1;
  @State fileFolderImage: PixelMap | string | Resource | null = '';
  @State cachedImagePath: PixelMap | string | Resource | null = '';
  @State useCachedImage: boolean = false;
  onItemSelect?: Function;
  twiceClickFlag: boolean = false;
  handlerDragStart?: Function;
  handlerDragEnd?: Function;
  componentId: string = '';
  isMultiSelect: boolean = false;
  private isDragStart: boolean = false;
  @Link isInDrag: boolean;
  private mouseInInputArea: boolean = false;
  @State isDlp: boolean = false;
  @State isShortCut: boolean = false;
  @State itemVisible: boolean = true;
  isNamePressed: boolean = false;
  @Link compressing: boolean;
  private onTouchMove: boolean = false;
  private rectangleSelect: boolean = false;
  private transitionController?: SCBTransitionController;
  private deviseSN: string = '';
  @StorageProp('desktopIconChange') @Watch('onIconChange') desktopIconChange: number = 0;
  @Link isDragPaste: boolean;
  @State hoverTipWindowWidth: number = 0;
  @State hoverTipWindowHeight: number = 0;
  private hoverTipDisPlayPosition: Position = { x: 0, y: 0 };
  private hoverTipPosition: Position = { x: 0, y: 0 };
  private displayWidth = windowManager.getWindowWidth() ?? 0;
  private displayHeight = windowManager.getWindowHeight() ?? 0;
  @State iconHoverTips: PopupViewModel = new PopupViewModel(this.fileFolderItem);
  @State nameHoverTips: PopupViewModel = new PopupViewModel(this.fileFolderItem);
  private isIconHover: boolean = false;
  private hoverEventY: number = 0;
  private currentIsTouchDown: boolean = false;
  @State menuOffset: Position = {x: 0, y: 0};
  private menuPlacement: Placement | undefined = undefined;
  @State isShowPlayCircle: boolean = false;
  private isVideoThumbnailType: boolean = false;
  private iconLoadCompleted: boolean = false;
  private isClicked: boolean = false;
  // 缩略图长宽比
  private thumbnailRatio: number = 0;
  @State imageThumbnailHeight: number = 0;
  @State imageThumbnailWidth: number = 0;
  // 是否展示缩略图特征，包括视频背板，图片黑框等
  @State showThumbnailCharacter: boolean = false;
  @State isMenuShow: boolean = false;
  isShowShadow: boolean = true;
  private containerBelong: GridLayoutItemInfo | undefined = undefined;
  private marginValue: Margin = {
    left: StyleConstants.DEFAULT_3,
    right: StyleConstants.DEFAULT_3,
    top: StyleConstants.DEFAULT_0,
  };
  private paddingValue : Padding = {
    bottom: StyleConstants.DEFAULT_2,
    top: StyleConstants.DEFAULT_2,
    left: StyleConstants.DEFAULT_2,
    right: StyleConstants.DEFAULT_2
  };
  @Prop @Watch('changeMaxLines') maxLines: number = 0;
  private fileFolderViewModel: FileFolderViewModel = new FileFolderViewModel(this.fileFolderItem);
  private iconChangeCallback: Callback<string[]> = (utdTypes) => {
    const utdType = this.fileFolderManager.getUtdTypeByFileName(this.fileFolderItem.fileFolderName ?? '');
    this.log.showInfo(`iconChangeCallback, utdType:${utdType}, ino:${this.fileFolderItem.ino}`);
    if (!utdTypes.some(changeUtdType => changeUtdType === utdType)) {
      return;
    }
    this.updateIcon();
  }
  @State textAreaHeight: number = 0;
  @State textAreaBarState: BarState = BarState.Off;
  @State textAreaMaxHeight: number = 0;
  private maxWidth: number = 0;

  // 是否开启节点组缓存
  @State enableRenderGroup: boolean = true;
  private enableRenderGroupChange: Function = (enableRenderGroup: boolean) => {
    this.enableRenderGroup = enableRenderGroup;
  }

  /**
   * 刷新文件图标
   */
  public onFileInfoUpdated(item?: GridLayoutItemInfo): void {
    this.log.showInfo(`update mFileInfoListener ino: ${this.fileFolderItem?.ino}, appIconId: ${item?.appIconId}`);
    this.refreshFileFolderItem(item);
    this.updateFileMark();
    this.printFileInfo(this.fileFolderItem, 'onFileInfoUpdated');
    if (this.isShortCut && this.iconLoadCompleted) {
      // 文件快捷方式图标变更时，规格要求手动点击再刷新
      this.log.showWarn('not refresh shortcut icon unless menu touch');
      return;
    }
    this.updateIcon(item?.appIconId);
    if (!this.iconLoadCompleted) {
      this.iconLoadCompleted = true;
    }
  }

  updateShowName(): void {
    const name: string = this.fileFolderManager.getGuiNameByFileInfo(this.fileFolderItem.uri);
    this.showName = name;
    this.inputText = name;
  }

  private updateShortCutIcon(): void {
    if (this.isShortCut) {
      this.log.showInfo('updateShortCutIcon');
      this.updateIcon();
    }
  }

  /**
   * 主动刷新域变量fileFolderItem的值
   * @param item
   */
  private refreshFileFolderItem(item?: GridLayoutItemInfo): void {
    if (item && item?.ino === this.fileFolderItem.ino) {
      this.fileFolderItem.fileFolderName = item.fileFolderName;
      this.fileFolderItem.uri = item.uri;
      this.log.showInfo('refreshFileFolderItem');
    }
  }

  /**
   * 完成压缩,取消置灰，解除不可操作状态
   */
  public refreshComPressStatus(): void {
    this.compressing = false;
    this.log.showInfo(`refreshComPressStatus ino: ${this.fileFolderItem?.ino}, compressing: ${this.compressing}`);
  }

  private onIconChange(): void {
    this.iconSize = this.containerViewModel?.getIconSize() ?? StyleConstants.DEFAULT_APP_ICON_SIZE_WIDTH;
    this.log.showInfo(`desktopIconChange is: ${this.desktopIconChange}, iconSize: ${this.iconSize}`);
  }

  private printFileInfo(item: GridLayoutItemInfo, callerTag?: string): void {
    if (!item) {
      this.log.showWarn('printFileInfo failed,item is undefined');
      return;
    }
    this.log.showInfo('printFileInfo tag = %{public}s,  ino = %{public}s, iconId = %{public}s, ctime = %{public}s,' +
      'column = %{public}d, row = %{public}d, page = %{public}d, shortCut = %{public}s', callerTag, item.ino,
      item.appIconId, item.ctime, item.column, item.row, item.page, this.isShortCut);
  }

  onFocusedChange(): void {
    this.log.showInfo(`onFocusedChange ${this.fileFolderItem?.ino}, isFocused:${this.isFocused}`);
    if (this.isFocused) {
      focusControl.requestFocus(`DeskTop_FileName_${this.fileFolderItem.ino}`);
    }
  }

  onRefreshUri(uri: string): void {
    this.log.showInfo(`onRefreshUri ino: ${this.fileFolderItem.ino}`);
    // 超大文件刷新时，刷新cachedImage
    this.useCachedImage = this.fileFolderItem?.appIconId === 0;
    // mtime刷新后重新加载
    this.cachedImagePath = this.fileFolderViewModel.getThumbnailPathWithMtime();
    this.isVideoThumbnailType = this.fileFolderManager.isVideoThumbnailType(this.fileFolderItem.uri);

    if (!this.useCachedImage) {
      this.fileFolderImage = uri;
    }
    this.log.showInfo(`onRefreshUri useCachedImage is: ${this.useCachedImage}`);
  }

  aboutToAppear(): void {
    if (this.getContainerViewModel) {
      this.containerViewModel = this.getContainerViewModel();
      this.log.showInfo(`get container view model ${this.containerViewModel}`);
    }
    this.itemKey = this.containerViewModel?.getItemKeyByType(this.fileFolderItem) ?? '';
    this.log.showInfo(`aboutToAppear: ${this.fileFolderItem?.ino}`);
    if (this.iconRadius === CommonConstants.INVALID_VALUE) {
      this.iconRadius = CommonConstants.DEFAULT_ICON_RADIUS * this.iconSize /
        (layoutConfigManager.getStyleConfig(CommonConstants.APP_GRID_STYLE_CONFIG,
          CommonConstants.PAGE_DESKTOP_FEATURE_NAME) as AppGridStyleConfig)?.mIconSize ?? this.iconSize;
    }
    this.updateFileMark();
    this.updateIcon();
    if (this.fileFolderManager.isFilesFirstLoaded()) {
      this.log.showInfo('item appear after first load');
      this.iconLoadCompleted = true;
    }
    if (!this.fileFolderItem.fileFolderName) {
      this.log.showError('aboutToAppear fileFolderName is null');
    }
    const name: string = this.fileFolderManager.getGuiNameByFileInfo(this.fileFolderItem.uri);
    this.showName = name;
    this.inputText = name;
    if (this.fileFolderItem.isSelect) {
      this.containerViewModel?.onSelectItemChange([this.itemKey], true, true);
    }
    if (this.newCreateFolder === this.fileFolderItem.uri) {
      if (PageDesktopViewModelProxy.getInstance().getDesktopFocusState()) {
        this.selectStatus = SelectStatus.RENAME;
      }
      this.renameFile = this.fileFolderItem.uri as string;
      AppStorage.setOrCreate('newCreateFolder', '');
    }
    this.containerBelong = LaunchLayoutCacheManager.getInstance().selectContainerGridLayoutItem(this.fileFolderItem);
    if (this.fileFolderItem.ino) {
      // register listener
      fileInfoUpdateManager.registerListener(this.fileFolderItem.ino, this);
    }
    this.componentId = `DeskTop_FileName_${this.fileFolderItem.ino}`;
    this.fileFolderItem.componentId = this.componentId;
    this.initTransitionController();
    this.setCompressStatus();
    this.deviseSN = deviceInfo.serial;
    fileInfoUpdateManager.registerIconChangeListener(this.iconChangeCallback);
    this.log = LogHelper.getLogHelper(LogDomain.HOME, TAG + this.fileFolderItem.ino);
    this.mDesktopContext.eventHub.on(CommonConstants.DESKTOP_ITEM_ENABLE_RENDER_GROUP, this.enableRenderGroupChange);
  }

  public registerFileFolderEvent(): void {
    if (this.useCachedImage) {
      this.registerRefreshUri();
    }
    SCBTransitionManager.getInstance().registerTransitionController(this.transitionController);
    this.log.showInfo(`initEventHubEvent item: ${this.fileFolderItem?.ino}`);
    this.mDesktopContext.eventHub.on(`coveredFileFolder${this.fileFolderItem.ino}`, this.onEventhubCoveredItemEvent);
    this.mDesktopContext.eventHub.on(`dropFileToFolder${this.fileFolderItem.ino}`, this.dealOnDrop);
    this.mDesktopContext.eventHub.on(`filesToFolder${this.fileFolderItem.ino}`, this.filesToFolder);
    this.mDesktopContext.eventHub.on(`renameEvent${this.fileFolderItem.ino}`, this.setRenamingStatus);
    this.mDesktopContext.eventHub.on('FileFolderCompressToRenameEvent', this.fileFolderCompressToRenameCallBack);
  }

  public unRegisterFileFolderEvent(): void {
    if (this.fileFolderItem.ino !== undefined) {
      this.fileFolderManager.unregisterRefreshUri(this.fileFolderItem.ino);
    }
    if (this.transitionController) {
      this.log.showInfo(`unRegisterTransitionController: ${this.fileFolderItem?.ino}`);
      SCBTransitionManager.getInstance().unRegisterTransitionController(this.transitionController);
    }
    this.log.showInfo(`unInitEventHubEvent item:${this.fileFolderItem?.ino}`);
    this.mDesktopContext.eventHub.off(`coveredFileFolder${this.fileFolderItem.ino}`, this.onEventhubCoveredItemEvent);
    this.mDesktopContext.eventHub.off(`dropFileToFolder${this.fileFolderItem.ino}`, this.dealOnDrop);
    this.mDesktopContext.eventHub.off(`filesToFolder${this.fileFolderItem.ino}`, this.filesToFolder);
    this.mDesktopContext.eventHub.off(`renameEvent${this.fileFolderItem.ino}`, this.setRenamingStatus);
    this.mDesktopContext.eventHub.off('FileFolderCompressToRenameEvent', this.fileFolderCompressToRenameCallBack);
  }

  private onEventhubCoveredItemEvent = (isCover: boolean) => {
    this.log.showInfo(`onEventhubCoveredItemEvent item: ${this.fileFolderItem?.ino}, isCover: ${isCover}`);
    this.isSelect = isCover;
    if (isCover) {
      this.isGainFocus = true;
    }
  }

  private setCompressStatus(): void {
    const compress: string | undefined = AppStorage.get('compressUri');
    if (compress && this.fileFolderItem?.uri === compress) {
      this.compressing = true;
      this.log.showInfo(`aboutToAppear compressino: ${this.fileFolderItem?.ino}, compressing: ${this.compressing}`);
    }
  }

  private getMaxNameLines(): number {
    if (this.maxLines != 0) {
      return this.maxLines;
    }
    let fontSizeScale = this.mDesktopContext.config.fontSizeScale || 1;
    return fontSizeScale > LINE_BREAKABLE_FONT_SIZE ? 1 : 2;
  }

  private triggerDrag(event?: TouchEvent, isPressNameDrag: boolean = false): void {
    if (!event) {
      this.log.showWarn('desktop drag triggerDrag event invalid');
      return;
    }
    if (event.type === TouchType.Down) {
      dropAnimationManager.cancelDropAnimation(DropAnimationCancelReason.TOUCH_DESKTOP_ITEM);
      dragSnapshotHelper.snapshotFromId(this.fileFolderItem.ino + 'image', SnapshotType.BOTH,
        GridLayoutUtil.generateUniqueKey(this.fileFolderItem), null, undefined, undefined,
        `FileFolderComponent_triggerDrag`);
      this.isMultiSelect = this.getCurrentSelectItems().length > 1 &&
        this.getCurrentSelectItems().some(x => GridLayoutUtil.checkGridItemEqual(x, this.fileFolderItem));
      this.log.showInfo(`desktop drag this file isMultiSelect = ${this.isMultiSelect}, isPressNameDrag: ${isPressNameDrag}`);
    }
    // 单选拖拽走onDragStart
    if (!this.isMultiSelect) {
      return;
    }
    if (event.type === TouchType.Down && this.isMultiSelect) {
      this.initMultiSelectDragParams(event, isPressNameDrag);
    }
    if (event.type === TouchType.Move) {
      PageDesktopViewModelProxy.getInstance().setMultiDragStart(true, TAG);
    }
    // 松手后，需要能框选
    if (event.type === TouchType.Up) {
      PageDesktopViewModelProxy.getInstance().setMultiDragStart(false, TAG);
    }
    dragTriggerUtil.preDragTrigger(event);
  }

  getCurrentSelectItems(): GridLayoutItemInfo[] {
    return this.containerViewModel?.getCurrentSelectItemsInfo() ?? [];
  }

  getCurrentTouchItem(item: GridLayoutItemInfo): image.PixelMap | undefined {
    return this.containerViewModel?.getCurrentTouchItem(item);
  }

  getMultiSelectMap(): Map<string, image.PixelMap> {
    return this.containerViewModel?.getMultiSelectMap() as Map<string, image.PixelMap>;
  }

  private initMultiSelectDragParams(event: TouchEvent, isPressNameDrag: boolean): void {
    if (!event) {
      this.log.showWarn('desktop drag initMultiSelectDragParams event invalid');
      return;
    }
    let cached = this.getCached();
    if (!cached) {
      this.log.showError('desktop drag cannot get cache %{public}s/%{public}s', this.fileFolderItem.typeId, this.fileFolderItem.ino);
      return;
    }
    let dragInfoList: DragItemInfo[] = [];
    let cachedPos: number[] = [];
    if (DeviceHelper.isSuperFoldMachine()) {
      const isPortrait: boolean = AppStorage.get<boolean>('isPortrait') as boolean;
      const page: number = cached.page ?? 0;
      cachedPos = GridLayoutUtil.getIconCenterPosition(cached.row, cached.column, [1, 1], page, isPortrait);
    } else {
      cachedPos = GridLayoutUtil.getIconCenterPosition(cached.row, cached.column);
    }
    let selectItemInfoList: GridLayoutItemInfo[] = this.getCurrentSelectItems();
    let isCurrentDragSnapInMap = this.containerViewModel?.isCurrentItemInMultiMap(this.itemKey);
    let containApp: boolean = this.containerViewModel?.selectItemContainApp() as boolean;
    this.log.showInfo(`desktop drag currentDragFileSnapInMap: ${isCurrentDragSnapInMap}`);
    if (isCurrentDragSnapInMap) {
      let snapshot = this.getCurrentTouchItem(this.fileFolderItem);
      let dragItemInfo: DragItemInfo = {
        pixelMap: snapshot,
        extraInfo: new DragExtraInfo(containApp ? DragDataType.APP : DragDataType.PC_FILE)
          .setRadius(CommonConstants.DEFAULT_ICON_RADIUS).setDeviceSn(this.deviseSN)
          .setAllowDistributed(containApp ? false : true).toString()
      }
      dragInfoList.push(dragItemInfo);
    }
    this.setDragInfoList(dragInfoList, containApp);
    let dragControllerParams: DragControllerParams = {
      key: isCurrentDragSnapInMap ? [] : [GridLayoutUtil.generateUniqueKey(this.fileFolderItem)],
      dragInfo: {
        pointerId: 0,
        data: this.fileFolderManager.getDragEventData(selectItemInfoList),
        touchPoint: {
          x: event.touches[0].windowX - cachedPos[0] + this.iconSize / 2,
          y: event.touches[0].windowY - cachedPos[1] + this.iconSize / 2,
        },
        previewOptions: { numberBadge: selectItemInfoList.length }
      },
      dragItemInfo: dragInfoList,
      dragStartCallback: ((event: DragEvent) => {
        this.isDragStart = true;
        this.handlerDragStart?.(event);
      }),
      dragEndCallback: ((event: DragEvent) => {
        this.isDragStart = false;
        this.handlerDragEnd?.(event);
      })
    };
    if (isPressNameDrag && dragControllerParams?.dragInfo?.touchPoint) {
      dragControllerParams.dragInfo.touchPoint.y = this.iconSize / 2;
    }
    if (this.containerBelong && dragControllerParams?.dragInfo?.touchPoint) {
      dragControllerParams.dragInfo.touchPoint.x = this.iconSize / 2;
      dragControllerParams.dragInfo.touchPoint.y = this.iconSize / 2;
    }
    dragTriggerUtil.initDragParams(dragControllerParams);
  }

  private getCached(): GridLayoutItemInfo | undefined {
    if (this.containerBelong) {
      let containerSubItems = this.containerBelong.layoutInfo?.flat() ?? [];
      return containerSubItems.find(x => GridLayoutUtil.checkGridItemEqual(x, this.fileFolderItem));
    }
    let cached: GridLayoutItemInfo | undefined =
      LaunchLayoutCacheManager.getInstance().selectGridLayoutItemByItem(this.fileFolderItem);
    return cached;
  }

  private setDragInfoList(dragInfoList: DragItemInfo[], containApp: boolean): void {
    try {
      Array.from(this.getMultiSelectMap().values()).filter(value => value !==
      this.getCurrentTouchItem(this.fileFolderItem)).forEach((image) => {
        let dragItemInfo: DragItemInfo = {
          pixelMap: image,
          extraInfo: new DragExtraInfo(DragDataType.PC_FILE)
            .setRadius(CommonConstants.DEFAULT_ICON_RADIUS).setDeviceSn(this.deviseSN)
            .setAllowDistributed(containApp ? false : true).toString()
        }
        dragInfoList.push(dragItemInfo);
      })
      this.log.showInfo(`desktop drag multiSelectMap.length: ${dragInfoList.length}`);
    } catch (err) {
      this.log.showError(`desktop drag setDragInfoList error, code: ${err?.code}, message: ${err?.message}`);
    }
  }

  aboutToDisappear(): void {
    this.log.showInfo(`aboutToDisappear ino: ${this.fileFolderItem?.ino}`);
    this.fileFolderManager.setMenuShowStatus(false);
    if (this.fileFolderItem.ino) {
      fileInfoUpdateManager.unRegisterListener(this.fileFolderItem.ino, this);
    }
    AppStorage.setOrCreate('newCreateFolder', '');
    fileInfoUpdateManager.unregisterIconChangeListener(this.iconChangeCallback);
    LogHelper.deleteLogHelper(this.log);
    this.mDesktopContext.eventHub.off(CommonConstants.DESKTOP_ITEM_ENABLE_RENDER_GROUP, this.enableRenderGroupChange);
  }

  renameAction(): void {
    if (this.renameFile === this.fileFolderItem.uri) {
      this.log.showInfo('renameAction file name change current focus: ' + this.fileFolderItem?.ino);
      if (PageDesktopViewModelProxy.getInstance().getDesktopFocusState()) {
        this.selectStatus = SelectStatus.RENAME;
      }
      this.requestFocus(this.fileFolderItem.ino);
      // 解决继续新建时之前未清空选中态元素重新获焦问题
      this.containerViewModel?.initSelectStatus();
      this.containerViewModel?.selectItemClear();
      PageDesktopViewModelProxy.getInstance().onSelectItemChange([this.itemKey], true)
    }
  }

  onImageError(error: ImageError): void {
    this.log.showInfo(`image load error: ino: ${this.fileFolderItem.ino}`);
    if (this.fileFolderItem.appIconId !== 0) {
      return;
    }
    this.fileFolderImage = this.getDefaultImage();
    if (this.fileFolderItem.ino === undefined) {
      return;
    }
    this.registerRefreshUri();
  }

  registerRefreshUri(): void {
    if (!this.fileFolderItem.ino) {
      this.log.showError('registerRefreshUri ino invalid');
      return;
    }
    let listener: RefreshUriListener = {
      onRefreshUri: (uri: string) => {
        this.onRefreshUri(uri);
      }
    };
    this.fileFolderManager.registerRefreshUri(this.fileFolderItem.ino, listener);
  }

  onIconMouseEvent(event: MouseEvent): void {
    if (!event || this.compressing) {
      return;
    }
    if (event.button === MouseButton.Left && event.action === MouseAction.Press) {
      // 防止框选停留到选中的文件图标上松手时触发选中
      this.rectangleSelect = true;
    }
    if (event.button === MouseButton.Left && event.action === MouseAction.Move && this.rectangleSelect) {
      // 拖拽松手时，原图标不能响应Release事件，导致该属性未能复位
      this.rectangleSelect = false;
    }
    if (event.button === MouseButton.Left && event.action === MouseAction.Release && this.rectangleSelect &&
      (!AppStorage.get<boolean>('isShiftKeyDown') && !AppStorage.get<boolean>('isCtrlKeyDown'))) {
      let isMoreSelectItems =
        this.containerViewModel?.getLastSelectItems()?.length as number > 1;
      // 存在多个选中文件松手时只选中当前文件
      if (this.isSelect && !this.isDragStart && isMoreSelectItems) {
        this.log.showInfo(`release file icon and select status change`);
        this.onItemSelect?.(this.fileFolderItem);
      }
      this.rectangleSelect = false;
    }
    this.doRightClick(event);
  }

  onNameMouseEvent(event?: MouseEvent): void {
    if (!event) {
      return;
    }
    if (event.button === MouseButton.Left && event.action === MouseAction.Press) {
      this.isNamePressed = true;
    }
    if (event.button === MouseButton.Left && event.action === MouseAction.Release && this.isNamePressed) {
      this.log.showInfo(`fileNameOnTouchMove: ${this.onTouchMove}`);
      if (!this.onTouchMove) {
        this.doPressEvent();
      }
      this.onTouchMove = false;
      this.isNamePressed = false;
    }
    this.doRightClick(event);
  }

  private doRightClick(event: MouseEvent): void {
    // 右键单击桌面元素，若所选中列表中没有自己，则取消其他元素选中，选自己，否则不反应
    if (event.button === MouseButton.Right && event.action === MouseAction.Press) {
      if (!this.isInSelect()) {
        this.onItemSelect?.(this.fileFolderItem);
        this.selectStatus = SelectStatus.SELECT;
      }
    }
  }

  private isInSelect() {
    let isItemsExist =
      this.containerViewModel?.getCurrentSelectItems().indexOf(this.itemKey) !== CommonConstants.INVALID_VALUE;
    this.log.showInfo(`isItemsExist: ${isItemsExist}`);
    return isItemsExist;
  }

  private doPressEvent(): void {
    if (!AppStorage.get<boolean>('isShiftKeyDown') && !AppStorage.get<boolean>('isCtrlKeyDown')) {
      this.log.showInfo(`onNameMouseEvent selectStatus:${this.selectStatus}, isSelect:${this.fileFolderItem.isSelect}`);
      if (this.isSelect) {
        // multi item has been chosen
        if (this.containerViewModel && this.containerViewModel.getCurrentSelectItems()?.length > 1) {
          this.containerViewModel?.selectItemClear();
          this.containerViewModel?.onSelectItemChange([this.itemKey], true);
        } else {
          this.setRenameStatus();
        }
      } else {
        this.containerViewModel?.onSelectItemChange([this.itemKey], true);
        if (this.selectStatus === SelectStatus.UNSELECT) {
          this.selectStatus = SelectStatus.SELECT;
        } else if (this.selectStatus === SelectStatus.SELECT && this.isSelect) {
          this.selectStatus = SelectStatus.RENAME;
        } else {
          this.selectStatus = SelectStatus.UNSELECT;
        }
      }
    }
  }

  private setRenameStatus(): void {
    setTimeout(() => {
      this.log.showInfo(`setTimeoutTwiceClickFlag: ${this.twiceClickFlag}`);
      if (!this.twiceClickFlag && this.isSelect) {
        this.selectStatus = SelectStatus.RENAME;
      }
    }, CLICK_FILE_NAME_INTERVAL);
  }

  /**
   * 文件放入文件夹
   * @param status 是否显示
   */
  private filesToFolder = (status: boolean) => {
    this.log.showInfo('filesToFolder: ' + status + ' isDragPaste ' + this.isDragPaste);
    this.itemVisible = this.isDragPaste ? true : status;
  }

  /**
   * 文件夹进入重名
   * @param status 重命名状态
   */
  private setRenamingStatus = (status: number) => {
    this.log.showInfo('setRenamingStatus: ' + status);
    if (status === FileEventStatus.CANCEL) {
      this.log.showInfo('setRenamingStatus file ino: ' + this.fileFolderItem?.ino);
      this.selectStatus = SelectStatus.RENAME;
    }
  }

  /**
   * 文件压缩进入重命名回调
   * @param status 重命名状态
   */
  private fileFolderCompressToRenameCallBack = (ino: string) => {
    this.log.showDebug(`fileFolderCompressToRenameCallBack selectStatus: ${this.selectStatus}, ino: ${ino}`);
    if (ino === this.fileFolderItem.ino) {
      this.renameFile = this.fileFolderItem.uri as string;
      this.containerViewModel?.initSelectStatus();
      this.containerViewModel?.selectItemClear();
      PageDesktopViewModelProxy.getInstance().onSelectItemChange([this.itemKey], true)
      if (PageDesktopViewModelProxy.getInstance().getDesktopFocusState()) {
        this.selectStatus = SelectStatus.RENAME;
      }
    } else {
      this.selectStatus = SelectStatus.UNSELECT;
    }
  }

  private notifyDropFilesEvent(status: boolean): void {
    this.log.showInfo('notifyDropFilesEvent');
    const dragItem: GridLayoutItemInfo = AppStorage.get<GridLayoutItemInfo>('dragItemInfo') as GridLayoutItemInfo;
    if (!dragItem || dragItem.uri === CommonConstants.MOCK_URI) {
      this.log.showWarn('desktop dragItem not exist');
      return;
    }
    // 此处逻辑仅在拖入文件夹时触发
    // 如果使用getCurrentSelectItems，会导致拖入收纳夹内的文件夹时，获取收纳夹内的选中文件，而非桌面选中文件，导致桌面图标原地闪烁
    PageDesktopViewModelProxy.getInstance().getCurrentSelectItemsInfo().forEach((item) => {
      this.mDesktopContext.eventHub.emit(`filesToFolder${item.ino}`, status);
    });
  }

  private dealOnDrop = (event?: DragEvent, extraParams?: string, extraData?: string, isContainApp?: boolean) => {
    this.log.showInfo(`deal file Drop, ${this.fileFolderItem.ino}, ${this.fileFolderItem.fileType}`);
    if (!event) {
      return;
    }
    if (!this.fileFolderViewModel.isSupportDropFile()) {
      this.log.showInfo('curFileFolder is not support drop file');
      event.useCustomDropAnimation = true;
      return;
    }
    try {
      this.log.showInfo(`drop the fileFolder to folderItem_${this.fileFolderItem?.ino}`);
      if (extraData) {
        try {
          const exData: ExtraData = JSON.parse(extraData);
          this.notifyDropFilesEvent(exData.isCtrlKeyDown);
        } catch (error) {
          this.log.showInfo(`notify DropFiles error ${error?.code}, ${error?.message}`);
        }
      }
      this.fileFolderManager.dropFile(event, this.fileFolderViewModel.getTargetUri() ?? '', extraParams, extraData,
        isContainApp);
      this.isSelect = false;
    } catch (err) {
      this.log.showError(`dealOnDrop error, code: ${err?.code}, message: ${err?.message}`);
    }
  }

  private doHoverAnimation(animateScale: number): void {
    animateTo({
      duration: 150,
      curve: Curve.Sharp
    }, () => {
      this.animateScale = animateScale;
    });
  }

  private onIconHoverEvent(isHover: boolean): void {
    this.isIconHover = isHover;
    if (this.isIconHover) {
      this.showPlayCircle();
    } else {
      this.hidePlayCircle();
    }
    if (this.isIconHover && this.isCanShowTips()) {
      this.iconHoverTips.showViewWithDelay(POPUP_TIP_SHOW_DELAY, 'icon-hoverEvent');
    } else {
      this.iconHoverTips.hideView('icon-hoverEvent');
    }
    const isIconNeedHover = this.isIconHover && this.selectStatus !== SelectStatus.RENAME;
    const animateScale = isIconNeedHover ? 1.08 : 1;
    this.doHoverAnimation(animateScale);
  }

  private showPlayCircle(): void {
    this.log.showInfo(`showPlayCircle ${this.isVideoThumbnailType} ${this.isShowPlayCircle}`);
    if (!this.isVideoThumbnailType) {
      return;
    }
    this.isShowPlayCircle = true;
  }

  private hidePlayCircle(): void {
    this.log.showInfo(`hidePlayCircle ${this.isVideoThumbnailType} ${this.isShowPlayCircle}`);
    this.isShowPlayCircle = false;
  }


  private onTouchEvent(event?: TouchEvent, isNameOnTouch: boolean = false): void {
    this.iconHoverTips.hideView('icon-TouchEvent');
    this.nameHoverTips.hideView('name-TouchEvent');
    if (!event || this.compressing) {
      return;
    }
    this.fileFolderManager.setRightClickPosition(vp2px(event.touches[0]?.windowX), vp2px(event?.touches[0].windowY));
    this.updateShortCutIcon();
    // touch down选中文件
    if (this.isTouchUncheckedItem(event, isNameOnTouch)) {
      this.log.showInfo(`touch down file icon and select status change ino: ${this.fileFolderItem?.ino}`);
      this.onTouchMove = isNameOnTouch ? true : this.onTouchMove;
      this.onItemSelect?.(this.fileFolderItem);
      this.currentIsTouchDown = true;
    }

    // ctrl点选需要在touch up时反选文件
    if (this.isCtrlOrShiftTouchUp(event) && !this.currentIsTouchDown) {
      this.log.showInfo(`touch up file icon and select status change ino: ${this.fileFolderItem?.ino}`);
      this.onItemSelect?.(this.fileFolderItem);
      this.currentIsTouchDown = false;
    } else if (event.type === TouchType.Up) {
      this.currentIsTouchDown = false;
    }
  }

  private isTouchUncheckedItem(event?: TouchEvent, isNameOnTouch?: boolean): boolean {
    if (!event) {
      return false;
    }
    let currentItemIsSelect = this.containerViewModel?.getCurrentSelectItems().indexOf(this.itemKey) ===
    CommonConstants.INVALID_VALUE;
    // 文件Ctrl选中需要在Touch Down时设置选中态 因为onMouse的press事件在touch down后执行
    if (!isNameOnTouch && (AppStorage.get<boolean>('isShiftKeyDown') || AppStorage.get<boolean>('isCtrlKeyDown'))) {
      currentItemIsSelect = true;
    }
    return event.type === TouchType.Down && currentItemIsSelect && !this.isSelect;
  }

  private isCtrlOrShiftTouchUp(event?: TouchEvent): boolean {
    if (!event) {
      return false;
    }
    // 文件的反选需要在抬起时执行
    const ctrlOrShiftKey: boolean = (AppStorage.get<boolean>('isShiftKeyDown') ?? false) ||
      (AppStorage.get<boolean>('isCtrlKeyDown') ?? false);
    return this.isSelect && event.type === TouchType.Up && ctrlOrShiftKey;
  }

  private getImageOpacity(): number {
    this.log.showInfo(`desktop drag getImageOpacity isInDrag: ${this.isInDrag}, ${this.isDragPaste}`);
    return (this.isInDrag && !this.isDragPaste) ? 0 : 1
  }

  onMenuPreviewAnimate(animateScale: number): void {
    this.log.showInfo(`onMenuPreviewAnimate: ${animateScale}`);
    animateTo({
      duration: 200,
      curve: Curve.Sharp
    }, () => {
      this.animateScale = animateScale;
    });
  }

  @Builder
  AppIconBackgroundBuilder() {
    Column() {}
    .width(this.iconSize + StyleConstants.DEFAULT_8)
    .height(this.iconSize + StyleConstants.DEFAULT_8)
    .backgroundColor(this.getIconBackgroundColor())
    .alignItems(HorizontalAlign.Center)
    // 背板与名称共享渐显动画
    .opacity(this.nameOpacity)
    .justifyContent(FlexAlign.Center)
    .borderWidth((this.isSelect && !this.compressing) ? StyleConstants.DEFAULT_2 : StyleConstants.DEFAULT_0)
    .borderColor($r('sys.color.ohos_id_color_switch_bg_off'))
    .borderRadius($r('sys.float.ohos_id_corner_radius_small_button'))
  }

  @Styles
  longPressGestureStyles() {
    .parallelGesture(
      GestureGroup(GestureMode.Parallel,
        LongPressGesture({ repeat: false, duration: LONG_PRESS_DURATION })
          .onAction((event: GestureEvent) => {
            if (event?.source === SourceType.Mouse) {
              // 鼠标长按不响应震动
              this.log.showWarn('not response for mouse action');
              return;
            }
            if (DeviceHelper.isSuperFoldMachine()) {
              vibratorMgr.startVibration(CommonConstants.VIBRATION_EFFECT_MEDIUM,
                CommonConstants.VIBRATION_ATTRIBUTE_LONG_PRESS, TAG);
            }
          }),
        LongPressGesture({ repeat: false, duration: FileFolderStyleConstants.LONG_PRESS_MENU_SHOW_TIME })
          .onAction((event: GestureEvent) => {
            if (event?.source === SourceType.TouchScreen && !this.isDragStart) {
              this.isMenuShow = true;
            }
          }),
        LongPressGesture({ repeat: false, duration: 200 })
          .onAction((event: GestureEvent) => {
            this.log.showInfo('LongPressGesture LONG_PRESS_MENU_SHOW');
            this.longPressForMenu(event);
          })
      )
    )
  }

  private getRightClickMenuContext(): ContextMenuOptions {
    return {
      backgroundBlurStyle: BlurStyle.COMPONENT_REGULAR,
      onAppear: () => {
        this.iconHoverTips.hideView('icon-RightMenuOnAppear');
        this.nameHoverTips.hideView('name-RightMenuOnAppear');
        this.fileFolderManager.setMenuShowStatus(true);
      },
      onDisappear: () => {
        this.fileFolderManager.setMenuShowStatus(false);
      },
      offset: this.menuOffset
    };
  }

  private getLongPressMenuContext(): ContextMenuOptions {
    this.log.showInfo(`getLongPressMenuContext: menuPlacement ${this.menuPlacement}, offset: ${this.menuOffset.x}, ${this.menuOffset.y}`);
    return {
      backgroundBlurStyle: BlurStyle.COMPONENT_REGULAR,
      preview: MenuPreviewMode.NONE,
      onDisappear: () => {
        this.resetMenuPlacement();
        this.isMenuShow = false;
        this.onMenuPreviewAnimate(1.0);
      },
      placement: this.menuPlacement,
      offset: this.menuOffset,
      transition: TransitionEffect.asymmetric(
        TransitionEffect.opacity(0),
        TransitionEffect.IDENTITY.animation({ duration: 0 })),
      onAppear: () => {
        this.onMenuPreviewAnimate(1.1);
      },
      layoutRegionMargin: DeviceHelper.isSuperFoldMachine() ? {
        left: 0,
        right: 0,
        bottom: 0,
        top: 0
      } : undefined
    };
  }

  private updateSnapShot(): void {
    this.log.showInfo(`update SnapShot isSelect ${this.isSelect}`);
    if (this.isSelect) {
      setTimeout(() => {
        PageDesktopViewModelProxy.getInstance().setSnapShotMap(this.itemKey, true);
      }, 50);
    }
  }

  @Styles
  menuStyles() {
    .bindContextMenu(this.isMenuShow, this.MenuBuilder, this.getLongPressMenuContext())
  }

  @Styles
  imageStyle() {
    .draggable(false)
    .scale({ x: this.iconScale, y: this.iconScale })
    .width(this.iconSize)
    .height(this.iconSize)
    .borderRadius(4)
    .onTouch((event?: TouchEvent) => {
      this.onTouchEvent(event);
    })
    .onMouse((event: MouseEvent) => {
      this.onIconMouseEvent(event);
    })
    .animation({ duration: 200 })
  }

  @Builder
  CachedImageIcon() {
    MediaCachedImage(this.cachedImagePath)
      .objectFit(ImageFit.Contain)
      .alt(this.getCachedImageAlt())
      .key(this.fileFolderItem.ino + 'image')
      .imageStyle()
      .onComplete((event) => {
        this.log.showInfo('MediaCachedImage: onComplete');
        this.showThumbnailCharacter = true;
        if (this.fileFolderItem.ino) {
          this.fileFolderManager.unregisterRefreshUri(this.fileFolderItem.ino);
        }
        this.updateThumbnailSize(event?.height, event?.width);
        this.updateSnapShot();
      })
      .onError((e: ImageError) => {
        this.log.showInfo(`MediaCachedImage onError ino: ${this.fileFolderItem?.ino}, err message: ${e?.message}`);
        this.cachedImagePath = this.fileFolderViewModel.getThumbnailPath();
        this.isVideoThumbnailType = this.fileFolderManager.isVideoThumbnailType(this.fileFolderItem.uri);
        this.showThumbnailCharacter = false;
        this.registerRefreshUri();
      })
      .focusable(true)
      .backgroundColor(this.isVideoThumbnailType && this.showThumbnailCharacter ? Color.Black : null)
      .focusBox({strokeWidth: new LengthMetrics(0)})
  }

  @Builder
  CachedImageBorder() {
    Column() {
    }
    .id('CachedImageBorder')
    .enabled(false)
    .draggable(false)
    // 拖拽过程中不显示
    .opacity(this.isInDrag ? 0 : 1)
    .scale({ x: this.animateScale, y: this.animateScale })
    .border({ width: 1, color: '#4D808080' })
    .borderRadius(4)
    .width(this.imageThumbnailWidth)
    .height(this.imageThumbnailHeight)
  }

  private updateThumbnailSize(height: number | undefined, width: number | undefined): void {
    this.log.showInfo(`updateThumbnailSize: height: ${height}, width ${width}`);
    if (this.isVideoThumbnailType) {
      this.imageThumbnailWidth = this.iconSize;
      this.imageThumbnailHeight = this.iconSize;
      return;
    }
    if ((typeof height !== 'number') || (typeof width !== 'number')) {
      this.log.warn('height or width is undefined');
      this.showThumbnailCharacter = false;
      return;
    }
    if (height === 0 || width === 0) {
      this.log.warn('height or width is 0');
      this.showThumbnailCharacter = false;
      return;
    }
    this.thumbnailRatio = height / width;
    if (height < width) {
      this.imageThumbnailWidth = this.iconSize;
      this.imageThumbnailHeight = this.imageThumbnailWidth * this.thumbnailRatio;
    } else {
      this.imageThumbnailHeight = this.iconSize;
      this.imageThumbnailWidth = this.imageThumbnailHeight / this.thumbnailRatio;
    }
  }

  @Builder
  CustomImageIcon() {
    Image(this.fileFolderImage)
      .alt(this.getDefaultImage())
      .objectFit(ImageFit.Contain)
      .key(this.fileFolderItem.ino + 'image')
      .imageStyle()
      .onError((error: ImageError) => {
        this.onImageError(error);
      })
      .focusable(true)
      .interpolation(ImageInterpolation.Medium)
      .focusBox({strokeWidth: new LengthMetrics(0)})
  }

  @Styles
  iconContainerStyles() {
    .margin({ top: Math.ceil(vp2px(StyleConstants.DEFAULT_4)) + 'px' })
    .width(this.iconSize)
    .height(this.iconSize + StyleConstants.DEFAULT_4)
    .opacity(this.getImageOpacity())
  }

  @Builder
  FileFolderIcon() {
    Column() {
      // 支持缩略图的文件类型，使用缩略图方案
      if (this.useCachedImage) {
        this.CachedImageIcon();
      } else {
        this.CustomImageIcon();
      }
    }
    .onAppear(() => {
      this.onFocusedChange();
    })
    .scale({ x: this.animateScale, y: this.animateScale })
    .iconContainerStyles()
    .renderGroup(true)
    .id(`DeskTop_FileName_${this.fileFolderItem.ino}`)
    .onKeyEvent((event) => {
      if (!event || event.type !== 0) {
        return;
      }
      this.log.showInfo(`filefoldericon onKeyEvent code: ${event.keyCode}, ${event.type}`);
      // 当前arkUI规格是获焦组件会响应回车和空格按键事件，所以在click事件响应前处理
      if (this.isSelect || this.isSelectedInRegionFolder()) {
        this.handleKeyboardEvent(event);
      }
    })
    .bindContextMenu(this.MenuBuilder, ResponseType.RightClick, this.getRightClickMenuContext())
    .dragStyles()
    .draggable(this.itemVisible && !this.compressing)
    .gesture(
      GestureGroup(GestureMode.Parallel,
        // TouchScreen click
        TapGesture({ count: 1 }).onAction(this.itemClickEvent),
        // double click
        TapGesture({ count: 2 }).onAction(this.itemTwiceClickEvent)
      )
    )
    .longPressGestureStyles()
    .onMouse((event?: MouseEvent) => {
      if (!event || this.compressing) {
        return;
      }
      // 在图标上点击时记录下点击坐标用于弹出分享或详情弹窗
      if ((event.button === MouseButton.Right || event.button === MouseButton.Left) &&
        event.action === MouseAction.Press) {
        this.fileFolderManager.setRightClickPosition(vp2px(event.windowX), vp2px(event.windowY));
        this.updateShortCutIcon();
        if (this.inputFocused) {
          this.inputFileNameOnBlur();
        }
      }
      this.calcMenuOffsetY(event);
      if (event.action !== MouseAction.Move) {
        event.stopPropagation();
        return;
      }
      this.updateHoverTipsPosition(event);
      if (this.isIconHover && this.isCanShowTips()) {
        this.iconHoverTips.showViewWithDelay(POPUP_TIP_SHOW_DELAY, 'icon-mouseEvent');
      }
      event.stopPropagation();
    })
    .onHover((isHover: boolean) => {
      this.onIconHoverEvent(isHover);
    })
    .iconHoverTipsStyles()
    .onTouch((event: TouchEvent) => {
      if (this.compressing) {
        return;
      }
      this.triggerDrag(event);
      event?.stopPropagation()
    })
  }

  private isSelectedInRegionFolder(): boolean {
    if (this.containerBelong?.typeId !== CommonConstants.TYPE_REGION_FOLDER) {
      return false;
    }
    return this.containerViewModel?.isItemSelected(this.fileFolderItem) ?? false;
  }

  private handleKeyboardEvent(event: KeyEvent): void {
    const keyboardCode = event.keyCode;
    if (keyEventManager.getIsAltKeyDown()) {
      return;
    }
    switch (keyboardCode) {
      case KeyCode.KEYCODE_ENTER:
        this.onTapGestureEvent();
        break;
      case KeyCode.KEYCODE_SPACE:
        this.fileFolderManager.openFilePreview(this.fileFolderItem.uri);
        break;
      default:
        break;
    }
  }

  private updateHoverTipsPosition(event: MouseEvent): void {
    if (event.action !== MouseAction.Move) {
      return;
    }
    this.hoverTipDisPlayPosition.x = event.displayX;
    this.hoverTipDisPlayPosition.y = event.displayY;
    if (!this.isInDrag) {
      this.hoverTipPosition = { x: event.x, y: event.y - Number(event.target.area.height) };
    }
    this.hoverEventY = event.y;
  }

  /**
   * hover图标浮窗显示详细文件信息
   */
  @Styles
  iconHoverTipsStyles() {
    .bindPopup(this.iconHoverTips.isViewShow, {
      builder: this.hoverTips,
      placement: this.hoverTipOverScreen() ? Placement.TopLeft : Placement.BottomLeft,
      enableArrow: false,
      offset: this.hoverTipPositionHandle(),
      backgroundBlurStyle: BlurStyle.COMPONENT_ULTRA_THICK,
      targetSpace: BIND_POPUP_TARGET_SPACE,
      showInSubWindow: true,
      mask: false,
      transition: TransitionEffect.OPACITY,
      onStateChange: (e) => {
        if (!e.isVisible) {
          this.iconHoverTips.hideView('icon-PopupStateChange');
        }
      }
    })
  }

  /**
   * hover文件名浮窗显示详细文件信息
   */
  @Styles
  nameHoverTipsStyles() {
    .bindPopup(this.nameHoverTips.isViewShow, {
      builder: this.hoverTips,
      placement: this.hoverTipOverScreen() ? Placement.TopLeft : Placement.BottomLeft,
      enableArrow: false,
      offset: this.hoverTipPositionHandle(),
      backgroundBlurStyle: BlurStyle.COMPONENT_ULTRA_THICK,
      targetSpace: BIND_POPUP_TARGET_SPACE,
      showInSubWindow: true,
      mask: false,
      transition: TransitionEffect.OPACITY,
      onStateChange: (e) => {
        if (!e.isVisible) {
          this.nameHoverTips.hideView('name-PopupStateChange');
        }
      }
    })
  }

  @Builder
  StaticFileName() {
    Text(this.showName)
      .key(this.showName + 'text')
      .focusBox({strokeWidth: new LengthMetrics(0)})
      .fontSize(this.nameSize)
      .fontColor(this.nameFontColor)
      .textOverflow({ overflow: TextOverflow.Ellipsis })
      .wordBreak(WordBreak.BREAK_ALL)
      .textAlign(TextAlign.Center)
      .lineHeight(this.nameHeight)
      .fontWeight(FontWeight.Medium)
      .margin(this.marginValue)
      .padding(this.paddingValue)
      .clip(false)
      .backgroundColor(this.getNameBackgroundColor())
      .maxLines(this.desktopMaxLines)
      .renderGroup(this.enableRenderGroup)
      .textShadow(this.getShadow())
      .border({
        width: StyleConstants.DEFAULT_1,
        color: (this.isSelect && !this.compressing) ? $r('sys.color.ohos_id_color_switch_bg_off') :
        StyleConstants.DEFAULT_DESKTOP_BACKGROUND_COLOR,
        radius: $r('sys.float.ohos_id_corner_radius_default_xs')
      })
      .onAreaChange((o, n) => {
        this.desktopMaxLines = this.getMaxNameLines();
      })
      .bindContextMenu(this.MenuBuilder, ResponseType.RightClick, this.getRightClickMenuContext())
      .nameHoverTipsStyles()
      .onMouse((event?: MouseEvent) => {
        if (!event || this.compressing) {
          return;
        }
        this.onNameMouseEvent(event);
        // 在文件名上点击时记录下点击坐标用于弹出分享或详情弹窗
        if ((event.button === MouseButton.Right || event.button === MouseButton.Left) &&
          event.action === MouseAction.Press) {
          this.fileFolderManager.setRightClickPosition(vp2px(event.windowX), vp2px(event.windowY));
          this.updateShortCutIcon();
        }
        this.calcMenuOffsetY(event);
        if (event.action !== MouseAction.Move) {
          event.stopPropagation();
          return;
        }
        this.updateHoverTipsPosition(event);
        if (this.isNameHover && this.isCanShowTips()) {
          this.nameHoverTips.showViewWithDelay(POPUP_TIP_SHOW_DELAY, 'name-mouseEvent');
        }
        event?.stopPropagation();
      })
      .onTouch((event?: TouchEvent) => {
        this.onTouchEvent(event, true);
        this.triggerDrag(event, true);
      })
      .gesture(
        GestureGroup(GestureMode.Parallel,
          // TouchScreen click
          TapGesture({ count: 1 }).onAction(this.itemClickEvent),
          // double click
          TapGesture({ count: 2 }).onAction(this.itemTwiceClickEvent)
        )
      )
      .onAppear(() => {
        this.onFileNameTextAppear();
        this.emitResetZIndexEvent(false);
      })
      .onHover((isHover: boolean) => {
        this.isNameHover = isHover;
        if (this.isNameHover && this.isCanShowTips()) {
          this.nameHoverTips.showViewWithDelay(POPUP_TIP_SHOW_DELAY, 'name-hoverEvent');
        } else {
          this.nameHoverTips.hideView('name-hoverEvent');
        }
      })
      .onBlur(() => {
        this.log.showInfo(`onBlur selectStatus: ${this.selectStatus}`);
        this.selectStatus = SelectStatus.UNSELECT;
      })
  }

  private changeMaxLines(): void {
    this.desktopMaxLines = this.getMaxNameLines();
  }

  private resetMenuPlacement(): void {
    this.log.showInfo('resetMenuPlacement');
    this.menuPlacement = undefined;
  }

  private calcMenuOffsetY(event: MouseEvent): void {
    if (event.button === MouseButton.Right && event.action === MouseAction.Press) {
      const rightMenuViewModel = PageDesktopViewModelForPC.getInstance().getRightMenuViewModel();
      const menuInfos = this.fileFolderViewModel.getMenuInfoList(this.containerViewModel?.filterSelectFileItem());
      this.menuOffset = rightMenuViewModel?.getMenuOffset(event, menuInfos, TAG);
      this.log.showInfo(`calcMenuOffsetY: ${this.menuOffset.y}`);
    }
  }

  private longPressForMenu(event: GestureEvent): void {
    // 长按菜单处理, 获取menu方位
    const rightMenuViewModel = PageDesktopViewModelForPC.getInstance().getRightMenuViewModel();
    const menuInfos =  this.fileFolderViewModel.getMenuInfoList(this.containerViewModel?.filterSelectFileItem());
    this.menuPlacement = rightMenuViewModel.getMenuPlacement(event, menuInfos, TAG);
    this.menuOffset = rightMenuViewModel.getMenuOffset(event, menuInfos, TAG);
    this.log.showInfo('longPressForMenu: menuPlacement %{public}d, offset: [%{public}d, %{public}d]',
      this.menuPlacement, this.menuOffset.x, this.menuOffset.y);
  }

  private onFileNameTextAppear(): void {
    if (this.showName === '' && this.fileFolderItem.fileFolderName) {
      this.showName = this.fileFolderManager.getGuiNameByFileInfo(this.fileFolderItem.uri);
    }
  }

  @Builder
  InputFileName() {
    TextArea({ text: this.inputText, controller: this.controller })
      .key(this.getKey())
      .draggable(false)
      .textAlign(TextAlign.Center)
      .fontSize(this.nameSize)
      .fontColor($r('sys.color.ohos_id_color_text_primary'))
      .fontWeight(FileFolderStyleConstants.TEXTAREA_FONT_WEIGHT)
      .enterKeyType(EnterKeyType.Done)
      .onSubmit((enterKeyType: EnterKeyType, event?: SubmitEvent) => { // onSubmit仅在EnterDwon时触发
        if (this.containerBelong?.typeId === CommonConstants.TYPE_REGION_FOLDER) {
          this.onItemSelect?.(this.fileFolderItem);
        }
      })
      .onChange((value: string) => {
        this.inputFileNameOnChange(value);
      })
      .barState(this.textAreaBarState)
      .height(this.textAreaHeight)
      .textAreaStyles()
      .onKeyEvent((event: KeyEvent) => {
        if (event?.keyCode === KeyCode.KEYCODE_ESCAPE && event?.type === KeyType.Down) {
          // 取消重命名，inputText需要复原
          let realName: string | undefined = this.fileFolderItem?.fileFolderName;
          if (realName) {
            this.inputText = realName;
          }
          this.selectStatus = SelectStatus.SELECT;
        }
      })
  }

  @Styles
  private textAreaStyles() {
    .constraintSize({
      maxHeight: this.textAreaMaxHeight,
      minHeight: FileFolderStyleConstants.TEXTAREA_MIN_HEIGHT,
      maxWidth: this.maxWidth,
      minWidth: FileFolderStyleConstants.TEXTAREA_MIN_WIDTH
    })
    .padding(FileFolderStyleConstants.TEXTAREA_PADDING)
    .backgroundColor($r('sys.color.ohos_id_color_background'))
    .border({
      width: FileFolderStyleConstants.TEXTAREA_BORDER_WIDTH,
      radius: StyleConstants.DEFAULT_6,
      color: $r('sys.color.ohos_id_color_focused_bg')
    })
    .onFocus(() => {
      this.inputFileNameOnFocus();
    })
    .onBlur(() => {
      this.clearInputTextDelayTimer();
      inputTextDelayTimer = setTimeout(() => {
        if (this.inputFocused) {
          this.inputFileNameOnBlur();
        }
      }, 1);
      this.updateRectSelectState(false, 'onBlur');
    })
    .onAppear(() => {
      this.iconHoverTips.hideView('icon-TextAreaOnAppear');
      this.nameHoverTips.hideView('name-TextAreaOnAppear');
      AppStorage.setOrCreate('isDoingRename', true);
      this.showName = '';
      let res = this.requestFocus(this.fileFolderItem.ino);
      this.log.showInfo('requestFocus onAppear res: ' + res);
      this.textAreaHeight = RenameUtil.calcTextAreaHeight(this.maxWidth, this.inputText, this.nameSize,
        this.getUIContext());
      this.textAreaMaxHeight = this.fileFolderViewModel.getTextAreaMaxHeight(this.containerBelong);
      this.textAreaBarState = this.textAreaHeight > this.textAreaMaxHeight ? BarState.On : BarState.Off;
      this.emitResetZIndexEvent(true);
    })
    .onDisAppear(() => {
      AppStorage.setOrCreate('isDoingRename', false);
      this.updateRectSelectState(false, 'onDisAppear');
      this.onFocusedChange();
    })
    .onTouch((event: TouchEvent) => {
      if (event) {
        this.log.showInfo('TextArea onTouch');
        this.updateRectSelectState(true, 'onTouch');
        event.stopPropagation();
      }
    })
    .onMouse((event: MouseEvent) => {
      if (event) {
        this.log.showInfo('TextArea onMouse');
        this.updateRectSelectState(true, 'onMouse');
        event.stopPropagation();
      }
    })
  }

  private getResetZIndexEventName(gridItemInfo: GridLayoutItemInfo): string {
    return GridLayoutUtil.generateUniqueKey(gridItemInfo) + RESET_LOCATED_GRIDITEM_ZINDEX_EVENT_SUFFIX;
  }

  /**
   * 刷新文件文件夹所在宫格的Z序(桌面宫格，收纳夹宫格同时刷新)
   * @param isTopLayer
   */
  private emitResetZIndexEvent(isTopLayer: boolean): void {
    const uiContext = GlobalContext.getInstance().getObject('desktopContext') as context.UIAbilityContext;
    if (uiContext) {
      this.log.showInfo(`emitResetZIndexEvent ${this.fileFolderItem.ino} ${this.containerBelong?.folderId}`);
      uiContext.eventHub.emit(this.getResetZIndexEventName(this.fileFolderItem), isTopLayer);
      if (this.containerBelong) {
        uiContext.eventHub.emit(this.getResetZIndexEventName(this.containerBelong), isTopLayer);
      }
    }
  }

  private updateRectSelectState(state: boolean, callerTag?: string): void {
    if (this.mouseInInputArea !== state) {
      this.mouseInInputArea = state;
      this.log.showInfo(`updateRectSelectState ${this.mouseInInputArea}, callerTag: ${callerTag}`);
      AppStorage.setOrCreate('enableDesktopSelect', !this.mouseInInputArea);
    }
  }

  private inputFileNameOnChange(value: string): void {
    const oldText: string = this.inputText;
    this.inputText = value;
    let expectedValue = value;
    if (!this.isExtensionSuffix) {
      //需要加上扩展名
      const index : number = this.fileFolderItem.fileFolderName?.lastIndexOf('.') ?? -1;
      if (index !== -1) {
        expectedValue += this.fileFolderItem.fileFolderName?.substring(index);
      }
    }
    if (RenameUtil.strSizeUTF8(expectedValue) > MAX_INPUT_LEN) {
      this.inputText = oldText;
    }
    this.textAreaHeight = RenameUtil.calcTextAreaHeight(this.maxWidth, this.inputText, this.nameSize,
      this.getUIContext());
    this.textAreaMaxHeight = this.fileFolderViewModel.getTextAreaMaxHeight(this.containerBelong);
    this.textAreaBarState = this.textAreaHeight > this.textAreaMaxHeight ? BarState.On : BarState.Off;
  }

  private inputFileNameOnBlur(): void {
    this.log.showInfo(`text filed onBlur :${this.fileFolderItem?.ino}, selectStatus:${this.selectStatus}`);
    if (this.selectStatus !== SelectStatus.RENAME) {
      this.log.showWarn(`Not in rename status, do not handle rename`);
      return;
    }
    this.inputFocused = false;
    // 失焦重命名
    this.selectStatus = this.isSelect ? SelectStatus.SELECT : SelectStatus.UNSELECT;
    this.log.showInfo(`selectStatus: ${this.selectStatus}`);
    this.renameItem();
    this.isNameHover = false;
  }

  private inputFileNameOnFocus(): void {
    this.log.showInfo(`text filed focused: ${this.fileFolderItem?.ino}, TYPE_FOLDER: ${this.fileFolderItem?.fileType}`);
    this.inputFocused = true;
    let index = this.inputText.lastIndexOf('.');
    if (this.fileFolderItem.fileType === FileType.TYPE_FOLDER || this.fileFolderViewModel.isShortcut()) {
      this.controller.setTextSelection(0, this.inputText.length);
    } else {
      this.controller.setTextSelection(0, index >= 0 && index < this.inputText.length ? index : this.inputText.length);
    }
  }

  @Builder FileFolderName() {
    Column() {
      if (this.isRename()) {
        this.InputFileName()
      } else {
        this.StaticFileName()
      }
    }
    .id(this.fileFolderViewModel.getFileFolderNameId())
    .focusBox({strokeWidth: new LengthMetrics(0)})
    .dragStyles()
    .draggable(this.itemVisible && !this.compressing && (this.selectStatus !== SelectStatus.RENAME))
    .opacity(this.nameOpacity)
    .onTouch((event: TouchEvent) => {
      if (this.compressing) {
        return;
      }
      if (event.type === TouchType.Move) {
        this.onTouchMove = true;
      }
      event?.stopPropagation();
    })
  }

  private clearInputTextDelayTimer(): void {
    if (inputTextDelayTimer) {
      clearTimeout(inputTextDelayTimer);
      inputTextDelayTimer = null;
    }
  }

  private wallpaperChange(): void {
    let textColor: TextColor | undefined = WallpaperColorManager?.getInstance()?.mTextColor;
    if (textColor === undefined || textColor.mTextColor === undefined) {
      this.log.showError('textColor params error');
      return;
    }
    this.nameFontColor = textColor.mTextColor;
  }

  private onTapGestureEvent(): void {
    this.log.showInfo(`on item twice click: ${this.fileFolderItem?.ino}, compressing: ${this.compressing}`);
    if (this.compressing) {
      return;
    }
    this.twiceClickFlag = true;
    setTimeout(() => {
      this.twiceClickFlag = false;
    }, CLICK_FILE_NAME_INTERVAL);
    this.log.showInfo(`twiceClickFlag: ${this.twiceClickFlag}, isAltKeyDown:${keyEventManager.getIsAltKeyDown()}`);
    if (keyEventManager.getIsAltKeyDown()) {
      this.fileFolderManager.openFileDetail([this.fileFolderItem.uri ?? ''], true);
    } else {
      this.fileFolderManager.openFileOrFolder(this.fileFolderItem.uri ?? '', getContext(this) as ctx.UIAbilityContext);
    }
    this.containerViewModel?.selectItemClear();
  }

  private itemClickEvent = (event?: GestureEvent) => {
    if (event !== undefined && event.source === SourceType.TouchScreen) {
      if (this.isClicked) {
        return;
      }
      this.isClicked = true;
      this.onTapGestureEvent();
      setTimeout(() => {
        this.isClicked = false;
      }, CLICK_DELAY);
    }
  }

  private itemTwiceClickEvent = (event?: GestureEvent) => {
    if (event !== undefined && (event.source === SourceType.Mouse)) {
      this.onTapGestureEvent();
    }
  }

  private getKey(): string {
    if (this.fileFolderItem.ino) {
      return this.fileFolderItem.ino;
    }
    this.log.showError('getKey ino invalid');
    return '';
  }

  private requestFocus(ino?: string, suffix?: string): boolean {
    if (!ino) {
      this.log.showError('requestFocus ino invalid');
      return false;
    }
    let focusKey = ino;
    if (suffix) {
      focusKey = `${focusKey}${suffix}`;
    }
    return focusControl.requestFocus(focusKey);
  }

  async renameItem(): Promise<void> {
    this.log.showInfo('renameItem');
    this.renameFile = '';
    if (CheckEmptyUtils.checkStrIsEmpty(this.inputText)) {
      this.updateShowName();
      this.log.showWarn('text input is null, no need to rename');
      return;
    }
    if (this.inputText === this.fileFolderManager.getGuiNameByFileInfo(this.fileFolderItem.uri)) {
      this.updateShowName();
      this.log.showWarn('file name is not change, no need to rename');
      return;
    }
    if (!this.fileFolderItem.uri) {
      this.log.showError('renameItem uri invalid');
      return;
    }
    if (this.isExtensionSuffix) {
      this.showName = this.inputText;
    }
    const renameFileUri = this.fileFolderItem.uri;
    let res = await this.fileFolderManager.rename(this.fileFolderItem.uri, this.inputText, this.isExtensionSuffix);
    if (res && res !== '' && (res !== renameFileUri)) {
      this.log.showInfo('renameItem success');
      // 提前更新uri，避免在文管同步数据前误使用旧数据
      this.fileFolderItem.uri = res;
      this.showName = this.inputText;
      if (this.isSelect) {
        if (this.containerViewModel && this.containerViewModel.getCurrentSelectItems().length <= 0) {
          this.containerViewModel?.onSelectItemChange([this.itemKey], true);
        }
      } else {
        this.selectStatus = SelectStatus.UNSELECT;
        this.containerViewModel?.selectItemClear();
      }
      this.printFileInfo(this.fileFolderItem, 'renameFileSuccess');
    } else {
      const name: string = this.fileFolderManager.getGuiNameByFileInfo(this.fileFolderItem.uri);
      this.showName = name;
      this.inputText = name;
      if (this.containerViewModel && this.containerViewModel.getCurrentSelectItems().length <= 0) {
        this.containerViewModel?.onSelectItemChange([this.itemKey], true);
      }
    }
  }

  build() {
    Column() {
      Stack({ alignContent: Alignment.Center }) {
        this.AppIconBackgroundBuilder()
        this.FileFolderIcon()
        if (this.showThumbnailCharacter) {
          this.CachedImageBorder()
        }
        if (this.isDlp) {
          // DLP小锁
          this.DlpImage()
        }
        if (this.isShowPlayCircle) {
          this.playCircleBuilder()
        }

        if (this.isShortCut) {
          this.iconShortcut()
        }
      }
      .menuStyles()
      this.FileFolderName()
    }
    .opacity(this.itemVisible ? 1 : 0)
    .focusBox({strokeWidth: new LengthMetrics(0)})
    .onFocus(()=> {
      this.log.showInfo('FileFolderComponent column onFocus');
    })
    .onBlur(()=> {
      this.log.showInfo('FileFolderComponent column onBlur');
      this.isFocused = false;
    })
    .id(`FileFolderName_${this.fileFolderItem.ino}`)
    .onAppear(()=> {
      this.log.showInfo('onAppear');
      if (this.containerViewModel?.isPastedFile(this.fileFolderItem?.uri)) {
        this.containerViewModel?.onSelectItemChange([this.itemKey], true, true);
      }
    })
    .width('100%')
    .height('100%')
  }

  @Styles
  dragStyles() {
    .onDragStart((event: DragEvent, extraParams?: string) => {
      // offsetY包含1.背板marginTop, 图标marginTop， 此外拖拽坐标系计算宫格坐标时统一去除了iconMarginTop取整值，需去掉
      let isPad = CommonConstants.PAD_DEVICE_TYPE === AppStorage.get('device');
      let iconMarginVertical = isPad ? PageDesktopModel.getInstance().getPageDesktopStyleConfig().mIconMarginVertical : 0;
      const offsetY: number = GridLayoutUtil.getCeilVp(iconMarginVertical) +
      GridLayoutUtil.getCeilVp(StyleConstants.DEFAULT_4) -
      GridLayoutUtil.getFloorVp(iconMarginVertical);
      dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP,
        GridLayoutUtil.generateUniqueKey(this.fileFolderItem))
      ?.setWidth(this.iconSize)
        .setHeight(this.iconSize)
        .setOffset(0, offsetY);
      this.isDragStart = true;
      let dragItemInfo: DragItemInfo = this.handlerDragStart?.(event) ?? {};
      this.nameOpacity = this.isDragPaste ? 1 : 0;
      dragItemInfo.extraInfo = new DragExtraInfo(DragDataType.PC_FILE).setRadius(CommonConstants.DEFAULT_ICON_RADIUS)
        .setAllowDistributed(true).setDeviceSn(this.deviseSN).toString();
      event.setData?.(this.fileFolderManager.getDragEventData([this.fileFolderItem]));
      return dragItemInfo;
    })
    .onDragEnd((event: DragEvent, extraParams?: string) => {
      this.isDragStart = false;
      this.nameAppearAnimate();
      this.handlerDragEnd?.(event);
    })
    .onGestureJudgeBegin((gestureInfo: GestureInfo, event: BaseGestureEvent) => {
      if (gestureInfo.type === GestureControl.GestureType.DRAG && this.isMultiSelect &&
        event.source === SourceType.Mouse) {
        this.log.showWarn('cannot start drag when multi select');
        return GestureJudgeResult.REJECT;
      }
      return GestureJudgeResult.CONTINUE;
    })
  }

  private nameAppearAnimate(): void {
    this.log.showInfo('nameAppearAnimate');
    if (this.containerViewModel && this.containerViewModel.getCurrentSelectItems().length === 1) {
      nameAppearAnimate(() => this.nameOpacity = 1);
    } else {
      // 无需动画场景，直接显示
      this.nameOpacity = 1;
    }
  }

  /**
   * 更新文件图标的角标
   */
  private updateFileMark(): void {
    let isFolder: boolean = this.fileFolderItem?.fileType === FileType.TYPE_FOLDER;
    this.isDlp = this.fileFolderManager.getFileExtension(this.fileFolderItem?.fileFolderName, isFolder) === 'dlp';
    this.isShortCut = this.fileFolderManager.getFileExtension(this.fileFolderItem?.fileFolderName, false) === 'hlink';
  }

  @Builder
  DlpImage() {
    Image(this.fileFolderManager.getDlpImage())
      .draggable(false)
      .objectFit(ImageFit.Contain)
      .width(this.iconSize * WIDTH_PERCENT_OF_DLP_IMAGE)
      .height(this.iconSize * WIDTH_PERCENT_OF_DLP_IMAGE)
      .offset({
        x: (this.iconSize - this.iconSize * WIDTH_PERCENT_OF_DLP_IMAGE) / NUM_HALF,
        y: this.iconSize / NUM_HALF
      })
      .borderRadius(StyleConstants.DEFAULT_6)
      .focusable(false)
      .edgeAntialiasing(SVG_ANTIALIASING_OF_DLP_IMAGE)
      .onError((error: ImageError) => {
        this.log.showInfo(`dlp image load error: ${error?.message}, ino: ${this.fileFolderItem?.ino}`);
      })
  }

  @Builder
  iconShortcut() {
    Column() {
      Stack() {
        SymbolGlyph($r('sys.symbol.arrowshape_turn_up_right_fill'))
          .fontSize(StyleConstants.DEFAULT_12)
          .fontColor([$r('sys.color.font_emphasize')])
          .backgroundColor(Color.Transparent)
          .draggable(false)
          .focusable(false)
      }
      .padding(StyleConstants.DEFAULT_3)
      .border({ width: "0.5px", radius: "50%", color: $r('sys.color.comp_divider') })
      .backgroundBlurStyle(BlurStyle.COMPONENT_ULTRA_THICK)
      .draggable(false)
      .focusable(false)
      .position({ left: 0, bottom: 0 })
      .clip(true)
    }
    .iconContainerStyles()
    .hitTestBehavior(HitTestMode.Transparent)
  }

  @Builder
  playCircleBuilder() {
    Image($r('app.media.play_circle'))
      .objectFit(ImageFit.Contain)
      .margin((this.iconSize - FileFolderStyleConstants.GRID_VIDEO_THUMBNAIL_PLAY_CIRCLE_SIZE) / 2)
      .fillColor($r('sys.color.white'))
      .borderRadius(4)
      .enabled(false)
      .width(FileFolderStyleConstants.GRID_VIDEO_THUMBNAIL_PLAY_CIRCLE_SIZE)
      .height(FileFolderStyleConstants.GRID_VIDEO_THUMBNAIL_PLAY_CIRCLE_SIZE)
  }

  @Builder
  MenuBuilder() {
    if (!this.compressing) {
      FileFolderMenu({
        menuInfoList: this.fileFolderViewModel.getMenuInfoList(this.containerViewModel?.filterSelectFileItem()),
        menuWidth: this.fileFolderManager.getRightMenuMinWidth(),
        uri: this.fileFolderItem.uri,
      })
    }
  }

  private getDefaultImage(): PixelMap | string | Resource | null {
    let fileFolderName: string | undefined = this.fileFolderItem?.fileFolderName;
    let isFolder: boolean = this.fileFolderItem.fileType === FileType.TYPE_FOLDER;
    if (this.isShortCut) {
      let fileInfo:DesktopFileInfo | undefined= this.fileFolderManager.getTargetInfoByShortcutUri(this.fileFolderItem?.uri);
      fileFolderName = fileInfo?.fileName;
      isFolder = fileInfo?.fileType === FileType.TYPE_FOLDER;
    }
    return this.fileFolderManager.getDefaultImage(isFolder, fileFolderName ?? '');
  }

  private getCachedImageAlt(): PixelMap | string | Resource | null {
    const resource: PixelMap | string | Resource | null = this.getDefaultImage();
    return resource;
  }

  private isGetImageFromId(): boolean {
    if (this.fileFolderItem.fileType === FileType.TYPE_FOLDER || this.fileFolderViewModel.isFolderShortcut()) {
      return true;
    }
    let extension: string = this.fileFolderManager.getFileExtension(this.fileFolderItem.fileFolderName, false);
    return extension === 'folder' || extension === 'empty_folder';
  }

  private updateIcon(appIconId?: number): void {
    this.useCachedImage = this.fileFolderItem.appIconId === 0;
    this.log.showInfo(`updateIcon type is: ${this.fileFolderItem.fileType}, ino:${this.fileFolderItem.ino},\
     useCachedImage: ${this.useCachedImage}, appIconId:${appIconId}, fileFolderIconID:${this.fileFolderItem.appIconId}`);
    if (this.fileFolderItem.appIconId === 0 && this.fileFolderItem.uri !== undefined &&
      !this.fileFolderViewModel.isShortcut()) {
      if (this.fileFolderManager.isFilesFirstLoaded()) {
        this.fileFolderImage = this.fileFolderViewModel.getTargetUri() ?? '';
      }
    } else {
      if (appIconId !== undefined) {
        this.fileFolderItem.appIconId = appIconId;
      }
      this.log.showInfo(`the appiconid of this file is: ${this.fileFolderItem.appIconId}`);
      let iconImage: PixelMap | string | Resource | null = null;
      if (this.isGetImageFromId()) {
        // 文件夹和文管资源map中有的文件，还是复用原来的通路
        iconImage =
          FileIconUtils.getPixMapFromResourceId(this.fileFolderItem.appIconId, this.mDesktopContext) as PixelMap;
      } else {
        iconImage = this.fileFolderManager.getFileIconResource(this.fileFolderItem.fileFolderName ?? '');
      }
      if (iconImage) {
        this.fileFolderImage = iconImage;
      }
    }

    if (this.useCachedImage) {
      this.cachedImagePath = this.fileFolderViewModel.getThumbnailPathWithMtime();
      this.isVideoThumbnailType = this.fileFolderManager.isVideoThumbnailType(this.fileFolderItem.uri);
    }
    this.log.showInfo(`updateIcon fileFolderItem: ${this.fileFolderItem?.ino}`);
    const name: string = this.fileFolderManager.getGuiNameByFileInfo(this.fileFolderItem.uri);
    this.showName = name;
    this.inputText = name;
  }

  /**
   * whether is in renaming state
   */
  private isRename(): boolean {
    if (this.selectStatus === SelectStatus.RENAME) {
      this.animateScale = 1;
    }
    if (this.selectStatus === SelectStatus.RENAME) {
      this.textAreaMaxHeight = this.fileFolderViewModel.getTextAreaMaxHeight(this.containerBelong);
      if (this.fileFolderViewModel.isCrossOverBelongContainerBottom(this.containerBelong, this.containerViewModel)) {
        this.fileFolderViewModel.scrollToShowFullyInBelongContainer(this.containerBelong, this.containerViewModel);
      }
    }
    return this.selectStatus === SelectStatus.RENAME && !this.compressing;
  }

  private isCanShowTips(): boolean {
    let res: boolean = this.selectStatus !== SelectStatus.RENAME && !this.compressing &&
      !this.fileFolderManager.getMenuShowStatus() && !AppStorage.get('isDoingRename');
    this.log.showDebug(`file isCanShowTips: ${res}`);
    return res;
  }

  getIconBackgroundColor(): ResourceColor {
    if (this.isSelect && !this.compressing) {
      return $r('sys.color.ohos_id_color_bottom_tab_icon_auxcolor_off01');
    } else {
      return StyleConstants.DEFAULT_DESKTOP_BACKGROUND_COLOR;
    }
  }

  getNameBackgroundColor(): ResourceColor {
    if (this.isSelect && !this.compressing) {
      if (this.isGainFocus) {
        return $r('sys.color.ohos_id_color_activated');
      } else {
        return $r('sys.color.ohos_id_color_bottom_tab_icon_auxcolor_off01');
      }
    } else {
      return StyleConstants.DEFAULT_DESKTOP_BACKGROUND_COLOR;
    }
  }

  onItemSelectStateChange(): void {
    this.log.showInfo(`onItemSelectStateChange isSelected: ${this.isSelect} selectStatus: ${this.selectStatus}`);
    if (this.isSelect === false && this.selectStatus === SelectStatus.RENAME) {
      // State variable 'selectStatus' has changed during render!
      this.requestFocus(this.fileFolderItem.ino, 'image');
    }
  }

  onDesktopFocusChange(): void {
    this.log.showInfo(`focused: ${this.isGainFocus}, selected: ${this.selectStatus}, inputFocused: ${this.inputFocused}`);
    if (this.isGainFocus && this.selectStatus === SelectStatus.RENAME && !this.inputFocused) {
      let res: boolean = this.requestFocus(this.fileFolderItem.ino);
      this.log.showInfo('onDesktopFocusChange, focus result: ' + res);
    }
  }

  private getShadow(): ShadowOptions | ShadowOptions[] {
    if (!this.isShowShadow) {
      return { radius: 0 }
    }
    if ((!this.isSelect || this.compressing) && (this.nameFontColor === StyleConstants.DEFAULT_FONT_COLOR ||
      this.nameFontColor === StyleConstants.APP_NAME_WHITE_COLOR_ALPHA)) {
      return [
        {
          radius: StyleConstants.APP_NAME_FIRST_SHADOW_RADIUS,
          color: StyleConstants.APP_NAME_FIRST_SHADOW_COLOR,
          offsetY: StyleConstants.APP_NAME_FIRST_SHADOW_OFFSET_Y
        },
        {
          radius: StyleConstants.APP_NAME_SECOND_SHADOW_RADIUS,
          color: StyleConstants.APP_NAME_SECOND_SHADOW_COLOR,
          offsetY: StyleConstants.APP_NAME_SECOND_SHADOW_OFFSET_Y
        }
      ];
    } else {
      return { radius: 0 };
    }
  }

  private initTransitionController(): void {
    this.log.showInfo(`initTransitionController ino: ${this.fileFolderItem.ino}, appIconNumber: ${this.fileFolderItem.appIconId}`);
    this.transitionController = {
      appData: {
        bundleName: FILE_MANGER_BUNDLE_NAME,
        abilityName: this.fileFolderItem.ino as string,
        appIconId: this.componentId,
        appIconNumber: this.fileFolderItem.appIconId,
        iconRadius: this.iconRadius,
        startAppType: StartType.FILE_FOLDER,
        extraId: '',
        ino: this.fileFolderItem.ino,
        shortcutId: this.fileFolderItem.shortcutId,
        isOpenFolder: false,
      },
      onActive: (caller?: string): void => {},
      onInactive: (caller?: string): void => {},
    };
  }

  @Builder
  hoverTips() {
    HoverCompOnFile({ fileUri: this.fileFolderItem.uri })
      .onSizeChange((oldValue: SizeOptions, newValue: SizeOptions) => {
        this.hoverTipWindowWidth = Number(newValue.width);
        this.hoverTipWindowHeight = Number(newValue.height);
      })
  }

  private measureTipsHeight(fileUri: string): number {
    if (!fileUri) {
      this.log.showError('fileFolder Item uri invalid');
      return 0;
    }
    let fileInfoShowTexts: string[] = [];
    let tipsHeight:number = 0;
    fileInfoShowTexts = FileFolderManagerFactory.getFileFolderManager().getFileSummaryByUri(fileUri);
    fileInfoShowTexts.forEach((text) => {
      let itemLenHeightPX: SizeOptions = measure.measureTextSize({
        textContent: text,
        fontSize: HOVER_MENU_FONT_SIZE,
        textAlign:TextAlign.Start
      })
      tipsHeight += (px2vp(Number(itemLenHeightPX.height)) > HOVER_MENU_LINE_HEIGHT) ?
      px2vp(Number(itemLenHeightPX.height)) : HOVER_MENU_LINE_HEIGHT;
      tipsHeight += HOVER_TIP_TEXT_COLUMN_SPACE;
    })
    tipsHeight += HOVER_MENU_VERTICAL_PADDING * NUM_HALF - HOVER_TIP_TEXT_COLUMN_SPACE;
    return tipsHeight;
  }

  private hoverTipOverScreen() : boolean {
    // Hopper折叠屏无键盘场景使用screenHeight，其他场景|其他设备 使用displayHeight
    let availableHeight : number = this.fileFolderManager.getTipsAvailableHeight();
    this.log.showDebug(`hoverTipOverScreen ${availableHeight}`);
    if (Number(this.hoverTipDisPlayPosition.y) - Number(this.hoverTipPosition.y) +
      this.measureTipsHeight(this.fileFolderItem.uri ?? '') + HOVER_MENU_FONT_SIZE + POPUP_WIDTH_FROM_THE_SCREEN > availableHeight) {
      return true;
    } else {
      return false;
    }
  }

  private calculateTipsWidth(): number {
    const fileInfoShowTexts: string[] = this.fileFolderManager.getFileSummaryByUri(this.fileFolderItem.uri);
    let maxTextWidth: number = 0;
    fileInfoShowTexts.forEach((text) => {
      let textWidth: number = 0;
      if (text) {
        let itemLenWithPX: SizeOptions = measure.measureTextSize({
          textContent: text,
          fontSize: HOVER_MENU_FONT_SIZE
        })
        textWidth = px2vp(Number(itemLenWithPX.width));
      }
      maxTextWidth = Math.max(maxTextWidth, textWidth);
    });
    return maxTextWidth;
  }

  private hoverTipPositionHandle(): Position {
    let res: Position = { x: 0, y: 0 };
    const screenWith = AppStorage.get<number>('screenWidth') ?? 0;
    // 显示宽度为文本最大宽度加上左右padding
    const adaptiveTipsWith = this.calculateTipsWidth();
    this.hoverTipWindowWidth = Math.min(adaptiveTipsWith, HOVER_MENU_MAX_WIDTH) + HOVER_MENU_VERTICAL_PADDING * 2;
    this.log.showDebug('hoverTipPositionHandle: %{public}d, [%{public}d, %{public}d], [%{public}d, %{public}d], %{public}d',
      adaptiveTipsWith, this.hoverTipDisPlayPosition.x, this.hoverTipDisPlayPosition.y,
      this.hoverTipPosition.x, this.hoverTipPosition.y, screenWith);
    /**
     * tips边界跟随鼠标的x轴值
     * 右侧距离够，显示在右侧,与鼠标左对齐
     * 左侧距离够，显示在左侧，与鼠标右对齐
     * 右左距离都不够，现在在右侧，往左进行偏移
     */
    if (Number(this.hoverTipDisPlayPosition.x) + this.hoverTipWindowWidth + POPUP_HORIZONTAL_RESERVED_DISTANCE <= screenWith) {
      // popup不触发避让，做偏移保持x和鼠标一致
      res.x = this.hoverTipPosition.x;
    } else if (this.hoverTipWindowWidth + POPUP_HORIZONTAL_RESERVED_DISTANCE < Number(this.hoverTipDisPlayPosition.x)) {
      // Popup的屏幕避让不计算offset，先避让，再叠加offset保持x和鼠标一致
      res.x = Number(this.hoverTipDisPlayPosition.x) - (screenWith - POPUP_HORIZONTAL_RESERVED_DISTANCE) ;
    } else {
      // popup自动避让
      res.x = 0;
    }
    // 超过屏幕底部，8vp为popup预留屏幕距离
    if (this.hoverTipOverScreen()) {
      // 组件会自动翻转，此时相对位置为绑定组件左上角
      res.y = this.hoverEventY;
    } else {
      res.y = Number(this.hoverTipPosition.y) + HOVER_MENU_FONT_SIZE + StyleConstants.DEFAULT_8;
    }
    return res;
  }
}

@Component
export struct HoverCompOnFile {
  public fileUri: string = '';
  private fileFolderManager = FileFolderManagerFactory.getFileFolderManager();
  @State fileInfoShowTexts: string[] = [];

  aboutToAppear(): void {
    this.fileFolderManager.getFolderSizeByUri(this.fileUri).then((folderSize: number) => {
      this.fileInfoShowTexts = this.fileFolderManager.getFileSummaryByUri(this.fileUri, folderSize);
    });
    this.fileInfoShowTexts = this.fileFolderManager.getFileSummaryByUri(this.fileUri);
  }

  build() {
    HoverComp({ texts: this.fileInfoShowTexts })
  }
}


@Component
struct HoverComp {
  @Prop texts: string[];

  build() {
    Column({ space: 2 }) {
      ForEach(this.texts, (text: string) => {
        // UX提供的设计，hover提示弹窗的宽度不超过6columns，即604vp
        if (this.measureTextSize(text) > HOVER_MENU_MAX_WIDTH) {
          this.hoverWithTextOverSized(text)
        } else {
          // 若未超过最大宽度，则不设置width，宽度自适应
          this.hoverNormal(text)
        }
      })
    }
    .alignItems(HorizontalAlign.Start)
    .padding({
      left: HOVER_MENU_VERTICAL_PADDING,
      right: HOVER_MENU_VERTICAL_PADDING,
      top: HOVER_MENU_VERTICAL_PADDING,
      bottom: HOVER_MENU_VERTICAL_PADDING
    })
  }

  @Builder
  hoverWithTextOverSized(text: string) {
    Row() {
      Text(String(text))
        .textAlign(TextAlign.Start)
        .wordBreak(WordBreak.BREAK_ALL)
        .fontSize(HOVER_MENU_FONT_SIZE)
        .fontColor($r('sys.color.ohos_id_color_foreground'))
        .constraintSize({
          minHeight: HOVER_MENU_LINE_HEIGHT
        })
    }
    .width(HOVER_MENU_MAX_WIDTH)
    .borderRadius(HOVER_MENU_BORDER_RADIUS)
    .justifyContent(FlexAlign.Start)
  }

  @Builder
  hoverNormal(text: string) {
    Row() {
      Text(text)
        .textAlign(TextAlign.Start)
        .fontSize(HOVER_MENU_FONT_SIZE)
        .fontColor($r('sys.color.ohos_id_color_foreground'))
        .constraintSize({
          minHeight: HOVER_MENU_LINE_HEIGHT
        })
    }
    .borderRadius(HOVER_MENU_BORDER_RADIUS)
    .justifyContent(FlexAlign.Start)
  }

  private measureTextSize(str: string): number {
    if (!str) {
      return 0;
    }
    let itemLenWithPX: SizeOptions = measure.measureTextSize({
      textContent: str,
      fontSize: HOVER_MENU_FONT_SIZE
    })
    return px2vp(Number(itemLenWithPX.width));
  }
}
