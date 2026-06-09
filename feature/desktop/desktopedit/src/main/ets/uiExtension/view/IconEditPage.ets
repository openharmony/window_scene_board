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

import common from '@ohos.app.ability.common';
import curves from '@ohos.curves';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { ResUtils } from '@ohos/windowscene';
import { settings } from '@kit.BasicServicesKit';
import {
  CommonConstants,
  vibratorMgr,
  PresetStyleConstants,
  ShowNameState,
  EditModeUtils,
  StyleConstants,
  ColorUtil,
  LayoutViewModel,
  DesktopParam,
  EditModeConstants,
} from '@ohos/launchercommon';
import IconEditPageConstants from '../../default/common/constants/IconEditPageConstants';
import { IconChangeSizeData } from '../../default/data/IconChangeSizeData';
import { AppInfo } from '../../default/common/constants/EditModeConstants';
import { NavigationUtil } from '../../default/utils/NavigationUtil';
import { SmallWindowUtil } from '../../default/utils/SmallWindowUtil';
import {
  iconEditViewModel,
  IconEditShowManager,
  IconEditProperty,
  IconScaleModifier
} from '../viewmodel/IconEditViewModel';
import { PreviewPathData } from '../../default/data/PreviewPathData';
import { LengthMetrics } from '@kit.ArkUI';

// 折叠屏展开态横屏图标间列间距，与HorizontalFoldPhoneLayoutRulesController保持一致
const SPACE_OF_COLUMN = StyleConstants.DEFAULT_FOLD_PHONE_EXPANDED_LANDSCAPE_COLUMN_GAP;

const TAG: string = 'IconEditPage';
const DARK_COLOR: string = '#DBFFFFFF';
const LIGHT_COLOR: string = '#E5000000';
const DARK_BACK_COLOR: string = '#19FFFFFF';
const LIGHT_BACK_COLOR: string = '#0C000000';
const MIN_PAGE_COUNT: number = 1;
const LOADING_PROGRESS_WIDTH: number = 40;
const DIALOG_HEIGHT: number = 96;
const DIALOG_PADDING_SIZE: number = 24;
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const IS_PAD: boolean = DeviceHelper.isPad();
const IS_PHONE: boolean = DeviceHelper.isPhone();
const DIALOG_OFFSET: number = 0;
const SETTING_WINDOW_MOD: string = 'settings.windowMode';
const SMALL_WINDOW_DELAY_TIME = 500;
/**
 * 图标编辑页面
 */
@Component
export default struct IconEditPage {
  @Consume('pageInfos') pageInfos: NavPathStack;
  @State showNameState: ShowNameState = iconEditViewModel.getShowNameState();
  @State previewPathData: PreviewPathData = iconEditViewModel.getPreviewPathData();
  @State iconPaths: string[] = [];
  @State iconEditShowManager: IconEditShowManager = iconEditViewModel.iconEditShowManager;
  @State isApplying: boolean = false;
  @State iconEditProperty: IconEditProperty = iconEditViewModel.iconEditProperty;
  @State iconRadius: number = 0;
  private appNameTopMargin: number = 0;
  private uiContext: common.UIAbilityContext = getContext() as common.UIAbilityContext;
  private mDesktopParam: DesktopParam = new DesktopParam();
  private isTriFoldAllExpanded: boolean = DeviceHelper
    .isSecondaryFoldablePhoneExpandStatus(DeviceHelper.getFoldStatus());
  private isFromSettings: boolean = AppStorage.get('from') === 'desktopSettings';
  private loadingController: CustomDialogController = new CustomDialogController({
    builder: LoadingDialog({
      fontSizeScale: this.mDesktopParam.fontSizeScale,
      isTriFoldAllExpanded: this.isTriFoldAllExpanded
    }),
    alignment: DialogAlignment.Center,
    offset: { dx: 0, dy: DIALOG_OFFSET },
    customStyle: true,
    autoCancel: false,
    maskColor: $r('sys.color.ohos_id_color_mask_thin'),
  });
  private spaceOfScreenSide: number = 0;
  private hasReturn: boolean = false;

