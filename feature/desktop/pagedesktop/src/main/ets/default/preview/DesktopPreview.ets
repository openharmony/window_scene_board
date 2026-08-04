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

import {
  CommonConstants,
  DesktopParam,
  FormManager,
  GridLayoutItemInfo,
  PresetStyleConstants,
  StyleConstants,
} from '@ohos/launchercommon/src/main/ets/TsIndex';
import { GridLayoutOptionUtil } from './GridLayoutOptionUtil';
import { DesktopPreviewRdbManager } from './DesktopPreviewRdbManager';
import { FormStackItemInfo } from '@ohos/formstack/src/main/ets/common/FormStackItemInfo';
import { DesktopPreviewViewModel } from './DesktopPreviewViewModel';
import { Log } from './Log';
import { ResUtils } from '@ohos/windowscene';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { SCBConstants } from '@ohos/commonconstants';
import { FolderItemData } from './data/FolderItemData';
import FeatureConstants from '../common/constants/FeatureConstants';
import { PreviewUtils } from './PreviewUtils';
import { FormItemData } from './data/FormItemData';
import { FormStackStyleConstants } from '@ohos/formstack/src/main/ets/common/FormStackStyleConstants';
import { StackData } from './data/StackData';
import { image } from '@kit.ImageKit';
import { display } from '@kit.ArkUI';

const TAG: string = 'DesktopPreview';
const SHADOW_NAME_MAX_LENGTH: number = 14;

@Component
export default struct DesktopPreview {
  @Consume('pageInfos') pageInfos: NavPathStack;
  @State mDesktopData: GridLayoutItemInfo[] = [];
  @State gridOptions: GridLayoutOptions = GridLayoutOptionUtil.getGridLayoutOptions(this.mDesktopData);
  private dpi: number = 1;
  @State previewScale: number = 1;
  private mDesktopParam: DesktopParam = new DesktopParam();
  private desktopPreviewViewModel: DesktopPreviewViewModel = DesktopPreviewViewModel.getInstance();

  aboutToAppear(): void {
    Log.showInfo(TAG, 'aboutToAppear');
    this.mDesktopParam = this.desktopPreviewViewModel.getDesktopParam();
    this.desktopPreviewViewModel.dealWantParams(this.pageInfos);
    if (DesktopPreviewRdbManager.getInstance().getIsLoadFinishState()) {
      this.mDesktopData = DesktopPreviewRdbManager.getInstance().queryFirstScreenData();
      this.gridOptions = GridLayoutOptionUtil.getGridLayoutOptions(this.mDesktopData);
    } else {
      DesktopPreviewRdbManager.getInstance().registerLoadFinishState((desktopPreviewData: GridLayoutItemInfo[]) => {
        this.mDesktopData = desktopPreviewData;
        this.gridOptions = GridLayoutOptionUtil.getGridLayoutOptions(this.mDesktopData);
      });
    }
    try {
      this.dpi = display.getDefaultDisplaySync().densityPixels;
    } catch (error) {
      Log.showError(TAG, `get dpi with error: ${error.message}`);
    }
    if (this.dpi) {
      this.previewScale = this.mDesktopParam.vp2pxScale / this.dpi;
      Log.showInfo(TAG, `dpi:${this.dpi}, previewScale:${this.previewScale}`);
    }
  }

  aboutToDisappear(): void {
    DesktopPreviewRdbManager.getInstance().unRegisterLoadFinishState();
    Log.showInfo(TAG, 'aboutToDisappear');
  }

  @Builder
  gridItem() {
    ForEach(this.mDesktopData, (item: GridLayoutItemInfo) => {
      GridItem() {
        if (item.typeId === CommonConstants.TYPE_APP || item.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
          AppIconPreview({
            mAppItem: item,
          });
        } else if (item.typeId === CommonConstants.TYPE_CARD) {
          FormItemPreview({
            mFormItem: item,
          })
        } else if (item.typeId === CommonConstants.TYPE_FOLDER) {
          FolderItem({
            mFolderItem: item,
          })
        } else if (item.typeId === CommonConstants.TYPE_FORM_STACK &&
          this.desktopPreviewViewModel.isFormStackValid(item)) {
          FormStackPreview({
            mFormStackItem: item as object as FormStackItemInfo
          })
        }
      }
      .padding(DeviceHelper.isPhone() ? {
        top: this.mDesktopParam.itemPadding,
        bottom: this.mDesktopParam.itemPadding
      } : this.mDesktopParam.itemPadding - FeatureConstants.BORDER_WIDTH)
    })
  }

