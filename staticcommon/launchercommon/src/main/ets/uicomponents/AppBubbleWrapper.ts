/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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
import { NumberConstants } from '@ohos/commonconstants';
import { StyleConstants } from '../constants/StyleConstants';

export class AppBubbleWrapper {
  //@ts-ignore
  static getContextMenuOptions(appIsBottomHalfOfTheScreen: boolean, imageBuilder: MenuPreviewMode | CustomBuilder,
                               onDisappear?: () => void, onAppear?: () => void): ContextMenuOptions {
    return {
      offset: { x: NumberConstants.CONSTANT_NUMBER_ZERO, y: NumberConstants.CONSTANT_NUMBER_FIVE },
      //@ts-ignore
      placement: appIsBottomHalfOfTheScreen ? Placement.TopLeft : Placement.BottomLeft,
      //@ts-ignore
      preview: imageBuilder,
      onDisappear: onDisappear,
      onAppear: onAppear,
      previewAnimationOptions: {
        scale: [StyleConstants.MENU_ANIMATION_FROM, StyleConstants.MENU_ANIMATION_TO]
      }
    };
  }

  //@ts-ignore
  static getContextMenuOptions2(imageBuilder?: MenuPreviewMode | CustomBuilder,
                                onDisappear?: () => void, onAppear?: () => void): ContextMenuOptions {
    return {
      //@ts-ignore
      placement: Placement.TopLeft,
      //@ts-ignore
      preview: imageBuilder,
      onDisappear: onDisappear,
      onAppear: onAppear,
      //@ts-ignore
      backgroundBlurStyle: BlurStyle.NONE,
    };
  }

  //@ts-ignore
  static getContextMenuOptions3(folderIsBottomHalfOfTheScreen: boolean, imageBuilder: MenuPreviewMode | CustomBuilder,
                                onDisappear?: () => void): ContextMenuOptions {
    return {
      //@ts-ignore
      placement: folderIsBottomHalfOfTheScreen ? Placement.TopLeft : Placement.BottomLeft,
      //@ts-ignore
      preview: imageBuilder,
      onDisappear: onDisappear,
      //@ts-ignore
      backgroundBlurStyle: BlurStyle.NONE,
    };
  }

  //@ts-ignore
  static getContextMenuOptions4(appIsBottomHalfOfTheScreen: boolean, onDisappear?: () => void): ContextMenuOptions {
    return {
      //@ts-ignore
      placement: appIsBottomHalfOfTheScreen ? Placement.TopLeft : Placement.BottomLeft,
      //@ts-ignore
      preview: MenuPreviewMode.IMAGE,
      onDisappear: onDisappear,
      previewAnimationOptions: {
        scale: [StyleConstants.MENU_ANIMATION_FROM, StyleConstants.MENU_ANIMATION_TO]
      }
    };
  }

  //@ts-ignore
  static getContextMenuOptions5(): ContextMenuOptions {
    return {
      //@ts-ignore
      placement: Placement.BottomLeft,
      offset: { x: 0, y: 0 },
      //@ts-ignore
      preview: MenuPreviewMode.IMAGE
    };
  }

  //@ts-ignore
  static getContextMenuOptions6(): ContextMenuOptions {
    return {
      //@ts-ignore
      preview: MenuPreviewMode.IMAGE
    };
  }

  //@ts-ignore
  static getContextMenuOptions7(appIsBottomHalfOfTheScreen: boolean): ContextMenuOptions {
    return {
      offset: { x: NumberConstants.CONSTANT_NUMBER_ZERO, y: NumberConstants.CONSTANT_NUMBER_FIVE },
      //@ts-ignore
      preview: MenuPreviewMode.IMAGE,
      //@ts-ignore
      placement: appIsBottomHalfOfTheScreen ? Placement.TopLeft : Placement.BottomLeft,
      //@ts-ignore
      effectOption: {
        saturation: StyleConstants.THIN_EFFECT_SATURATION,
        brightness: StyleConstants.THIN_EFFECT_BRIGHTNESS,
        radius: StyleConstants.THIN_EFFECT_RADIUS,
        color: StyleConstants.THIN_EFFECT_COLOR
      }
    };
  }

  //@ts-ignore
  static getContextMenuOptions8(appIsBottomHalfOfTheScreen: boolean): ContextMenuOptions {
    return {
      //@ts-ignore
      placement: appIsBottomHalfOfTheScreen ? Placement.TopLeft : Placement.BottomLeft,
      //@ts-ignore
      preview: MenuPreviewMode.IMAGE,
      //@ts-ignore
      effectOption: {
        saturation: StyleConstants.THIN_EFFECT_SATURATION,
        brightness: StyleConstants.THIN_EFFECT_BRIGHTNESS,
        radius: StyleConstants.THIN_EFFECT_RADIUS,
        color: StyleConstants.THIN_EFFECT_COLOR
      }
    };
  }

  //@ts-ignore
  static getContextMenuOptions9(): ContextMenuOptions {
    return {
      //@ts-ignore
      placement:  Placement.TopLeft,
      offset: { x: 0, y: 0 },
      //@ts-ignore
      preview: MenuPreviewMode.IMAGE,
      //@ts-ignore
      effectOption: {
        saturation: StyleConstants.THIN_EFFECT_SATURATION,
        brightness: StyleConstants.THIN_EFFECT_BRIGHTNESS,
        radius: StyleConstants.THIN_EFFECT_RADIUS,
        color: StyleConstants.THIN_EFFECT_COLOR
      }
    };
  }

  //@ts-ignore
  static getFormStackMenuOptions(appIsBottomHalfOfTheScreen: boolean,
                                 onDisappear?: () => void, onAppear?: () => void): ContextMenuOptions {
    return {
      offset: { x: NumberConstants.CONSTANT_NUMBER_ZERO, y: NumberConstants.CONSTANT_NUMBER_EIGHT },
      //@ts-ignore
      placement: appIsBottomHalfOfTheScreen ? Placement.TopLeft : Placement.BottomLeft,
      //@ts-ignore
      backgroundBlurStyle: BlurStyle.NONE,
      preview: MenuPreviewMode.IMAGE,
      onDisappear: onDisappear,
      onAppear: onAppear,
      previewAnimationOptions: {
        scale: [StyleConstants.MENU_ANIMATION_FROM, StyleConstants.MENU_ANIMATION_TO]
      }
    };
  }

  //@ts-ignore
  static getContextMenuEffectOptions(): ContextMenuOptions {
    return {
      //@ts-ignore
      effectOption: {
        saturation: StyleConstants.THIN_EFFECT_SATURATION,
        brightness: StyleConstants.THIN_EFFECT_BRIGHTNESS,
        radius: StyleConstants.THIN_EFFECT_RADIUS,
        color: StyleConstants.THIN_EFFECT_COLOR
      }
    };
  }
}