  private windowStatusChangeCallback = (): void => {
    if (this.hasReturn) {
      return;
    }
    if (SmallWindowUtil.checkWindowSmall()) {
      log.showInfo('windowStatusChange');
      this.hasReturn = true;
      SmallWindowUtil.showToast();
      setTimeout(() => {
        NavigationUtil.doPageBack();
      }, SMALL_WINDOW_DELAY_TIME);
    }
  };

  aboutToAppear(): void {
    // 防止没有发送showEvent、appear设置isShow为true进行兜底
    log.showInfo(`aboutToAppear, isFromSettings: ${this.isFromSettings}`);
    iconEditViewModel.appearToShow();
    iconEditViewModel.registerDisplayChangeCallback();
    this.mDesktopParam = iconEditViewModel.dealDesktopParam(this.pageInfos);
    iconEditViewModel.initThemeResource(this.mDesktopParam.iconPath).then((iconPaths: string[]) => {
      this.iconPaths = iconPaths;
    })
    this.spaceOfScreenSide = iconEditViewModel.getSpaceOfScreenSize(this.mDesktopParam);
    iconEditViewModel.initDeviceInfo(DeviceHelper.isPhone(), IS_PAD, DeviceHelper.isLandscape(),
      EditModeUtils.isBigFoldExpandedOrHalf(), this.isTriFoldAllExpanded);
    iconEditViewModel.createPixmap();
    this.iconRadius = iconEditViewModel.getIconRadius();
    this.appNameTopMargin = iconEditViewModel.getIgnoreShowZoomSize(this.mDesktopParam.nameMarginTop);
    try {
      // 监听屏幕状态变化
      settings.registerKeyObserver(getContext(), SETTING_WINDOW_MOD, settings.domainName.DEVICE_SHARED,
        this.windowStatusChangeCallback);
    } catch(e) {
      log.showWarn(`registerKeyObserver fail`);
    }
  }

  aboutToDisappear(): void {
    log.showInfo(`aboutToDisAppear`);
    iconEditViewModel.unregisterDisplayChangeCallback();
    try {
      settings.unregisterKeyObserver(getContext(), SETTING_WINDOW_MOD, settings.domainName.DEVICE_SHARED);
    } catch(e) {
      log.showWarn(`unregisterKeyObserver fail`);
    }
  }

  @Builder
  createIcon(type: string, rowIndex: number, columnIndex: number, totalLength: number) {
    Column() {
      if (this.iconEditShowManager.isShow) {
        FakeIcon({
          iconSize: this.mDesktopParam.iconSize,
          appNameTopMargin: this.appNameTopMargin,
          radiusSize: this.iconRadius,
          appInfo: iconEditViewModel.getAppInfo(type),
          isShowName: this.showNameState.isShowName(),
          textColor: this.mDesktopParam.nameFontColor,
          path: this.previewPathData.getPreviewPath(),
          fontSizeScale: this.mDesktopParam.fontSizeScale,
          // 名称在第几列，与桌面命名规则保持一致，考虑到有占据偶数列的图标，其名称居中后正好处于两个colIndex之间，
          // 因此将列数乘以2，以便于标明占据偶数列的图标居中显示的名称
          col: columnIndex * 2,
          // 名称在第几行，与桌面命名规则保持一致，从第一行开始，由于rowIndex从0开始，因此将rowIndex加一
          row: rowIndex + 1,
          mDesktopParam: this.mDesktopParam,
        })
        .transition(
          TransitionEffect.asymmetric(
            TransitionEffect.OPACITY.combine(TransitionEffect.scale({ x: 0.75, y: 0.75 })).animation({
              duration: 350,
              delay: 150,
              curve: curves.cubicBezierCurve(0.2, 0, 0.2, 1),
            }),
            TransitionEffect.OPACITY.animation({
              duration: 150,
              curve: curves.cubicBezierCurve(0.2, 0, 0.2, 1),
            }).combine(TransitionEffect.scale({ x: 0.75, y: 0.75 })).animation({
              duration: 350,
              delay: 150,
              curve: curves.cubicBezierCurve(0.2, 0, 0.2, 1),
            }),
          )
        )
      }
    }
    .align(Alignment.Center)
    .justifyContent(this.mDesktopParam.isSimpleMode ? FlexAlign.Center : FlexAlign.Start)
    .width(iconEditViewModel.vpToPx((this.mDesktopParam.gridWidth / this.mDesktopParam.columns)))
    .height(iconEditViewModel.vpToPx(this.mDesktopParam.gridHeight / this.mDesktopParam.rows))
    .padding({
      top: this.mDesktopParam.itemPadding,
      bottom: this.mDesktopParam.itemPadding,
    })
    .margin(iconEditViewModel.getScreenMargin(columnIndex, totalLength))
  }