  @Builder
  mainContent() {
    Stack({ alignContent: Alignment.Top }) {
      EffectComponent() {
        Grid(undefined, this.gridOptions) {
          this.gridItem()
        }
        .enabled(false)
        .columnsTemplate(DesktopPreviewViewModel.getInstance().getColumnTemplate())
        .rowsTemplate(DesktopPreviewViewModel.getInstance().getRowTemplate())
        .columnsGap(this.mDesktopParam.columnGaps)
        .rowsGap(this.mDesktopParam.rowGaps)
        .width(this.mDesktopParam.gridWidth)
        .height(this.mDesktopParam.gridHeight)
      }
      .margin({top: this.mDesktopParam.gridMarginTop})
      .backgroundEffect({
        radius: this.mDesktopParam.enableBlur ? ResUtils.getNumber($r('app.float.ohos_id_blur_style_thin_radius')) : 0,
        saturation: this.mDesktopParam.enableBlur ?
        ResUtils.getNumber($r('app.float.ohos_id_blur_style_thin_saturation')) : 0,
        brightness: this.mDesktopParam.enableBrightness ? this.mDesktopParam.backgroundBrightness : 0,
        color: $r('app.color.back_plane_bg_color')
      }, { disableSystemAdaptation: true })
    }
    .scale({
      x: this.previewScale,
      y: this.previewScale,
      centerX:'50%',
      centerY:'0%'
    })
    .width(this.mDesktopParam.workSpaceWidth)
    .height(this.mDesktopParam.workSpaceHeight)
  }

  build() {
    NavDestination() {
      this.mainContent()
    }
    .onBackPressed(() => {
      this.pageInfos.pop(true);
      return true;
    })
    .hideTitleBar(true)
    .backgroundColor('#00000000')
  }
}

@Component
struct FolderItem {
  @State folderItemData: FolderItemData = new FolderItemData();
  private mFolderItem: GridLayoutItemInfo = new GridLayoutItemInfo();
  private mDesktopParam: DesktopParam = new DesktopParam();

  aboutToAppear(): void {
    Log.showInfo(TAG, 'folderItem aboutToAppear');
    let desktopPreviewViewModel: DesktopPreviewViewModel = DesktopPreviewViewModel.getInstance();
    this.mDesktopParam = desktopPreviewViewModel.getDesktopParam();
    desktopPreviewViewModel.initFolderData(this.folderItemData, this.mFolderItem);
  }

  @Builder
  folder() {
    Stack() {
      if (this.folderItemData.isSmallFolder) {
        Column() {
        }
        .borderRadius(this.folderItemData.isSmallFolder ? this.mDesktopParam.smallFolderRadius :
          this.mDesktopParam.bigFolderRadius)
        .useEffect(true)
        .backgroundColor($r('app.color.back_plane_bg_color'))
        .brightness(SCBConstants.BACK_PLANE_BRIGHTNESS_DEFAULT)
        .width(this.folderItemData.imageWidth)
        .height(this.folderItemData.imageHeight)
      } else {
        Column() {
        }
        .borderRadius(this.folderItemData.isSmallFolder ? this.mDesktopParam.smallFolderRadius :
          this.mDesktopParam.bigFolderRadius)
        .useEffect(true)
        .backgroundColor($r('app.color.back_plane_bg_color'))
        .width(this.folderItemData.imageWidth)
        .height(this.folderItemData.imageHeight)
      }

      Image(this.folderItemData.imageUri)
        .width(this.folderItemData.imageWidth)
        .height(this.folderItemData.imageHeight)
    }
  }

  build() {
    Column() {
      this.folder()
      NamePreview({ name: this.folderItemData.mFolderName })
    }
    .height('100%')
    .width('100%')
  }
}

@Component
struct AppIconPreview {
  private mAppItem: GridLayoutItemInfo = new GridLayoutItemInfo();

