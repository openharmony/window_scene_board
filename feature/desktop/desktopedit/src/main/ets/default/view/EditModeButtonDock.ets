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

import EditModeStyleConstants, { EditModeDockConstants } from '../common/constants/EditModeStyleConstants';
import { SystemParamUtils, GlobalContext, ThemeUtils, AccessibilityManager } from '@ohos/frameworkwrapper';
import { launcherStatusUtil } from '@ohos/windowscene';
import { editModeDockViewModel } from '../viewmodel/EditModeDockViewModel';
import { EditModeState } from '@ohos/launchercommon/src/main/ets/editmode/data/EditModeState';
import {
  editModeManager,
  CommonConstants,
  EditModeUtils,
  StyleConstants,
  LayoutViewModel,
  DesktopParam,
  DesktopManager,
  AppListInfo,
  EventConstants
} from '@ohos/launchercommon';
import { editModeViewManager } from '../manager/EditModeViewManager';
import { EditModeExtensionData } from '../data/EditModeExtensionData';
import { DesktopLayoutState } from '@ohos/launchercommon/src/main/ets/constants/CommonConstants';
import { IconEditWantData } from '../data/IconEditWantData';
import lazy { OuterButtonDockData } from '../data/OuterButtonDockData';
import IconEditPageConstants from '../common/constants/IconEditPageConstants';
import { LengthMetrics } from '@kit.ArkUI';
import { SmallFoldStyleUtil } from '@ohos/launchercommon/src/main/ets/utils/SmallFoldStyleUtil';
import { StateEx } from '@ohos/componenthelper';
import { launcherVisualEffectMgr } from '@ohos/launchercommon/Index';
import { EditModeAccessibilityUtil } from '@ohos/launchercommon/src/main/ets/editmode/utils/EditModeAccessibilityUtil';
import { SingleContext } from '@ohos/basicutils/src/main/ets/utils/SingleManager';

const LIGHT_COLOR: string = '#33000000';
const LIGHT_FONT_COLOR: string = '#E5000000';
const DELAY_PRELOAD_TIME: number = 300;
const BUTTON_ITEM_LIST: ButtonModel[] = [
  {
    key: EditModeDockConstants.WALLPAPER_KEY,
    name: EditModeDockConstants.WALLPAPER_KEY,
    icon: 'picture_fill'
  },
  {
    key: EditModeDockConstants.FORM_SERVICE_KEY,
    name: EditModeDockConstants.FORM_SERVICE_KEY,
    icon: 'service_card_fill'
  },
  {
    key: EditModeDockConstants.ICON_KEY,
    name: EditModeDockConstants.ICON_KEY,
    icon: 'square_fill_grid_2x2'
  },
  {
    key: EditModeDockConstants.THEME_KEY,
    name: EditModeDockConstants.THEME_KEY,
    icon: 'brush_fill'
  },
];

const BUTTON_ITEM_LIST_2D: ButtonModel[] = [
  {
    key: EditModeDockConstants.FORM_SERVICE_KEY,
    name: EditModeDockConstants.FORM_SERVICE_KEY,
    icon: 'service_card_fill'
  },
];

const BUTTON_ITEM_LIST_SIMPLE: ButtonModel[] = [
  {
    key: EditModeDockConstants.WALLPAPER_KEY,
    name: EditModeDockConstants.WALLPAPER_KEY,
    icon: 'picture_fill'
  },
  {
    key: EditModeDockConstants.ICON_KEY,
    name: EditModeDockConstants.ICON_KEY,
    icon: 'square_fill_grid_2x2'
  },
  {
    key: EditModeDockConstants.THEME_KEY,
    name: EditModeDockConstants.THEME_KEY,
    icon: 'brush_fill'
  },
];

const BUTTON_ITEM_LIST_SMALL_FOLD: ButtonModel[] = [
  {
    key: EditModeDockConstants.OUTER_APP_KEY,
    name: EditModeDockConstants.OUTER_APP_KEY,
    icon: 'ic_public_outer_icon'
  },
  {
    key: EditModeDockConstants.FORM_SERVICE_KEY,
    name: EditModeDockConstants.FORM_SERVICE_KEY,
    icon: 'ic_public_card'
  },
  {
    key: EditModeDockConstants.OUTER_THEME_KEY,
    name: EditModeDockConstants.THEME_KEY,
    icon: 'ic_theme'
  },
];

/**
 * 编辑模式按钮组件
 */