  @Builder
  previewContentRow(rowArr: string[], rowIndex: number) {
    Row() {
      ForEach(rowArr, (row: string, index: number) => {
        this.createIcon(row, rowIndex, index, rowArr.length)
      })
    }
  }

  @Builder
  previewContent() {
    Column() {
      Column() {
        ForEach(iconEditViewModel.getIconArray(this.mDesktopParam.rows,
          this.mDesktopParam.columns), (rowArr: string[], index: number) => {
            this.previewContentRow(rowArr, index);
        })
      }
      .width('100%')
      .alignItems(HorizontalAlign.Center)
    }
    .flexGrow(1)
    .justifyContent(FlexAlign.Center)
  }

  @Builder
  sheetContent() {
    Column() {
      Column({ space: IconEditPageConstants.BOTTOMSHEET_LABEL_MARGIN }) {
        // 图标大小
        IconSizeComponent({
          min: IconEditPageConstants.APP_IMAGE_SIZE_MIN,
          max: IconEditPageConstants.APP_IMAGE_SIZE_MAX,
          step: IconEditPageConstants.APP_IMAGE_SIZE_STEP,
          defaultValue: IconEditPageConstants.APP_IMAGE_SIZE_DEFAULT,
          fontSizeScale: this.mDesktopParam.fontSizeScale,
        })
        // 显示名称
        this.showNameBuilder()
      }
      .margin({ top: IconEditPageConstants.ICONSTYLE_BUTTON_LABEL_MARGIN })
      // 应用按钮
      this.applyButtonBuilder()
    }
    .padding({
      left: IconEditPageConstants.BOTTOMSHEET_LABEL_PADDING,
      right: IconEditPageConstants.BOTTOMSHEET_LABEL_PADDING
    })
    .clip(true)
    .width(iconEditViewModel.getBottomSheetWidth(this.mDesktopParam))
  }

  @Builder
  iconEditPlaceholder() {
    Column() {
      Column() {
        Column() {
          this.bindSheetTitle()
        }.padding({ // 模拟bindSheet header自带的padding
          top: IconEditPageConstants.ICONSTYLE_BUTTON_LABEL_MARGIN,
          bottom: IconEditPageConstants.ICONSTYLE_BUTTON_LABEL_MARGIN
        })

      }.padding({
        top: IconEditPageConstants.BOTTOMSHEET_HEADER_MARGIN_BOTTOM,
        bottom: this.mDesktopParam.fontSizeScale > 1 ? IconEditPageConstants.BIND_SHEET_TITLE_PADDING : 0
      })
      this.sheetContent()
    }
    .id('iconEditPlaceholder')
    .opacity(0)
  }

  @Builder
  applyButtonBuilder() {
    Row() {
      Button() {
        Text($r('app.string.apply'))
          .fontSize(EditModeUtils.getScaleSize($r('sys.float.ohos_id_text_size_body1'), this.mDesktopParam.fontSizeScale))
          .fontColor($r('sys.color.ohos_id_color_text_primary_contrary'))
          .fontWeight(FontWeight.Medium)
      }
      .buttonStyle(ButtonStyleMode.EMPHASIZED)
      .padding({
        top: IconEditPageConstants.APPLY_BUTTON_PADDING,
        bottom: IconEditPageConstants.APPLY_BUTTON_PADDING
      })
      .id('icon_edit_apply_button')
      .width(iconEditViewModel.getApplyButtonWidth(this.mDesktopParam))
      .onClick(() => {
        this.isApplying = true;
        iconEditViewModel.apply(this.mDesktopParam, this.uiContext, this.loadingController,
          () => iconEditViewModel.backAnimation());
      })
    }
    .margin({
      top: IconEditPageConstants.APPLY_BUTTON_MARGIN_TOP,
      bottom: IconEditPageConstants.APPLY_BUTTON_MARGIN_BOTTOM
    })
  }

