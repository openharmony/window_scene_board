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

import { ItemAnimOption } from '@ohos/systemuicommon/src/main/ets/manager/DropDownPanelManager';
import {
    CheckEmptyUtils,
    LogDomain,
    LogHelper
} from '@ohos/basicutils';
import {
    CommonComponent,
    DeviceHelper,
    SystemParamUtils,
    GlobalContext
} from '@ohos/frameworkwrapper';
import { FASlotName } from '@ohos/commonconstants';
import { ControlCenterState } from '@ohos/controlcentercommon/Index';

const TAG: string = 'Ctrl.Constants';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);

interface ThemeColorType {
    colorResource: Resource;
    colorValue: string;
}

export interface SceneModule extends CommonComponent {
    sceneboard: SceneBoard;
}

interface SceneBoard {
    controlCenter: ControlCenter;
}

interface ControlCenter {
    isRealtimeBlur: string;
}

const themeColorArray: ThemeColorType[] = [
    {
        colorResource: $r('app.color.Control_center_icon_on_color'),
        colorValue: 'FFFFFFFF',
    },
    {
        colorResource: $r('app.color.Control_center_icon_setting_color'),
        colorValue: 'ffffffff',
    },
    {
        colorResource: $r('app.color.Control_center_icon_setting_bg_color'),
        colorValue: 'FF000000',
    },
    {
        colorResource: $r('app.color.control_center_edit_collapse_library_button_text_color'),
        colorValue: 'ff000000',
    },
    {
        colorResource: $r('app.color.control_center_edit_collapse_library_button_bg_color'),
        colorValue: 'ffffffff',
    },
    {
        colorResource: $r('app.color.Control_center_brightness_block_color_dark'),
        colorValue: 'FFFFFFFF',
    },
    {
        colorResource: $r('app.color.center_edit_add_more_toggle_button_bg_color'),
        colorValue: 'ffffffff',
    },
    {
        colorResource: $r('app.color.center_edit_add_more_toggle_button_icon_color'),
        colorValue: 'ff000000',
    },
    {
        colorResource: $r('app.color.center_edit_page_header_text_color'),
        colorValue: 'ffffffff',
    },
    {
        colorResource: $r('app.color.Control_center_icon_default_bg_color'),
        colorValue: 'FFFFFFFF',
    },
    {
        colorResource: $r('app.color.Control_center_brightness_bg_color'),
        colorValue: 'FF000000',
    },
    {
        colorResource: $r('app.color.Control_center_icon_default_bg_color_dark'),
        colorValue: 'FF000000',
    },
    {
        colorResource: $r('app.color.Control_center_brightness_bg_color_dark'),
        colorValue: 'FF000000',
    },
    {
        colorResource: $r('app.color.Control_center_wifiBlue_icon_on_bg_color'),
        colorValue: 'FF0A59F7',
    },
    {
        colorResource: $r('app.color.Control_center_icon_on_bg_color'),
        colorValue: 'FF0A59F7',
    },
    {
        colorResource: $r('app.color.Control_center_wifiBlue_icon_on_bg_color_dark'),
        colorValue: 'FF317AF7',
    },
    {
        colorResource: $r('app.color.Control_center_icon_on_bg_color_dark'),
        colorValue: 'FF317AF7',
    },
    {
        colorResource: $r('app.color.Control_center_wifiBlue_icon_default_bg_color'),
        colorValue: 'ff000000',
    },
    {
        colorResource: $r('app.color.Control_center_wifiBlue_icon_default_bg_color_dark'),
        colorValue: 'ffFFFFFF',
    },
    {
        colorResource: $r('app.color.Control_center_brightness_block_color'),
        colorValue: 'FFFFFFFF',
    },
    {
        colorResource: $r('app.color.Control_center_icon_on_color_dark'),
        colorValue: 'FFffffff',
    },
    {
        colorResource: $r('app.color.Control_center_icon_default_color'),
        colorValue: 'FF000000',
    },
    {
        colorResource: $r('app.color.Control_center_icon_default_color_dark'),
        colorValue: 'FFffffff',
    },
    {
        colorResource: $r('app.color.Control_center_long_button_font_on_color'),
        colorValue: 'FF000000',
    },
    {
        colorResource: $r('app.color.Control_center_long_button_font_default_color'),
        colorValue: 'FF000000',
    },
    {
        colorResource: $r('app.color.Control_center_long_button_font_on_color_dark'),
        colorValue: 'FFFFFFFF',
    },
    {
        colorResource: $r('app.color.Control_center_long_button_font_default_color_dark'),
        colorValue: 'FFFFFFFF',
    },
];

