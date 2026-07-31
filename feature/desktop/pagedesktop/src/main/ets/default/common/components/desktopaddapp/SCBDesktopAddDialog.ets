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

import { CommonUtils, LogDomain, Logger } from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import {
  GridLayoutItemInfo,
  StyleConfig,
  StyleConstants,
  PresetStyleConstants,
  GridLayoutUtil,
  CommonConstants,
  LayoutViewModel,
  OpenFolderStyleConfig,
  FolderStyleManager,
  BigFolderStyleConfig,
  RdbStoreManager,
  LaunchLayoutCacheManager,
  DesktopPosition,
  scbBlankPositionUtils,
  AppItemInfo,
  LayoutDescription
} from '@ohos/launchercommon';
import { launcherVisualEffectMgr } from '@ohos/launchercommon/Index';
import { DeliverUtil } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { AppIconBadgeVm } from '@ohos/launchercommon/src/main/ets/launchericon/viewmodel/AppIconBadgeVm';
import { MeasureText } from '@kit.ArkUI';
import common from '@ohos.app.ability.common';
import { StateEx } from '@ohos/componenthelper';
import { AddDialogBubble } from './AddDialogBubble';
import { DesktopAddItemInfo, DesktopAddItemInfoType, SCBDesktopAddViewModel } from './SCBDesktopAddViewModel';
import { DesktopAddBubbleNodeParams } from './DesktopAddBubbleNodeParams';
import DesktopAddDialogConstant from './DesktopAddDialogConstant';
import { PageDesktopViewModel } from '../../viewmodel/PageDesktopViewModel';
import { LightOutdoorDesktopViewModel } from '../../viewmodel/LightOutdoorDesktopViewModel';
import { launcherStatusUtil } from '@ohos/windowscene';

const SCROLL_SPEED_SCALING = 0.7;
const SCROLL_START_CACHED_VALUE = 5;
const SCROLL_STOP_CACHED_VALUE = 1;
export const folderAddSheetOther: string = 'folder_add_sheet_other';
export const sheetTitleRecommended: string = 'sheet_title_recommended';
const TAG = 'SCBDesktopAddDialog';
const log: Logger = Logger.getLogHelper(LogDomain.HOME);

@Component
export default struct SCBDesktopAddDialog {

  @State checkedAppList: GridLayoutItemInfo[] = [];
  @State allAppList: DesktopAddItemInfo[] = [];
  @State desktopAddDataSource: DesktopAddDataSource = new DesktopAddDataSource(this.allAppList);
  @State iconBadgeVm: AppIconBadgeVm = new AppIconBadgeVm();
  @State isHideDialog: boolean = false;
  @State dialogOpacity: StateEx<number> = launcherVisualEffectMgr.getDesktopDialogOpacity();
  @Prop isShow: boolean = false;
  public onIsShowChange:(newIsShow: boolean) => void = () => {};
  private paramsMap: Map<string, DesktopAddBubbleNodeParams> = new Map();
  private desktopAddViewModel: SCBDesktopAddViewModel = SCBDesktopAddViewModel.getInstance();
  private dialogHeight: number = 0;
  private gridItemHeight: number = 0;
  private gridColumnTemplate: string = this.desktopAddViewModel.getColumnsTemplate();
  private gridPadding: number = 0;
  private buttonWidth: number = 0;
  private buttonMaxFontSize: Length = DesktopAddDialogConstant.BODY_L;
  private buttonMinFontSize: Length = 9;
  private titleFontSize: Length = DesktopAddDialogConstant.SUBTITLE_L;
  private subTitleFontSize: Length = DesktopAddDialogConstant.SUBTITLE_S;
  private isVerticalAlignButton: boolean = false;
  private bigStyle: BigFolderStyleConfig =
    FolderStyleManager.getInstance().getFolderStyleConfig() ?? BigFolderStyleConfig.getInstance();
  @State gridCachedCount: number = 1;
  @State gridLayoutOptions: GridLayoutOptions = {
    regularSize: [1, 1],
    irregularIndexes: []
  };