  @Builder
  iconStyleBuilder() {
    Row() {
      Text($r('app.string.icon_style'))
        .fontWeight(FontWeight.Medium)
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .fontSize(EditModeUtils.getScaleSize($r('sys.float.ohos_id_text_size_body1'), this.mDesktopParam.fontSizeScale))
        .margin({
          left: IconEditPageConstants.BOTTOMSHEET_LABEL_MARGIN,
          top: IconEditPageConstants.BOTTOM_SHEET_LABEL_INNER_MARGIN,
          bottom: IconEditPageConstants.BOTTOMSHEET_HEADER_MARGIN_BOTTOM
        })
    }
    .width('100%')
    .alignItems(VerticalAlign.Bottom)
    .justifyContent(FlexAlign.Start)

    Row({ space: IconEditPageConstants.ICON_STYLE_SCROLL_SPACE }) {
      ForEach(this.iconPaths, (path: string, index: number) => {
        IconStyleButton({
          path: path,
          index: index,
          isDarkMode: this.mDesktopParam.isDarkMode
        })
      })
    }
    .width('100%')
    .justifyContent(FlexAlign.Start)
    .height(IconEditPageConstants.ICON_STYLE_BUTTON_SIZE)
    .margin({
      top: IconEditPageConstants.ICONSTYLE_BUTTON_LABEL_MARGIN_TOP,
      bottom: IconEditPageConstants.ICONSTYLE_BUTTON_LABEL_MARGIN,
      left: IconEditPageConstants.ICONSTYLE_BUTTON_LABEL_MARGIN,
      right: IconEditPageConstants.ICONSTYLE_BUTTON_LABEL_MARGIN
    })
  }

  @Builder
  showNameBuilder() {
    Column() {
      Flex({
        direction: FlexDirection.Row,
        justifyContent: FlexAlign.SpaceBetween,
        alignItems: ItemAlign.Center
      }) {
        Text($r('app.string.show_app_name'))
          .fontWeight(FontWeight.Medium)
          .fontColor($r('sys.color.ohos_id_color_text_primary'))
          .fontSize(iconEditViewModel.getScaleSize($r('sys.float.ohos_id_text_size_body1'), this.mDesktopParam.fontSizeScale))
          .margin({
            left: IconEditPageConstants.BOTTOMSHEET_LABEL_MARGIN,
            right: IconEditPageConstants.BOTTOMSHEET_LABEL_MARGIN
          })

        Toggle({ type: ToggleType.Switch, isOn: this.showNameState.isShowName() })
          .hoverEffect(HoverEffect.None)
          .onChange((isOn: boolean) => {
            this.showNameState.setIsShowName(isOn);
          })
          .margin({
            left: IconEditPageConstants.BOTTOMSHEET_LABEL_MARGIN,
            right: IconEditPageConstants.BOTTOMSHEET_LABEL_MARGIN
          })
          .width(IconEditPageConstants.BOTTOMSHEET_TOGGLE_WIDTH)
          .height(IconEditPageConstants.BOTTOMSHEET_TOGGLE_HEIGHT)
      }
      .margin({
        top: IconEditPageConstants.PREVIEW_ICONS_MARGIN_BOTTOM,
        bottom: IconEditPageConstants.PREVIEW_ICONS_MARGIN_BOTTOM
      })
    }
    .borderRadius($r('sys.float.ohos_id_corner_radius_default_l'))
    .backgroundColor($r('sys.color.ohos_id_color_card_bg'))
  }

  @Builder
  titleContent() {
    Text($r('app.string.icon'))
      .fontColor($r('sys.color.ohos_id_color_text_primary'))
      .fontSize($r('sys.float.ohos_id_text_size_headline8'))
      .fontWeight(FontWeight.Bold)
      .fontFamily('HarmonyHeiTi-Medium')
      .textOverflow({ overflow: TextOverflow.Ellipsis })
  }

  @Builder
  bindSheetTitle() {
    Row() {
      this.titleContent()
    }
    .width('100%')
    .justifyContent(FlexAlign.Start)
  }