  private mDesktopParam: DesktopParam = new DesktopParam();

  private desktopPreviewViewModel: DesktopPreviewViewModel = DesktopPreviewViewModel.getInstance();

  @State mIconImage: string | PixelMap = '';

  aboutToAppear(): void {
    Log.showInfo(TAG, 'app or shortcut aboutToAppear');
    this.mDesktopParam = this.desktopPreviewViewModel.getDesktopParam();
    this.desktopPreviewViewModel.initIconImage(this.mAppItem).then((iconImage: string | image.PixelMap) => {
      if (iconImage) {
        this.mIconImage = iconImage;
      } else {
        Log.showError(TAG, `get pic error item bundleName: ${this.mAppItem.bundleName}`);
      }
    });
  }

  build() {
    Column() {
      if (this.mAppItem.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
        Image(this.mIconImage)
          .borderRadius(this.mDesktopParam.iconRadius)
          .draggable(false)
          .syncLoad(true)
          .autoResize(false)
          .interpolation(ImageInterpolation.Medium)
          .width(this.mDesktopParam.iconSize)
          .height(this.mDesktopParam.iconSize)
          .sourceSize({
            width: StyleConstants.APP_ICON_SOURCE_SIZE,
            height: StyleConstants.APP_ICON_SOURCE_SIZE
          })
          .backgroundImage(this.desktopPreviewViewModel.getShortcutBackgroundImage(this.mAppItem.bundleName))
          .backgroundImageSize(ImageSize.Cover)
          .backgroundImagePosition(Alignment.Center)
      } else {
        Image(this.mIconImage)
          .borderRadius(this.mDesktopParam.iconRadius)
          .width(this.mDesktopParam.iconSize)
          .height(this.mDesktopParam.iconSize)
          .sourceSize({
            width: StyleConstants.APP_ICON_SOURCE_SIZE,
            height: StyleConstants.APP_ICON_SOURCE_SIZE
          })
          .shadow(DeviceHelper.isBarPhone() ? {
            radius: StyleConstants.APP_ICON_SHADOW_RADIUS,
            color: StyleConstants.APP_ICON_SHADOW_COLOR,
            offsetY: StyleConstants.APP_ICON_SHADOW_OFFSETY
          } : null)
      }

      NamePreview({ name: this.mAppItem.appName })
    }
    .height('100%')
    .width('100%')
  }
}

@Component
struct FormStackPreview {
  private mFormStackItem: FormStackItemInfo = new FormStackItemInfo();

  private mDesktopParam: DesktopParam = new DesktopParam();

  @State stackData: StackData = new StackData();

  aboutToAppear(): void {
    Log.showWarn(TAG, 'formStackPreview aboutToAppear');
    let desktopPreviewViewModel: DesktopPreviewViewModel = DesktopPreviewViewModel.getInstance();
    this.mDesktopParam = desktopPreviewViewModel.getDesktopParam();
    desktopPreviewViewModel.initStackData(this.stackData, this.mFormStackItem);
  }

  build() {
    Column() {
      Stack({ alignContent: Alignment.Bottom }) {
        Column() {
        }
        .width(`${Math.floor(vp2px(this.stackData.width))}px`)
        .height(`${Math.floor(vp2px(this.stackData.height))}px`)
        .backgroundColor(this.mDesktopParam.curColorMode === 0 ? '#e67e7f80' : '#FFD7D8D9')
        .offset({ x: 0, y: -FormStackStyleConstants.BOTTOM_CARD_OFFSET })
        .borderRadius(this.stackData.radius * FormStackStyleConstants.CARD_BORDER_RADIUS_RATIO)
        .opacity(0.9)
        .scale({
          x: this.stackData.formRatio,
          y: this.stackData.formRatio,
          centerY: '0%'
        })
        FormItemPreview({
          mFormItem: this.mFormStackItem.layoutInfo[0][this.stackData.size - 1] as object as GridLayoutItemInfo,
          mIsShowName: false
        })
      }
      .width(this.stackData.width)
      .height(this.stackData.height)

      NamePreview({ name: this.stackData.name })
    }
    .height('100%')
    .width('100%')
  }
}