  private calculateFontSize(): void {
    try {
      let context: common.ExtensionContext = this.getUIContext().getHostContext() as common.ExtensionContext;
      let fontSizeScale: number = context.config?.fontSizeScale ?? 1;

      if (fontSizeScale > DesktopAddDialogConstant.MAX_FONT_SCALE) {
        this.buttonMaxFontSize = DesktopAddDialogConstant.BODY_L * DesktopAddDialogConstant.MAX_FONT_SCALE + 'vp';
        this.buttonMinFontSize = DesktopAddDialogConstant.BUTTON_MIN_FONT_SIZE *
        DesktopAddDialogConstant.MAX_FONT_SCALE + 'vp';
        this.titleFontSize = DesktopAddDialogConstant.SUBTITLE_L * DesktopAddDialogConstant.MAX_FONT_SCALE + 'vp';
        this.subTitleFontSize = DesktopAddDialogConstant.SUBTITLE_S * DesktopAddDialogConstant.MAX_FONT_SCALE + 'vp';
      } else {
        this.buttonMaxFontSize = DesktopAddDialogConstant.BODY_L + 'fp';
        this.buttonMinFontSize = DesktopAddDialogConstant.BUTTON_MIN_FONT_SIZE + 'fp';
        this.titleFontSize = DesktopAddDialogConstant.SUBTITLE_L + 'fp';
        this.subTitleFontSize = DesktopAddDialogConstant.SUBTITLE_S + 'fp';
      }
    } catch (exception) {
      log.showError(TAG, 'calculateLayout calculateFontSize error');
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

  private calculateLayout(): void {
    let dialogWidth: number = 0;
    if (StyleConfig.rootContainerStyle().width === '') {
      let screenWidth: number = AppStorage.get<number>('screenWidth') ?? 0;
      dialogWidth = screenWidth - StyleConstants.DEFAULT_16 * 2;
    } else {
      dialogWidth = StyleConfig.rootContainerStyle().width as number;
    }
    let iconSize: number = LayoutViewModel.getInstance().calculateDesktop().mIconSize ?? 0;
    const columnCount: number = this.desktopAddViewModel.getDialogGridColumns();
    let padding: number = StyleConfig.rootContainerStyle().padding;
    let itemPadding: number = (dialogWidth - padding * 2 - iconSize * columnCount) / ((columnCount - 1) * 2);
    this.gridPadding = padding - itemPadding;
    if (DeviceHelper.isPad() || DeviceHelper.isFold()) {
      this.buttonWidth = ((dialogWidth - DesktopAddDialogConstant.BUTTON_SPACE) - StyleConstants.DEFAULT_16 * 2) / 2;
    } else {
      this.buttonWidth = (dialogWidth - DesktopAddDialogConstant.BUTTON_SPACE) / 2;
    }
    this.calculateFontSize();
    this.calculateButtonAlign();
  }

  private async initAddBubbleSheet(): Promise<void> {
    this.checkedAppList = await this.desktopAddViewModel.getContainsItemList();//获取云端模式2下已有的应用
    this.allAppList = await this.desktopAddViewModel.getAllDesktopAddItemInfos(this.checkedAppList, true);//获取全量可安装应用
    this.desktopAddDataSource.refreshData(this.allAppList);
  }

  private onGridItemClick(info: DesktopAddItemInfo): void {
    for (let clickItem of this.allAppList) {
      if (clickItem.itemInfo.keyName === info.itemInfo.keyName) {
        if (!clickItem.isChecked &&
          this.checkedAppList.length >= this.desktopAddViewModel.getMaxAppCount()) {
          this.desktopAddViewModel.showToast(CommonConstants.RES_DESKTOP_ADD_ITEMS_FULL);
        } else {
          clickItem.isChecked = !clickItem.isChecked;
          log.showInfo(TAG, `onGridItemClick isChecked ${clickItem.isChecked} keyName ${clickItem.itemInfo.keyName}`);
        }
        break;
      }
    }
  }

  //应用选中状态变化
  private onCheckStateChange(isOn: boolean, info: DesktopAddItemInfo): number {
    let index: number = this.checkedAppList.findIndex(item => item.keyName === info.itemInfo.keyName);
    if (isOn) {
      if (index === -1) {
        this.checkedAppList.push(info.itemInfo);
      }
    } else {
      if (index !== -1) {
        this.checkedAppList.splice(index, 1);
      }
    }
    for (let clickItem of this.allAppList) {
      if (clickItem.itemInfo.keyName === info.itemInfo.keyName) {
        clickItem.isChecked = isOn;
        break;
      }
    }
    this.checkedAppList.forEach(item => {
      log.showDebug(TAG, `CheckedAppList item name is: ${item.appName}`);
    })
    log.showDebug(TAG, `CheckedAppList length is: ${this.checkedAppList.length}`);
    return this.checkedAppList.length;
  }

  private getItemReuseId(item: DesktopAddItemInfo): string {
    if (!GridLayoutUtil.isAppInstalled(item.itemInfo)) {
      return 'DialogBubbleDownload';
    } else if (item.itemInfo.bundleName === CommonConstants.CALENDAR_BUNDLE) {
      return 'DialogBubbleCalendar';
    } else if (item.itemInfo.bundleName === CommonConstants.CLOCK_BUNDLE) {
      return 'DialogBubbleClock';
    } else if (item.itemInfo.appIndex !== 0) {
      return 'DialogBubbleIndex';
    } else if (DeliverUtil.isdeliverApp(item.itemInfo.intent)) {
      return 'DialogBubbledeliver';
    } else if (GridLayoutUtil.isShortcutToDesktopInApp(item.itemInfo)) {
      return 'DialogBubbleShortcutToDesktop';
    } else {
      return 'DialogBubble';
    }
  }

  private getAddBubbleParams(item: DesktopAddItemInfo): DesktopAddBubbleNodeParams {
    if (this.paramsMap.has(item.itemInfo.keyName ?? item.itemInfo.bundleName)) {
      return this.paramsMap.get(item.itemInfo.keyName ?? item.itemInfo.bundleName) as DesktopAddBubbleNodeParams;
    }
    let param: DesktopAddBubbleNodeParams = new DesktopAddBubbleNodeParams();
    param.item = item;
    param.onGridItemClick = this.onGridItemClick.bind(this);
    param.onCheckChange = this.onCheckStateChange.bind(this);
    this.paramsMap.set(item.itemInfo.keyName ?? item.itemInfo.bundleName, param);
    return param;
  }

  //页面初始化渲染，每次重新打开这个界面都会重新渲染，包括获取各种应用以及item映射
  async aboutToAppear(): Promise<void> {
    this.calculateLayout();
    launcherStatusUtil.setDesktopAddModeStatus(true);
    this.gridItemHeight = OpenFolderStyleConfig.getInstance().getOpenFolderStyle().iconSize +
    PresetStyleConstants.DEFAULT_ICON_NAME_MARGIN_TOP +
    FolderStyleManager.getInstance().getFolderStyleConfig().mOpenFolderAppNameHeight;
    await this.initAddBubbleSheet();
    this.gridLayoutOptions = {
      regularSize: [1, 1],
      irregularIndexes: this.desktopAddDataSource.getIrregularIndexes()
    };
  }

  aboutToDisappear(): void {
    launcherStatusUtil.setDesktopAddModeStatus(false);
    this.paramsMap.clear();
  }

  //点击确认后的处理
  private async onConfirmButtonClick(): Promise<void> {
    log.showInfo(TAG, `onConfirmButtonClick`)
    let containList = await SCBDesktopAddViewModel.getInstance().getContainsItemList();//云端2桌面用户自己添加的应用
    let removeList: GridLayoutItemInfo [] = [];
    //删除已有的
    containList.forEach(item => {
      if (!this.desktopAddViewModel.findApp(this.checkedAppList, item.bundleName)) {
        removeList.push(item);
        LaunchLayoutCacheManager.getInstance().deleteGridLayoutItemByBundleNameAndType(item.bundleName,
          item.typeId, '', true);
      }
    });
    LightOutdoorDesktopViewModel.getInstance().removeAddIcon();
    //新增已选的
    this.checkedAppList.forEach(item => {
      if (!this.desktopAddViewModel.findApp(containList, item.bundleName)) {
        let intentMap: Map<string, Object> = CommonUtils.jsonStrToMap(item.intent);
        intentMap.set('comeFrom', 'userAdd');
        item.intent = CommonUtils.mapToJonStr(intentMap);
        item.area = [1, 1];
        this.desktopAddViewModel.insertGridLayout(item);
        log.showInfo(TAG, `add new item: ${item.bundleName}, page:${item.page}, row: ${
        item.row}, column: ${item.column}`);
      }
    });
    PageDesktopViewModel.getInstance().lightPagingFiltering(false, 'appendUserSelectedApp');
    this.desktopAddViewModel.refreshContainAppList(this.checkedAppList);
    this.desktopAddViewModel.refreshRemovedAppList(removeList);
    LightOutdoorDesktopViewModel.getInstance().sendDesktopAppChangeEvent();
  }

  @Builder
  DialogTitleBuilder(title: Resource | string, paddingTop: string, paddingBottom: string) {
    Text(title)
      .draggable(false)
      .fontWeight(FontWeight.Bold)
      .fontColor($r('sys.color.font_primary'))
      .fontFamily(DesktopAddDialogConstant.FONT_FAMILY_ohos)
      .width('100%')
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
  DialogSubTitleBuilder(title: Resource | string, paddingTop: string) {
    Text(title)
      .draggable(false)
      .fontColor($r('sys.color.font_secondary'))
      .fontWeight(FontWeight.Regular)
      .fontFamily(DesktopAddDialogConstant.FONT_FAMILY_ohos)
      .width('100%')
      .maxLines(DesktopAddDialogConstant.DIALOG_TITLE_MAX_LINES)
      .fontSize(this.subTitleFontSize)
      .textOverflow({ overflow: TextOverflow.Ellipsis })
      .textAlign(TextAlign.Start)
      .padding({ top: paddingTop, bottom: DesktopAddDialogConstant.GRID_SUBTITLE_PADDING_BOTTOM,
        left: this.bigStyle.mBindSheetTitlePadding, right: this.bigStyle.mBindSheetTitlePadding })
  }

  //具体网格
  @Builder
  DialogGridItemBuilder(item: DesktopAddItemInfo) {
    GridItem() {
      AddDialogBubble({
        params: this.getAddBubbleParams(item),
      })
        .reuseId(this.getItemReuseId(item))
    }
    .margin({ top: DesktopAddDialogConstant.GRID_ITEM_PADDING_TOP,
      bottom: DesktopAddDialogConstant.GRID_ITEM_PADDING_BOTTOM })
    .width('100%')
    .height(this.gridItemHeight)
  }

  //主要应用显示网格
  @Builder
  DialogGridBuilder() {
    Grid(undefined, this.gridLayoutOptions) {
      LazyForEach(this.desktopAddDataSource, (item: DesktopAddItemInfo) => {
        if (item.type === DesktopAddItemInfoType.Title) {
          GridItem() {
            this.DialogTitleBuilder($r('app.string.' + item.catName), DesktopAddDialogConstant.OTHER_TITLE_PADDING_TOP,
              DesktopAddDialogConstant.GRID_TITLE_PADDING_BOTTOM)
          }
        }
        if (item.type === DesktopAddItemInfoType.GridItem) {
          this.DialogGridItemBuilder(item)
        }
      }, (item: DesktopAddItemInfo) => item.itemInfo.keyName)
    }
    .columnsTemplate(this.gridColumnTemplate)
    .padding({ left: this.bigStyle.mBindSheetGridPadding, right: this.bigStyle.mBindSheetGridPadding,
      bottom: DesktopAddDialogConstant.GRID_MARGIN_BOTTOM })
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

  // 取消按钮
  @Builder
  LeftButtonBuilder(textResource: Resource) {
    Button(textResource, { type: ButtonType.Capsule, stateEffect: true })
      .labelStyle({
        maxLines: 1,
        maxFontSize: this.buttonMaxFontSize,
        minFontSize: this.buttonMinFontSize,
        heightAdaptivePolicy: TextHeightAdaptivePolicy.MIN_FONT_SIZE_FIRST
      })
      .fontFamily(DesktopAddDialogConstant.FONT_FAMILY_ohos)
      .fontColor($r('sys.color.font_emphasize'))
      .fontWeight(FontWeight.Medium)
      .backgroundColor($r('sys.color.comp_background_tertiary'))
      .width(this.isVerticalAlignButton ? '100%' : this.buttonWidth)
      .borderRadius(StyleConstants.PC_DIALOG_BUTTON_RADIUS)
      .padding({
        left: StyleConstants.DEFAULT_18,
        right: StyleConstants.DEFAULT_18,
        top: DesktopAddDialogConstant.DEFAULT_BUTTON_PADDING,
        bottom: DesktopAddDialogConstant.DEFAULT_BUTTON_PADDING
      })
      .onClick(() => {
        this.onIsShowChange(!this.isShow);
      })
  }

  //确定按钮
  @Builder
  RightButtonBuilder(textResource: Resource, onClickCallback?: Function) {
    Button(textResource, { type: ButtonType.Capsule, stateEffect: true })
      .labelStyle({
        maxLines: 1,
        maxFontSize: this.buttonMaxFontSize,
        minFontSize: this.buttonMinFontSize,
        heightAdaptivePolicy: TextHeightAdaptivePolicy.MIN_FONT_SIZE_FIRST
      })
      .fontFamily(DesktopAddDialogConstant.FONT_FAMILY_ohos)
      .fontColor($r('sys.color.font_on_primary'))
      .fontWeight(FontWeight.Medium)
      .backgroundColor($r('sys.color.comp_background_emphasize'))
      .width(this.isVerticalAlignButton ? '100%' : this.buttonWidth)
      .borderRadius(StyleConstants.PC_DIALOG_BUTTON_RADIUS)
      .padding({
        left: StyleConstants.DEFAULT_18,
        right: StyleConstants.DEFAULT_18,
        top: DesktopAddDialogConstant.DEFAULT_BUTTON_PADDING,
        bottom: DesktopAddDialogConstant.DEFAULT_BUTTON_PADDING
      })
      .onClick(() => {
        this.onIsShowChange(!this.isShow);
        if (onClickCallback) {
          onClickCallback();
        }
      })
  }

  //桌面添加应用的添加页
  build() {
    Column() {
      Column() {
        this.DialogGridBuilder();
      }
      .layoutWeight(1)

      Row({ space: DesktopAddDialogConstant.BUTTON_SPACE }) {
        this.LeftButtonBuilder($r('app.string.cancel'))
        this.RightButtonBuilder($r('app.string.confirm_dialog'), () => {
          this.onConfirmButtonClick();
        })
      }
      .margin({
        right: DesktopAddDialogConstant.BUTTON_MARGIN,
        top: DesktopAddDialogConstant.BUTTON_MARGIN,
        left: DesktopAddDialogConstant.BUTTON_MARGIN,
        bottom: DesktopAddDialogConstant.BUTTON_MARGIN
      })
    }
    .margin( { bottom: DesktopAddDialogConstant.NAVI_BAR_HEIGHT})
  }
}

class DesktopAddDataSource implements IDataSource {
  private dataSource: DesktopAddItemInfo[] = [];
  private dataChangeListeners: DataChangeListener[] = [];

  constructor(dataList: DesktopAddItemInfo[]) {
    this.dataSource = dataList;
  }

  public totalCount(): number {
    return this.dataSource === null ? 0 : this.dataSource.length;
  }

  public getData(index: number): DesktopAddItemInfo {
    let info: DesktopAddItemInfo = index >= 0 && index < this.totalCount() ? this.dataSource[index] :
      new DesktopAddItemInfo();
    if (!GridLayoutUtil.isShortcutToDesktopInApp(info.itemInfo)) {
      info.itemInfo.appName = '';
    }
    return info;
  }

  public refreshData(dataList: DesktopAddItemInfo[]) {
    this.dataSource = dataList;
    this.notifyDataReload();
  }

  public getIrregularIndexes(): number[] {
    const irregularIndexes : number[] = [];
    this.dataSource.forEach((item, index) => {
      if (item.type === DesktopAddItemInfoType.Title) {
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