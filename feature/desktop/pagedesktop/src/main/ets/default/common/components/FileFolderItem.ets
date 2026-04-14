/**
 * Copyright (c) 2023-2023 Huawei Device Co., Ltd.
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
  FileFolderComponent,
  SelectStatus
} from '@ohos/desktopfilefolder';
import { StyleConstants, PresetStyleConstants, GridLayoutUtil, BaseViewModel } from '@ohos/launchercommon';
import { CommonConstants } from '@ohos/launchercommon';
import { PageDesktopViewModel } from '../viewmodel/PageDesktopViewModel';
import { PageDesktopDragHandler } from '../PageDesktopDragHandler';
import { GridLayoutItemInfo } from '@ohos/launchercommon';
import performanceMonitor from '@ohos.arkui.performanceMonitor';
import { LogDomain, LogHelper, SingleContext} from '@ohos/basicutils';
import { HiSysEventUtil, WallpaperColorManager } from '@ohos/frameworkwrapper';
import { dragSnapshotHelper, SnapshotType } from '@ohos/componenthelper';
import featureConstants from '../constants/FeatureConstants';
import { multiSelectListenerManger } from '../MultiSelectListenerManager';
import { PageDesktopGridStyleConfig } from '@ohos/launchercommon/src/main/ets/layoutconfig/PageDesktopGridStyleConfig';
import { DragEventManager } from '@ohos/componentdrag';
import { FileFolderViewIf } from '@ohos/launchercommon/src/main/ets/pagedesktop/viewmodel/DesktopItemBuilderProxy';
import { DomainName, TraceUtil } from '@ohos/basicutils';

const TAG = 'FileFolderItem';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * Folder item, which display on desktop workspace.
 */
@Component
export default struct FileFolderItem {
  @Prop singleContext?: SingleContext;
  @StorageLink('dragItemType') dragItemType: number = CommonConstants.DRAG_FROM_DESKTOP;
  @State fileFolderItem: GridLayoutItemInfo = new GridLayoutItemInfo();
  @Provide selectStatus: number = SelectStatus.UNSELECT;
  private mPageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance(this.singleContext);
  @State mFileFolderNameWidth: number = StyleConstants.DEFAULT_APP_NAME_WIDTH;
  @State mFileFolderNameHeight: number = StyleConstants.DEFAULT_APP_NAME_HEIGHT;
  mIconNameMarginTop: number = PresetStyleConstants.DEFAULT_ICON_NAME_MARGIN_TOP;
  @Consume translateX: number;
  @Consume translateY: number;
  @Consume itemOpacity: number;
  @State itemScale: number = 1;
  @Prop isSelect: boolean = false;
  @Prop isGainFocus: boolean = false;
  @Prop isCut: boolean = false;
  onItemSelect?: Function;
  dragStart?: Function;
  dragEnd?: Function;
  @Link isDragStart: boolean;
  @State iconScale: number = 1;
  @State compressing: boolean = false;
  private mPageDesktopDragHandler: PageDesktopDragHandler = PageDesktopDragHandler.getInstance(this.singleContext);
  @Link isDragPaste: boolean;
  @Link isInDrag: boolean;
  styleConfig:PageDesktopGridStyleConfig = this.mPageDesktopViewModel.getPageDesktopStyleConfig();
  @Prop mIconSize: number = this.styleConfig.mIconSize;
  @State mFileFolderNameSize: number = this.styleConfig.mNameSize;
  isShowShadow: boolean = true;
  @State marginValue: Margin = {
    left: StyleConstants.DEFAULT_3,
    right: StyleConstants.DEFAULT_3,
    top: StyleConstants.DEFAULT_0,
  };
  @State paddingValue : Padding = {
    bottom: StyleConstants.DEFAULT_2,
    top: StyleConstants.DEFAULT_2,
    left: StyleConstants.DEFAULT_2,
    right: StyleConstants.DEFAULT_2
  };
  @Prop maxLines: number = 0;
  @Prop mFileFolderItemWidth: number = this.styleConfig.mAppItemSize;
  private mMarginVertical: number = this.styleConfig.mIconMarginVertical;
  @Prop mFileFolderItemHeight: number = this.styleConfig.mAppItemSize;
  @Prop nameFontColor: string | undefined = WallpaperColorManager?.getInstance()?.mTextColor?.mTextColor;
  private containerViewModel?: BaseViewModel;
  getContainerViewModel?: () => BaseViewModel;