  build() {
    NavDestination() {
      Stack() {
        if (this.isFromSettings) {
          Image(iconEditViewModel.getWallPaper())
            .draggable(false)
            .height('100%')
            .width('100%')
            .visibility(this.iconEditProperty.isWallpaperReady ? Visibility.Visible : Visibility.Hidden)
            .transition(
              TransitionEffect.asymmetric(
                TransitionEffect.OPACITY.animation({
                  duration: 350,
                  delay: 150,
                  curve: curves.cubicBezierCurve(0.2, 0, 0.2, 1),
                }),
                TransitionEffect.OPACITY.animation({
                  duration: 150,
                  curve: curves.cubicBezierCurve(0.2, 0, 0.2, 1),
                }),
              )
            )
        }
        Column() {
          // 预览部分
          this.previewContent()

          // 占位元素
          this.iconEditPlaceholder()
        }
        .height('100%')
        .justifyContent(FlexAlign.SpaceBetween)
        .accessibilityLevel('no-hide-descendants')
      }
    }
    .backgroundColor(Color.Transparent)
    .hideTitleBar(true)
    .bindSheet(this.iconEditShowManager.isShowBindSheet, this.sheetContent(), {
      title: this.bindSheetTitle,
      preferType: SheetType.BOTTOM,
      height: SheetSize.FIT_CONTENT,
      enableOutsideInteractive: true,
      width: iconEditViewModel.getBottomSheetWidth(this.mDesktopParam) as number,
      showClose: true,
      onWillDisappear: () => {
        if (!this.isApplying) {
          this.isApplying = false;
          iconEditViewModel.backAnimation();
          NavigationUtil.doPageBack();
        }
      },
    })
  }
}

@Component
struct IconStyleButton {
  @State previewPathData: PreviewPathData = iconEditViewModel.getPreviewPathData();
  private path: string = '';
  private index: number = 0;
  private isDarkMode: boolean = false;

  @Builder
  getIcons() {
    Column({ space: IconEditPageConstants.ICON_STYLE_BUTTON_INNER_MARGIN }) {
      Row({ space: IconEditPageConstants.ICON_STYLE_BUTTON_INNER_MARGIN }) {
        FakeIcon({
          iconSize: IconEditPageConstants.ICON_STYLE_BUTTON_INNER_ICON_SIZE,
          radiusSize: IconEditPageConstants.ICON_STYLE_BUTTON_INNER_RADIUS,
          path: this.path,
          appInfo: iconEditViewModel.getAppInfo('settings'),
          isIconStyle: true,
        })

        FakeIcon({
          iconSize: IconEditPageConstants.ICON_STYLE_BUTTON_INNER_ICON_SIZE,
          radiusSize: IconEditPageConstants.ICON_STYLE_BUTTON_INNER_RADIUS,
          path: this.path,
          appInfo: iconEditViewModel.getAppInfo('clock'),
          isIconStyle: true,
        })
      }
      .height(IconEditPageConstants.ICON_STYLE_BUTTON_INNER_ICON_SIZE)

      Row({ space: IconEditPageConstants.ICON_STYLE_BUTTON_INNER_MARGIN }) {
        FakeIcon({
          iconSize: IconEditPageConstants.ICON_STYLE_BUTTON_INNER_ICON_SIZE,
          radiusSize: IconEditPageConstants.ICON_STYLE_BUTTON_INNER_RADIUS,
          path: this.path,
          appInfo: iconEditViewModel.getAppInfo('gallery'),
          isIconStyle: true,
        })

        FakeIcon({
          iconSize: IconEditPageConstants.ICON_STYLE_BUTTON_INNER_ICON_SIZE,
          radiusSize: IconEditPageConstants.ICON_STYLE_BUTTON_INNER_RADIUS,
          path: this.path,
          appInfo: iconEditViewModel.getAppInfo('camera'),
          isIconStyle: true,
        })
      }
      .height(IconEditPageConstants.ICON_STYLE_BUTTON_INNER_ICON_SIZE)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }

  build() {
    Stack() {
      this.getIcons();
      if (this.path === this.previewPathData.getPreviewPath()) {
        Checkbox()
          .select(true)
          .width(IconEditPageConstants.ICON_EDIT_CHECKBOX_SIZE)
          .height(IconEditPageConstants.ICON_EDIT_CHECKBOX_SIZE)
          .margin({
            right: IconEditPageConstants.ICON_EDIT_CHECKBOX_MARGIN_RIGHT,
            bottom: IconEditPageConstants.ICON_EDIT_CHECKBOX_MARGIN_RIGHT
          })
      }
    }
    .align(Alignment.BottomEnd)
    .height(IconEditPageConstants.ICON_STYLE_BUTTON_SIZE)
    .width(IconEditPageConstants.ICON_STYLE_BUTTON_SIZE)
    .borderRadius($r('sys.float.ohos_id_corner_radius_default_l'))
    .backgroundColor(this.isDarkMode ? $r('sys.color.ohos_id_color_card_bg') :
      $r('app.color.icon_style_button_bg_color'))
    .borderWidth(this.path === this.previewPathData.getPreviewPath() ?
      IconEditPageConstants.ICON_STYLE_BUTTON_BORDER_WIDTH : 0)
    .borderColor($r('sys.color.ohos_id_color_emphasize'))
    .accessibilityText(ResUtils.getInnerString($r('app.string.icon_style')) + (this.index + 1) +
      (this.path === this.previewPathData.getPreviewPath() ? ResUtils.getInnerString($r('app.string.selected')) : ''))
    .onClick(() => {
      log.showInfo('IconStyleButton onClick index: %{public}s', this.index);
      this.previewPathData.setPreviewPath(this.path);
    })
  }
}

@Component
struct IconSizeComponent {
  @State iconChangeSizeData: IconChangeSizeData = iconEditViewModel.getIconChangeSizeData();
  private defaultValue: number = IconEditPageConstants.APP_IMAGE_SIZE_DEFAULT;
  @State slideDefaultLeft: number = 0;
  private fontSizeScale: number = 1;
  // 滑动条双向绑定用
  @State sliderValue: number = this.iconChangeSizeData.getIconChangeSize();
  // 当前图标大小对应的文本资源
  @State iconEditProperty: IconEditProperty = iconEditViewModel.iconEditProperty;
  private min: number = 0;
  private max: number = 0;
  private step: number = 0.01;