@Component
struct FormItemPreview {
  @State formItemData: FormItemData = new FormItemData();

  private mFormItem: GridLayoutItemInfo = new GridLayoutItemInfo();

  private desktopPreviewViewModel: DesktopPreviewViewModel = DesktopPreviewViewModel.getInstance();

  private mIsShowName: boolean = true;

  private shadowStyle: ShadowOptions = {
    radius: StyleConstants.FORM_SHADOW_RADIUS,
    color: StyleConstants.FORM_SHADOW_COLOR,
    offsetY: StyleConstants.FORM_SHADOW_OFFSETY
  };

  aboutToAppear(): void {
    Log.showWarn(TAG, 'card aboutToAppear');
    this.desktopPreviewViewModel.initFormData(this.mFormItem, this.formItemData, this.mIsShowName);
  }

  aboutToDisappear(): void {
    let cardId: string = '0';
    if (this.mFormItem && this.mFormItem.cardId) {
      cardId = this.mFormItem.cardId;
    }
    if (cardId && cardId !== '0') {
      FormManager.getInstance().deleteCard(cardId);
    } else {
      Log.showWarn(TAG, 'invalid id cardId, do nothing!');
    }
  }

  build() {
    Column() {
      FormComponent({
        id: this.mFormItem.cardId,
        name: this.mFormItem.cardName as string,
        bundle: this.mFormItem.bundleName as string,
        ability: this.mFormItem.abilityName as string,
        module: this.mFormItem.moduleName as string,
        dimension: this.mFormItem.cardDimension,
        want: this.desktopPreviewViewModel.buildWantParam(this.mFormItem)
      })
        .size({ width: this.formItemData.width, height: this.formItemData.height })
        .borderRadius(this.formItemData.radius)
        .shadow(PreviewUtils.isFormSupportShadow(this.mFormItem) ? this.shadowStyle : null)
        .onError(async (error) => {
          Log.showInfo(TAG, `FormItemPreview error msg: ${error.msg}, cardId is: ${this.mFormItem.cardId}`);
        }).onAcquired((form: FormCallbackInfo) => {
        Log.showInfo(TAG, `FormComponent card id is: ${JSON.stringify(form)}`);
        this.mFormItem.cardId = form.idString;
        this.desktopPreviewViewModel.addClockCardId(form.idString);
      })
      if (!this.mFormItem.isTransparent && this.mIsShowName) {
        NamePreview({ name: this.formItemData.name })
      }
    }
    .margin({ top: this.formItemData.formMarginTop })
    .height('100%')
    .width('100%')
  }
}

@Component
struct NamePreview{
  private desktopPreviewViewModel: DesktopPreviewViewModel = DesktopPreviewViewModel.getInstance();
  private mDesktopParam: DesktopParam = this.desktopPreviewViewModel.getDesktopParam();
  @Prop name: string = '';

  // 该方法跟桌面保持一致
  private getAppNameLength(str: string): number {
    let strlen = 0;
    if (!str) {
      return strlen;
    }
    for (let i = 0; i < str.length; i++) {
      if (str.charCodeAt(i) > 255) {
        strlen += 2;
      } else {
        strlen++;
      }
    }
    return strlen;
  }

  build() {
    if (this.mDesktopParam.isShowName) {
      Text(this.name)
        .draggable(false)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .textAlign(TextAlign.Center)
        .clip(true)
        .padding({
          left: this.getAppNameLength(this.name) >= SHADOW_NAME_MAX_LENGTH ? 0 :
          PresetStyleConstants.DEFAULT_DESKTOP_NAME_PADDING,
          right: this.getAppNameLength(this.name) >= SHADOW_NAME_MAX_LENGTH ? 0 :
          PresetStyleConstants.DEFAULT_DESKTOP_NAME_PADDING
        })
        .maxLines(this.mDesktopParam.nameLines)
        .fontSize(this.desktopPreviewViewModel.getScaleSize(this.mDesktopParam.nameSize))
        .margin({top: this.desktopPreviewViewModel.getScaleSize(this.mDesktopParam.nameMarginTop)})
        .fontColor(this.mDesktopParam.nameFontColor)
        .fontWeight(FontWeight.Normal)
    }
  }
}