  defaultDragStart(event: DragEvent): DragItemInfo {
    AppStorage.setOrCreate('isDrag', true);
    ContextMenu.close();
    this.selectStatus = SelectStatus.SELECT;
    this.dragItemType = CommonConstants.DRAG_FROM_DESKTOP;
    let selectItemInfoList: GridLayoutItemInfo[] = this.mPageDesktopViewModel.getCurrentSelectItemsInfo();
    AppStorage.setOrCreate<GridLayoutItemInfo[]>('dragItemInfo', selectItemInfoList);
    log.showInfo(`desktop drag dragItemInfo: length = ${selectItemInfoList.length}`);
    PageDesktopDragHandler.getInstance(this.singleContext).onDragStart(event.getWindowX(), event.getWindowY());
    multiSelectListenerManger.executeDragging();
    let itemKey: string = GridLayoutUtil.generateUniqueKey(this.fileFolderItem);
    let dragItemInfo: DragItemInfo = {
      pixelMap: dragSnapshotHelper.getSnapshot(SnapshotType.DRAG, itemKey),
    };
    log.showInfo(`drag start dragItemInfo:${dragItemInfo}`);
    return dragItemInfo;
  }

  onFocusChange() {
    log.showInfo(`onFocusChange:${this.fileFolderItem.ino}`);
    this.selectStatus = SelectStatus.RENAME;
    focusControl.requestFocus(this.fileFolderItem.ino);
    let itemKey = this.containerViewModel?.getItemKeyByType(this.fileFolderItem);
    this.containerViewModel?.onSelectItemChange([itemKey], true);
  }

  aboutToAppear(): void {
    if (this.getContainerViewModel) {
      this.containerViewModel = this.getContainerViewModel();
    }
    let styleConfig = this.mPageDesktopViewModel.getPageDesktopStyleConfig();
    this.mIconNameMarginTop = styleConfig.mIconNameMarginTop;
    this.mFileFolderNameWidth = styleConfig.mNameWidth;
    this.mFileFolderNameHeight = styleConfig.mNameHeight;
    if (this.fileFolderItem?.ino) {
      this.mPageDesktopViewModel.registerFocusChangeListener(this.fileFolderItem.ino, this);
    }
    log.showInfo(` mFileFolderItemWidth:${this?.mFileFolderItemWidth}, mMarginVertical:${this?.mMarginVertical},
    mIconNameMarginTop:${this?.mIconNameMarginTop}, mFileFolderNameSize:${this?.mFileFolderNameSize},
    mFileFolderNameWidth:${this?.mFileFolderNameWidth}, mFileFolderNameHeight:${this?.mFileFolderNameHeight},
    mIconSize:${this?.mIconSize}`);
  }

  aboutToDisappear(): void {
    log.showInfo('enter into aboutToDisappear');
    if (this.fileFolderItem?.ino) {
      this.mPageDesktopViewModel.unregisterFocusChangeListener(this.fileFolderItem.ino, this);
    }
  }