  aboutToAppear(): void {
    iconEditViewModel.initIconSize(this.defaultValue);
  }

  @Builder
  getSlider() {
    Stack() {
      Circle()
        .width(IconEditPageConstants.APP_IMAGE_CIRCLE_SIZE)
        .height(IconEditPageConstants.APP_IMAGE_CIRCLE_SIZE)
        .fill($r('sys.color.ohos_id_color_foreground'))
        .opacity(0.1)
        .position({
          x: this.slideDefaultLeft,
          y: (IconEditPageConstants.SLIDER_SLIDER_HEIGHT - IconEditPageConstants.APP_IMAGE_CIRCLE_SIZE) / 2
        })

      Slider({
        value: $$this.sliderValue,
        max: this.max,
        min: this.min,
        step: this.step,
        style: SliderStyle.InSet
      })
        .onChange(async (value: number, mode: SliderChangeMode) => {
          iconEditViewModel.onIconSizeSliderChange(value, mode);
        })
        .width('100%')
        .onSizeChange((oldValue: SizeOptions, newValue: SizeOptions) => {
          this.slideDefaultLeft = iconEditViewModel.onIconSizeSliderSizeChange(oldValue, newValue, this.min, this.max);
        })
    }
    .margin({
      left: IconEditPageConstants.CUSTOMSLIDER_SLIDER_MARGIN,
      right: IconEditPageConstants.CUSTOMSLIDER_SLIDER_MARGIN,
      bottom: IconEditPageConstants.CUSTOMSLIDER_SLIDER_MARGIN_BOTTOM,
      top: IconEditPageConstants.APP_IMAGE_CIRCLE_SIZE
    })
    .height(IconEditPageConstants.SLIDER_SLIDER_HEIGHT)
  }