export class ThemeColor {
    public static isDefaultColor(): boolean {
        for (let i = 0; i < themeColorArray.length; i++) {
            let item: ThemeColorType = themeColorArray[i];
            let getColorStr: string = '';
            try {
                getColorStr = GlobalContext.getContext().resourceManager.getColorSync(item.colorResource.id).toString();
            } catch (error) {
                log.showError(`getColorSync error:${error}`);
            }
            let result: boolean = getColorStr === Number.parseInt(item.colorValue, 16).toString();
            if (!result) {
                return false;
            }
        }
        return true;
    }
}

export default class Constants {
    public static TOP_TOGGLE_ROWS_MAX: number = Number(SystemParamUtils.getSystemParam('cc.top.rows.max', '3'));
    public static QUICK_TOGGLE_MAX: number = Number(SystemParamUtils.getSystemParam('cc.toggles.count.max', '20'));
    public static QUICK_TOGGLE_MIN: number = Number(SystemParamUtils.getSystemParam('cc.toggles.count.min', '4'));
    public static GEOMETRY_CONTROL_CENTER_QUICK_TOGGLE: string = 'controlCenterQuickToggleGeometry';
    public static IS_IOT_EDIT_SUPPORTED: boolean =
        SystemParamUtils.getSystemParam('cc.support.edit.iot', 'true') === 'true';
    public static ICON_FONT_SIZE: number = 24;
    // 默认用户ID
    public static DEFAULT_USER_ID: number = 100;
    // 开关个数16切换到12个特性开关
    public static LOAD_NEW_DEFAULT_TOGGLE: boolean = true;
}

@Observed
export class ControlCenterData {
    public state: ControlCenterState;

    constructor(state: ControlCenterState) {
        this.state = state;
    }
}

export enum ToggleDragState {
    DRAGGING_IDLE,
    DRAGGING_ADD,
    DRAGGING_REMOVE,
    DRAGGING_MOVE,
    DRAGGING_DONE,
    DRAGGING_CANCEL
}

// 顶栏无固定项，媒体/亮度/音量均由用户编辑添加
export const FIXED_TOP_TOGGLES: string[] = [];

/**
 * 媒体行固定槽位顺序：媒体 | 亮度音量组合（添加后位置固定）
 */
export const MEDIA_ROW_TOP_TOGGLES: string[] = [
  FASlotName.MEDIA_ITEM_NAME,
  FASlotName.COMBINED_SLIDER
];

/** 旧版拆分的亮度/音量槽位，需迁移为 combined_slider */
export const LEGACY_SLIDER_TOP_TOGGLES: string[] = [
  FASlotName.BRIGHTNESS,
  FASlotName.SOUND
];

// 2*2尺寸开关列表
export const TOGGLE_LIST_OF_2_2: string[] = [FASlotName.MEDIA_ITEM_NAME, FASlotName.COMBINED_SLIDER];

export class ToggleData {
    public topToggle: Array<string> = [];
    public otherTopToggle: Array<string> = [];
    public quickToggle: Array<string> = [];
    public otherToggle: Array<string> = [];

    copy(other: ToggleData) {
        this.topToggle = other.topToggle;
        this.quickToggle = other.quickToggle;
        this.otherToggle = other.otherToggle;
        this.otherTopToggle = other.otherTopToggle;
    }

    equals(other: ToggleData): boolean {
        if (this.quickToggle.toString() != other.quickToggle.toString()) {
            return false;
        }
        if (this.otherToggle.toString() != other.otherToggle.toString()) {
            return false;
        }
        if (this.topToggle.toString() != other.topToggle.toString()) {
            return false;
        }
        if (this.otherTopToggle.toString() != other.otherTopToggle.toString()) {
            return false;
        }
        return true;
    }

