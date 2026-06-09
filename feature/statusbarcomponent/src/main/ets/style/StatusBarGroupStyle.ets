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

import { StatusBarTint } from '../common/StatusBarTint';

/**
 * 图标之间间距, 单位vp
 */
export const SYSTEM_ICON_SPACE = 2;

/**
 * 图标之间间距, 单位vp取整。arkUI对像素取整的逻辑是会对border、padding、margin做向下取整，该变量用于跨孔计算，避免误差。
 */
export const SYSTEM_ICON_SPACE_VP_FLOOR = px2vp(Math.floor(vp2px(SYSTEM_ICON_SPACE)));

/**
 * 状态栏左右容器资源样式
 *
 * @since 2022-10-26
 */
@Observed
export class StatusBarGroupStyle {
    /**
     * 顶层容器高度
     */
    public groupHeight: Length = 0;

    /**
     * the pc status bar inner border container height
     */
    public groupInnerHeight: Length = 0;

    /**
     * 顶层容器左侧间距
     */
    public groupLeftPadding: Length = 0;

    /**
     * 顶层容器右侧间距
     */
    public groupRightPadding: Length = 0;

    /**
     * 顶层容器背景色
     * 默认透明
     */
    public groupBgColor: string = StatusBarTint.BG_COLOR_TRANSPARENT;

    /**
     * 顶层容器圆角
     */
    public groupBgRadius: Length = 0;

    /**
     * the pc status bar inner border container radius
     */
    public groupBgInnerRadius: Length = 0;

    /**
     * 图标容器高度
     */
    public iconContainerHeight: Length = 0;

    /**
     * 图标容器左侧间距
     */
    public iconSideLeftPadding: number = 0;

    /**
     * 图标容器右侧间距
     */
    public iconSideRightPadding: Length = 0;

    /**
     * 图标之间间距
     */
    public iconSpace: Length = SYSTEM_ICON_SPACE;

    /**
     * 跨孔系统图标区域左边距
     */
    public systemIconLeftSpace: Length = 4;

    /**
     * 顶层容器边框宽度
     */
    public groupBorderWidth: Length = 0;

    /**
     * 初始化group样式
     *
     * @param position 区分左右位置
     */
    public initGroupStyle(position: string): void {
        this.initPhoneStyle(position);
    }

    /**
     * Phone状态栏左右group样式
     *
     * @param position 区分左右
     */
    private initPhoneStyle(position: string): void {
        // 高度默认22，其他均默认0
        let groupHeight = $r('app.float.plugin_phone_icon_height');
        this.groupHeight = groupHeight;
        this.iconContainerHeight = groupHeight;
        this.groupInnerHeight = groupHeight;
    }
}