  build() {
    Column() {
      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        Text($r('app.string.icon_size'))
          .fontWeight(FontWeight.Medium)
          .fontColor($r('sys.color.ohos_id_color_text_primary'))
          .fontSize(iconEditViewModel.getScaleSize($r('sys.float.ohos_id_text_size_body1'), this.fontSizeScale))
        Text(this.iconEditProperty.iconSizeOffsetDescription)
          .fontWeight(FontWeight.Regular)
          .fontSize(iconEditViewModel.getScaleSize($r('sys.float.ohos_id_text_size_body2'), this.fontSizeScale))
          .fontColor($r('sys.color.ohos_id_color_text_secondary'))
      }
      .padding({
        left: IconEditPageConstants.BOTTOMSHEET_LABEL_MARGIN,
        right: IconEditPageConstants.BOTTOMSHEET_LABEL_MARGIN,
        top: IconEditPageConstants.PREVIEW_ICONS_SIZE_TEXT_PADDING,
        bottom: IconEditPageConstants.PREVIEW_ICONS_SIZE_TEXT_PADDING
      })

      this.getSlider()
    }
    .borderRadius($r('sys.float.ohos_id_corner_radius_default_l'))
    .backgroundColor($r('sys.color.ohos_id_color_card_bg'))
    .padding({
      top: IconEditPageConstants.APP_IMAGE_CIRCLE_SIZE
    })
  }
}

@Component
struct FakeIcon {
  @Prop iconSize: number = 0;
  @Prop radiusSize: number = 0;
  @Prop @Watch('createRelativePath') path: string = '';
  @Prop isShowName: boolean = false;
  @State foreUri: string = '';
  @State backUri: string = '';
  @State fontSizeScale: number = 1;
  @StorageProp('wallpaperPixmapExitFlag') @Watch('updateAppNameShadow') isWallpaperPixmapExit: boolean = false;
  @State textShadowOption: ShadowOptions = {
    radius: StyleConstants.APP_NAME_SHADOW_RADIUS,
    color: ColorUtil.convertRGBA2ResourceColor(0, 0, 0, 0),
    fill: true
  };
  private iconShadowStyle: ShadowOptions = {
    radius: StyleConstants.APP_ICON_SHADOW_RADIUS,
    color: StyleConstants.APP_ICON_SHADOW_COLOR,
    offsetY: StyleConstants.APP_ICON_SHADOW_OFFSETY
  };
  private textColor: string = '';
  private appNameTopMargin: number = 0;
  private appInfo: AppInfo = iconEditViewModel.getAppInfo('settings');
  private col: number = 0;
  private row: number = 0;
  private mDesktopParam: DesktopParam = new DesktopParam();
  private isNeedShadowInCurrentWallpaper: boolean = iconEditViewModel.isNeedShadowInSpecialBg(this.mDesktopParam);
  private isIconStyle: boolean = false;
  private changeIconStyle: boolean = false;
  private isAppeared: boolean = false;
  private appNameFontSize: number | string = iconEditViewModel.getAppNameFontSize();
  private iconScaleModifier?: IconScaleModifier;

  aboutToAppear(): void {
    this.iconScaleModifier = new IconScaleModifier(iconEditViewModel.getOriIconScale());
    iconEditViewModel.addIconScaleModifierArr(this.iconScaleModifier);
    this.isAppeared = true;
    this.createRelativePath();
  }

  private createRelativePath(): void {
    let uris: string[] = iconEditViewModel.createRelativePath(this.path, this.appInfo.bundleName);
    this.backUri = uris[0];
    this.foreUri = uris[1];
    this.isNeedShadowInCurrentWallpaper = iconEditViewModel.isNeedShadowInSpecialBg(this.mDesktopParam);
    this.changeIconStyle = !this.changeIconStyle;
  }

  private async updateAppNameShadow(): Promise<void> {
    if (this.isNeedShadowInCurrentWallpaper && this.isWallpaperPixmapExit && this.isAppeared) {
      const refreshColor =
        await iconEditViewModel.updateIconNameShadow(this.appInfo.bundleName, this.row + '_' + this.col);
      animateTo({
        duration: 800,
        curve: Curve.LinearOutSlowIn
      }, () => {
        this.textShadowOption.color = refreshColor;
      });
    }
  }

  @Styles
  basicStyle() {
    .width(iconEditViewModel.vpToPx(this.iconSize))
    .height(iconEditViewModel.vpToPx(this.iconSize))
    .draggable(false)
    .borderRadius(this.radiusSize)
  }