@Component
export struct EditModeButtonDock {
  @Prop singleContext?: SingleContext;
  private desktopParam: DesktopParam = DesktopManager.getInstance().updateParam().getDesktopParam();
  @State @Watch('editModeStateChange') editModeState: EditModeState = editModeManager.getEditModeState();
  @State editModeExtensionData: EditModeExtensionData = editModeViewManager.getEditModeExtensionData();
  @State iconEditWantData: IconEditWantData = editModeViewManager.getIconEditWantData();

  /**
   * 编辑模式切换事件
   */
  editModeStateChange(): void {
    if (!this.editModeState.isInEditMode()) {
      editModeDockViewModel.closeFormCenterView();
    }
  }

  getIsVisible(): Visibility {
    return this.editModeExtensionData.isShowUIExtension() &&
      this.iconEditWantData.getExtensionWant()?.abilityName == IconEditPageConstants.EDIT_MODE_ICON_ABILITY_NAME
      ? Visibility.Hidden : Visibility.Visible
  }

  build() {
    Stack() {
      EditModeButtonList()
    }
    .id('EditModeButtonDock')
    .translate({
      y: !launcherStatusUtil.getShowOutLauncherStatus() ? (-this.desktopParam.marginBottomOfIndicator / 2) : 0
    })
    .visibility(this.getIsVisible())
    .transition(
      TransitionEffect.asymmetric(
        TransitionEffect.OPACITY.animation({
          duration: EditModeStyleConstants.DOCK_TRANSITION_DURATION,
          curve: Curve.Friction,
          delay: EditModeStyleConstants.DOCK_TRANSITION_DELAY
        }).combine(TransitionEffect.translate({y: EditModeStyleConstants.DOCK_TRANSLATE_Y})),
        TransitionEffect.OPACITY.animation({
          duration: EditModeStyleConstants.DOCK_TRANSITION_DURATION,
          curve: Curve.Friction
        }).combine(TransitionEffect.translate({y: EditModeStyleConstants.DOCK_TRANSLATE_Y})),
      )
    )
    .height(!launcherStatusUtil.getShowOutLauncherStatus() ? this.desktopParam.dockHeight :
    EditModeDockConstants.OUTER_EDIT_MODE_BUTTON_HEIGHT)
    .width(EditModeStyleConstants.PERCENTAGE_100)
    .alignContent(Alignment.Bottom)
    .onDrop((event: DragEvent, extraParams?: string) => {
      GlobalContext.getContext()?.eventHub.emit(CommonConstants.GRID_SWIPER_DELEGATE_TO_DROP, event, extraParams);
    })
    .onDragMove((event: DragEvent, extraParams?: string) => {
      GlobalContext.getContext()?.eventHub.emit(CommonConstants.GRID_SWIPER_DELEGATE_TO_MOVE, event, extraParams);
    })
  }
}

@Component
struct EditModeButtonList {
  @Prop singleContext?: SingleContext;
  @StorageProp('fontSizeScale') fontSizeScale: number = 1;
  @State iconScales: number[] = [];
  @State buttonOpacity: StateEx<number> = launcherVisualEffectMgr.getEditModeButtonOpacity();
  @State outerButtonDockData: OuterButtonDockData | undefined = editModeViewManager.getOuterButtonDockData();
  private onUpdatePageFocus: Function = (): void => this.updateFirstPageIconId();
  // 监听布局变化修改无障碍走焦点
  @StorageLink('appListInfo') @Watch('updateFirstPageIconId') appListInfo: AppListInfo = new AppListInfo();
  @StorageLink('outerAppListInfo') @Watch('updateFirstPageIconId') outerAppListInfo: AppListInfo = new AppListInfo();
  // 无障碍走焦点
  @State nextFocusId: string = '';

  updateFirstPageIconId() {
    const isAccessibilityMode: boolean = AccessibilityManager.getInstance().getIsAccessibilityMode();
    if (isAccessibilityMode) {
      this.nextFocusId = EditModeAccessibilityUtil.getCurrentPageFirstIconId();
    }
  }

  getButtonItemList(): ButtonModel[] {
    let result: ButtonModel[] = [];
    if (SystemParamUtils.isHddProduct()) {
      result = BUTTON_ITEM_LIST_2D;
    } else if (LayoutViewModel.getInstance(this.singleContext).getDesktopModel() === DesktopLayoutState.SIMPLE_LAUNCHER_MODEL) {
      result = BUTTON_ITEM_LIST_SIMPLE;
    } else if (launcherStatusUtil.getShowOutLauncherStatus()) {
      result = BUTTON_ITEM_LIST_SMALL_FOLD;
    } else {
      result = BUTTON_ITEM_LIST;
    }
    if (this.iconScales.length != result.length) {
      this.iconScales = result.map(() => StyleConstants.DEFAULT_1);
    }
    return result;
  }