    contain(toggleName: string): boolean {
        return this.topToggle.includes(toggleName) || this.quickToggle.includes(toggleName) ||
            this.otherToggle.includes(toggleName) || this.otherTopToggle.includes(toggleName);
    }

    toString(): string {
        return `topToggle: ${this.topToggle.toString()}, quickToggle: ${this.quickToggle.toString()}` +
            `otherToggle: ${this.otherToggle.toString()}, otherTopToggle: ${this.otherTopToggle.toString()}`;
    }

    isEmpty(): boolean {
        return CheckEmptyUtils.isEmptyArr(this.topToggle) && CheckEmptyUtils.isEmptyArr(this.quickToggle) &&
            CheckEmptyUtils.isEmptyArr(this.otherToggle) && CheckEmptyUtils.isEmptyArr(this.otherTopToggle);
    }
}

export enum NodePoolNodeType {
    WIFI = 'wifi_button',
    BLUETOOTH = 'bluetooth_button',
    FOCUS_MODE = 'focus_mode_button',
    VOLUME = 'volume_button',
    BRIGHTNESS = 'brightness_button'
}

export enum ControlCenterItem {
    ITEM_MEDIA,
    ITEM_TOGGLE,
    ITEM_IOT
}

export class ContentItemOption extends ItemAnimOption {

    static create(opacity: number): ContentItemOption {
        let data: ContentItemOption = new ContentItemOption();
        data.opacity = opacity;
        return data;
    }
}

// 音量条、亮度条二级页面收起一镜到底动效过程中二级页面停留的时间
export const SUBPAGE_SHORT_SPRING_DURATION: number = 500;

// WiFi、蓝牙等二级页面收起一镜到底动效持续过程中二级页面停留的时间
export const SUBPAGE_LONG_SPRING_DURATION: number = 820;

// 头部模糊区域从右到左0.8的位置透明度开始渐变到0
export const LINEAR_GRADIENT_PROPORTION_HEADER: number = 0.8;

// 隐私指示器文本溢出时从左往右0.5的位置透明度开始渐变到0
export const LINEAR_GRADIENT_PROPORTION_PRIVACY_SENSOR: number = 0.5;

// Keeps the source pixels that cover the destination pixels, discards the remaining source and destination pixels.
export const BLEND_MODE_SRC_IN: number = 6;

// The source pixels are drawn over the destination pixels.
export const BLEND_MODE_SRC_OVER: number = 4;

// 主页面布局组件ZINDEX
export const MAIN_LAYOUT_HEAD_BLUR_AREA_ZINDEX: number = 1;
export const MAIN_LAYOUT_HEADER_ZINDEX: number = 2;
export const MAIN_LAYOUT_PRIVACY_SENSOR_ZINDEX: number = 3;

export const HEAD_SPACE_DIFF: number = 22;
export const TOGGLE_SPACE_DIFF: number = 4;
export const HEAD_BLUR_AREA_HEIGHT_COMPACT: number = 124 - HEAD_SPACE_DIFF;
export const TOGGLE_SPACE_COMPACT: number = 16 - TOGGLE_SPACE_DIFF;
export const HEADER_BUTTON_TRANSLATE_COMPACT: number = -20 + HEAD_SPACE_DIFF;
export const NORMAL_PORTRAIT_CONTENT_START_OFFSET_COMPACT: number = 132 - HEAD_SPACE_DIFF;
export const PRIVACY_SENSOR_OFFSET_COMPACT: number = 62;
export const PRIVACY_SENSOR_WIDTH_COMPACT: number = 320 - 80 - 16;

// 编辑页面组件布局ZINDEX
export const TOGGLE_EDIT_HEAD_ZINDEX: number = 4;
export const TOGGLE_EDIT_PREVIEW_PAGE_ZINDEX: number = 3;
export const TOGGLE_EDIT_ADD_BOTTON_ZINDEX: number = 2;
export const TOGGLE_EDIT_IOT_BOTTON_ZINDEX: number = 1;

// 单屏页面备选库布局ZINDEX
export const TOGGLE_LIBRARY_HEAD_ZINDEX: number = 4;
export const TOGGLE_LIBRARY_BOTTON_ZINDEX: number = 1;

// 编辑页备选库默认高度
export const TOGGLE_EDIT_LIBRARY_HEIGHT: number = 390;