  @Builder
  IconImage(backUri: string, foreUri: string) {
    Stack({ alignContent: Alignment.Center }) {
/*
      Image($r('app.media.ic_public_outer_icon'))
        .basicStyle()
        .interpolation(ImageInterpolation.High)
        .autoResize(false)
        .syncLoad(true)
*/
      Image($r(`app.media.${this.appInfo.bundleName}`))
        .basicStyle()
        .objectFit(ImageFit.Contain)
        .interpolation(ImageInterpolation.Medium)
        .autoResize(false)
        .syncLoad(true)
    }
    .attributeModifier(this.iconScaleModifier)
    .clip(true)
    .width(iconEditViewModel.vpToPx(this.iconSize))
    .height(iconEditViewModel.vpToPx(this.iconSize))
    .shadow((DeviceHelper.isBarPhone() && !this.isIconStyle && !this.mDesktopParam.isOnlineTheme) ?
      this.iconShadowStyle : null)
    // 仅在非预览区域的图标风格上增加描边
    .border({
      radius: this.radiusSize,
      color: this.isIconStyle ? IconEditPageConstants.FAKEICON_ICON_BORDER_COLOR : null,
      width: this.isIconStyle ? IconEditPageConstants.FAKEICON_ICON_BORDER_WIDTH : null
    })
    .transition(
      TransitionEffect.asymmetric(
        TransitionEffect.OPACITY.animation({
          duration: 350,
          curve: Curve.Friction
        }).combine(TransitionEffect.scale({ x: 0.8, y: 0.8 })),
        TransitionEffect.OPACITY.animation({
          duration: 350,
          curve: Curve.Sharp
        }).combine(TransitionEffect.scale({ x: 0.8, y: 0.8 })),
      )
    )
  }

  build() {
    Column() {
      if (this.changeIconStyle) {
        this.IconImage(this.backUri, this.foreUri)
      } else {
        this.IconImage(this.backUri, this.foreUri)
      }

      if (this.isShowName) {
        Text($r(this.appInfo.appName))
          .margin({
            top: this.appNameTopMargin
          })
          .fontSize(this.appNameFontSize)
          .textAlign(TextAlign.Center)
          .maxLines(StyleConstants.DEFAULT_APP_NAME_LINES)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .fontWeight(IS_PHONE ? FontWeight.Normal : FontWeight.Medium)
          .fontColor(this.textColor)
          .id(iconEditViewModel.getEditIconNameId(this.appInfo.bundleName))
          .maxFontScale(EditModeConstants.APP_NAME_MAX_FONT_SIZE_SCALE)
          .shadow((this.mDesktopParam.isNeedAppNameShadow && this.isNeedShadowInCurrentWallpaper) ?
            this.textShadowOption : null)
          .onAppear(async () => {
            this.updateAppNameShadow();
          })
      }
    }
    .id(`icon_${this.appInfo.bundleName}`)
  }
}

@CustomDialog
struct LoadingDialog {
  controller?: CustomDialogController;
  isTriFoldAllExpanded?: boolean;
  @State fontSizeScale: number = 1;

  aboutToDisappear(): void {
    this.controller?.close();
    this.controller = undefined;
  }

  build() {
    Stack() {
      Row() {
        Text($r('app.string.applyIcon'))
          .fontColor($r('sys.color.ohos_id_color_text_primary'))
          .fontSize(EditModeUtils.getScaleSize($r('sys.float.ohos_id_text_size_body1'), this.fontSizeScale))
          .fontWeight(FontWeight.Regular)
        LoadingProgress()
          .width(LOADING_PROGRESS_WIDTH)
      }
      .width('100%')
      .padding(DIALOG_PADDING_SIZE)
      .borderRadius($r('sys.float.ohos_id_corner_radius_dialog'))
      .backgroundColor($r('sys.color.ohos_id_color_mask_thin'))
      .backgroundBlurStyle(BlurStyle.COMPONENT_ULTRA_THICK, { policy: 1 }, { disableSystemAdaptation: true })
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .width(EditModeUtils.isBigFoldExpandedOrHalf() || IS_PAD || this.isTriFoldAllExpanded ?
      IconEditPageConstants.FOLD_PAD_DIALOG_WIDTH : '100%')
    .padding({ left: $r('sys.float.ohos_id_dialog_margin_start'), right: $r('sys.float.ohos_id_dialog_margin_start') })
    .accessibilityLevel('no-hide-descendants')
  }
}