  aboutToAppear(): void {
    editModeDockViewModel.updateFontColor();
    setTimeout(() => {
      ThemeUtils.preloadThemeExtAbility(getContext());
      editModeDockViewModel.preloadIconEditPage(EditModeDockConstants.ICON_KEY);
    }, DELAY_PRELOAD_TIME);
    GlobalContext.getContext()?.eventHub.on(EventConstants.EVENT_UPDATE_PAGE_FOCUS, this.onUpdatePageFocus);
    this.getButtonItemList();
  }

  aboutToDisappear(): void {
    GlobalContext.getContext()?.eventHub.emit('AiBarUseAppColor', false);
    GlobalContext.getContext()?.eventHub.off(EventConstants.EVENT_UPDATE_PAGE_FOCUS, this.onUpdatePageFocus);
  }

  build() {
    List({ space: editModeDockViewModel.getButtonDockSpace() }) {
      ForEach(this.getButtonItemList(),
        (item: ButtonModel, index: number) => {
          ListItem() {
            this.buttonItemCustom(item, index)
          }
        })
    }
    .scrollBar(BarState.Off)
    .height(EditModeStyleConstants.PERCENTAGE_100)
    .alignListItem(ListItemAlign.Center)
    .listDirection(Axis.Horizontal)
    .opacity(this.buttonOpacity.value)
    .contentStartOffset(launcherStatusUtil.getShowOutLauncherStatus() ?
    SmallFoldStyleUtil.EDIT_MODE_BUTTON_DOCK_CONTENT_OFFSET : undefined)
    .contentEndOffset(launcherStatusUtil.getShowOutLauncherStatus() ?
    SmallFoldStyleUtil.EDIT_MODE_BUTTON_DOCK_CONTENT_OFFSET : undefined)
  }

  private handleTouchEvent(event: TouchEvent, index: number): void {
     if (event.type === TouchType.Down) {
        this.iconScaleAnimation(CommonConstants.OPEN_FOLDER_ANIMATE_SCALE, index);
     } else if (event.type === TouchType.Up) {
       this.iconScaleAnimation(StyleConstants.DEFAULT_1, index);
     }
  }

   /**
   * 图标缩放动效
   * @param isZoomOut
   */
  public iconScaleAnimation(scale: number, index: number): void {
    animateTo({
      curve: Curve.Linear,
      duration: 50,
      playMode: PlayMode.Normal
    }, () => {
      this.iconScales[index] = scale;
    })
  }

  @Builder
  outerButtonItem(dockItem: ButtonModel, index: number) {
      Row() {
        Image($r(`app.media.${dockItem.icon}`))
          .draggable(false)
          .height(EditModeDockConstants.OUTER_EDIT_COMMON_PARAM)
          .width(EditModeDockConstants.OUTER_EDIT_COMMON_PARAM)
          .margin({ end: LengthMetrics.vp(EditModeDockConstants.OUTER_EDIT_MODE_BUTTON_MARGIN_RIGHT) })

        Text($r(`app.string.${dockItem.name}`))
          .maxFontScale(this.outerButtonDockData?.getMaxFontScale())
          .fontSize(this.outerButtonDockData?.getStdFontSize())
          .fontColor($r('sys.color.ohos_id_color_primary_contrary'))
          .fontWeight(FontWeight.Medium)
          .textAlign(TextAlign.Center)
          .maxLines(StyleConstants.DEFAULT_APP_NAME_LINES)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .height(SmallFoldStyleUtil
            .getScaleSize(EditModeDockConstants.OUTER_EDIT_LINE_HEIGHT
              , this.outerButtonDockData?.getMaxFontScale()))
      }
      .alignItems(VerticalAlign.Center)
      .padding({ start: LengthMetrics.vp(EditModeDockConstants.OUTER_EDIT_MODE_BUTTON_PADDING_START)
        , end: LengthMetrics.vp(EditModeDockConstants.OUTER_EDIT_MODE_BUTTON_PADDING_END)
        , top: LengthMetrics.vp(EditModeDockConstants.OUTER_EDIT_MODE_BUTTON_PADDING_TOP_BOTTOM)
        , bottom: LengthMetrics.vp(EditModeDockConstants.OUTER_EDIT_MODE_BUTTON_PADDING_TOP_BOTTOM) })
      .backgroundColor(
        $r('app.color.outer_edit_button_bg_color')
      )
      .borderRadius(EditModeDockConstants.OUTER_EDIT_MODE_BUTTON_RADIUS)
      .constraintSize({ minWidth: EditModeDockConstants.OUTER_EDIT_MODE_BUTTON_WIDTH
        , minHeight: EditModeDockConstants.OUTER_EDIT_MODE_BUTTON_HEIGHT})
      .onClick(() => {
        editModeDockViewModel.editModeDockClick(dockItem.key);
      })
      .onTouch((event: TouchEvent): void => this.handleTouchEvent(event, index))
      .scale({
        x: this.iconScales[index],
        y: this.iconScales[index]
      })
  }