  build() {
    Flex({
      direction: FlexDirection.Column,
      alignItems: ItemAlign.Center,
      justifyContent: FlexAlign.SpaceAround
    }) {
      Column() {
        FileFolderComponent({
          singleContext: this.singleContext,
          fileFolderItem: this.fileFolderItem,
          nameSize: this.mFileFolderNameSize,
          nameWidth: this.mFileFolderNameWidth,
          nameHeight: this.mFileFolderNameHeight,
          iconSize: this.mIconSize,
          isSelect: this.isSelect,
          isInDrag: this.isInDrag,
          isDragPaste: this.isDragPaste,
          isGainFocus: this.isGainFocus,
          mIconNameMarginTop: this.mIconNameMarginTop,
          onItemSelect: this.onItemSelect,
          iconScale: this.iconScale,
          handlerDragStart: (event: DragEvent) => this.handlerDragStart(event),
          handlerDragEnd: (event: DragEvent) => this.handlerDragEnd(event),
          compressing: this.compressing,
          isShowShadow: this.isShowShadow,
          marginValue: this.marginValue,
          paddingValue: this.paddingValue,
          maxLines: this.maxLines,
          getContainerViewModel: this.getContainerViewModel,
          maxWidth: this.mFileFolderItemWidth,
        })
          .padding({
            top: this.mMarginVertical
          })
          .translate({x: this.translateX, y: this.translateY})
          .visibility(this.getVisibility())
          .opacity((this.isCut || this.compressing) ? featureConstants.CUT_ITEM_ALPHA : this.itemOpacity)
          .scale({ x: this.itemScale, y: this.itemScale })
          .width(this.mFileFolderItemWidth)
          .height(this.mFileFolderItemHeight)
      }
    }
  }

  private handlerDragStart(event: DragEvent): DragItemInfo {
    let dragItemInfo: DragItemInfo = {};
    if (AppStorage.get<string>('device') !== CommonConstants.DEFAULT_DEVICE_TYPE) {
      performanceMonitor.begin(HiSysEventUtil.DRAG_ITEM_ANI, performanceMonitor.ActionType.FIRST_MOVE, 'item:[PCFolder]');
      TraceUtil.startTrace(DomainName.HOME, HiSysEventUtil.DRAG_ITEM_ANI, TraceUtil.CUSTOM_ANIMATOR_PREFIX);
      AppStorage.setOrCreate('selectItem', '');
      if (this.dragStart) {
        return this.dragStart(event);
      } else {
        return this.defaultDragStart(event);
      }
    }
    return dragItemInfo;
  }

  private handlerDragEnd(event: DragEvent): void {
    log.showInfo('desktop drag onDragEnd event');
    this.iconScale = 1;
    if (this.dragEnd) {
      this.dragEnd(event);
      return;
    }
    multiSelectListenerManger.executeFinish();
    AppStorage.setOrCreate<boolean>('isDrag', false);
    // clean dragItemInfo after drag end
    AppStorage.setOrCreate('dragItemInfo', new GridLayoutItemInfo());
    this.dragItemType = CommonConstants.DRAG_FROM_UNKNOWN;
    if (this.mPageDesktopDragHandler.isDragLeaveSwiperPage()) {
      this.mPageDesktopDragHandler.onDragLeave(0, 0);
    }
    this.isDragStart = false;
    DragEventManager.getInstance().startDrop(
      GridLayoutUtil.generateUniqueKey(this.fileFolderItem as Object as GridLayoutItemInfo));
  }

  getVisibility(): Visibility {
    if (this.isDragPaste) {
      return Visibility.Visible;
    }
    return this.isDragStart ? Visibility.Hidden : Visibility.Visible;
  }
}

@Builder export function FileFolderItemBuilder($$: FileFolderViewIf) {
  FileFolderItem({
    fileFolderItem: $$.item,
    mIconSize: $$.iconSize,
    onItemSelect: $$.onItemSelect,
    mFileFolderNameSize: $$.fileFolderNameSize,
    isShowShadow: $$.isShowShadow,
    marginValue: $$.marginValue,
    paddingValue: $$.paddingValue,
    mFileFolderItemWidth: $$.fileFolderItemWidth,
    maxLines: $$.maxLines,
    mMarginVertical: $$.verticalMargin,
    mFileFolderItemHeight: $$.fileFolderItemHeight,
    isSelect: $$.isSelect,
    isCut: $$.isCut,
    isGainFocus: $$.isGainFocus,
    dragStart: $$.dragStart,
    dragEnd: $$.dragEnd,
    isDragStart: $$.isDragStart,
    isInDrag: $$.isInDrag,
    isDragPaste: $$.isDragPaste,
    getContainerViewModel: $$.getContainerViewModel,
  })
    .id(`${$$.tag}_FileFolderItem_${$$.item.ino}`)
    .translate({ x: $$.translateX, y: $$.translateY })
    .opacity($$.itemOpacity)
}