  @Builder
  buttonItem(dockItem: ButtonModel, index: number) {
    Column({ space: EditModeStyleConstants.EDIT_BUTTON_IMAGE_FONT_SPACE }) {
      Stack() {
        Row() {
        }
        .height(EditModeStyleConstants.EDIT_SWIPER_BUTTON_SIZE)
        .width(EditModeStyleConstants.EDIT_SWIPER_BUTTON_SIZE)
        .backgroundColor(
          editModeDockViewModel.isDarkWallpaper() ? $r('sys.color.ohos_id_color_background') : LIGHT_COLOR
        )
        .opacity(editModeDockViewModel.isDarkWallpaper() ? EditModeStyleConstants.EDIT_DOCK_BACKGROUND_OPACITY : 1)
        .borderRadius(EditModeStyleConstants.EDIT_SWIPER_BUTTON_SIZE / 2)

        SymbolGlyph($r(`sys.symbol.${dockItem.icon}`))
          .draggable(false)
          .fontSize(EditModeStyleConstants.EDIT_SWIPER_ICON_SIZE + 'vp')
          .renderingStrategy(SymbolRenderingStrategy.SINGLE)
          .fontColor([Color.White])
      }
      .height(EditModeStyleConstants.EDIT_SWIPER_BUTTON_SIZE)
      .width(EditModeStyleConstants.EDIT_SWIPER_BUTTON_SIZE)

      Row() {
        Text($r(`app.string.${dockItem.name}`))
          .fontSize(EditModeUtils.getScaleSize($r('sys.float.ohos_id_text_size_caption'), this.fontSizeScale))
          .fontColor(editModeDockViewModel.isDarkWallpaper() ?
            $r('sys.color.ohos_id_color_primary_contrary') : LIGHT_FONT_COLOR)
          .fontWeight(FontWeight.Regular)
          .width(EditModeStyleConstants.PERCENTAGE_100)
          .textAlign(TextAlign.Center)
          .maxLines(StyleConstants.DEFAULT_APP_NAME_LINES)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .margin({ top: EditModeStyleConstants.EDIT_SWIPER_BUTTON_NAME_MARGIN_TOP })
      }
      .height(EditModeStyleConstants.EDIT_MODE_BUTTON_TEXT_HEIGHT)
      .alignItems(VerticalAlign.Top)
    }
    .id(EditModeAccessibilityUtil.getEditModeDockIconId(index))
    .accessibilityNextFocusId(index === this.getButtonItemList().length - 1 ?
      this.nextFocusId :
      EditModeStyleConstants.DEFAULT_ACCESSIBILITY_WHEN_NOT_FOUNT_ID)
    .width(EditModeStyleConstants.EDIT_SWIPER_BUTTON_WIDTH)
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      editModeDockViewModel.editModeDockClick(dockItem.key);
    })
    .onTouch((event: TouchEvent): void => this.handleTouchEvent(event, index))
    .scale({
      x: this.iconScales[index],
      y: this.iconScales[index]
    })
  }

  @Builder
  buttonItemCustom(dockItem: ButtonModel, index: number) {
    if (launcherStatusUtil.getShowOutLauncherStatus()) {
      this.outerButtonItem(dockItem, index);
    } else {
      this.buttonItem(dockItem, index);
    }
  }
}

class ButtonModel {
  /**
   * 按钮key值
   */
  public key: string = '';

  /**
   * 按钮名称
   */
  public name: string = '';

  /**
   * 按钮图标
   */
  public icon: string = '';
}