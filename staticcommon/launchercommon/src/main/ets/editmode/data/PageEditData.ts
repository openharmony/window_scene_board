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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { desktopUtil, RTLUtil } from '@ohos/componenthelper';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { AppListInfo, DeviceState, StyleConstants } from '../../TsIndex';
import EditModeConstants from '../../utils/EditModeConstants';
import { MultiSelectStyleConfig } from './MultiSelectStyleConfig';

const TAG = 'PageEditData';
const log = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export enum EditModePageTypeEnum {
  NORMAL = 0,
  FRONT_ADD = 1,
  BACK_ADD = 2,
}

export enum EditModePageActionEnum {
  WAITTING_ACTION = 0,
  DELETEING_BLANK_PAGE = 1,
  ADDING_BLANK_PAGE = 2,
  EXITING_BLANK_PAGE = 3,
  PRE_DRAG_PAGE = 4,
  START_DRAG_PAGE = 5,
  DRAG_PAGE_MOVING = 6,
}

export type getBlankPageListType = () => Map<number, boolean>;

export class EditModePageUtil {
  /** 数据库中缓存的pageCount */
  private static pageCountFromRdb: number = 0;

  public static getCenterPageIndexList(page: number): number[] {
    if (DeviceHelper.isFoldExpandedButNotSmallFoldProduct()) {
      const nearPage = page % 2 === 0 ? page + 1 : page - 1;
      return [page, nearPage];
    } else {
      return [page];
    }
  }

  public static getIsFoldExpandStatus(): boolean {
    const foldStatus = AppStorage.get<number>('folderStatus');
    log.showInfo(`getIsFoldExpandStatus: ${foldStatus}`);
    return foldStatus !== DeviceState.DEFAULT_STATE;
  }

  /**
   * 获取page横向缩放中心
   *
   * @param pageIndex 目标page索引
   * @param displayCnt 当前一屏最大显示页数
   * @returns 缩放中心。单屏：中心缩放 双屏：中心轴缩放 三屏：中间屏中心点缩放 镜像布局下取反
   */
  public static getScaleCenterX(pageIndex: number, displayCnt: number): string {
    if (displayCnt === StyleConstants.DEFAULT_1) {
      return StyleConstants.PERCENTAGE_50;
    } else if (displayCnt === StyleConstants.DEFAULT_2) {
      return RTLUtil.isRTL() ?
        (pageIndex % displayCnt === 1 ? StyleConstants.PERCENTAGE_100 : StyleConstants.PERCENTAGE_0) :
        (pageIndex % displayCnt === 1 ? StyleConstants.PERCENTAGE_0 : StyleConstants.PERCENTAGE_100);
    } else if (displayCnt === StyleConstants.DEFAULT_3 && pageIndex % displayCnt !== StyleConstants.DEFAULT_1) {
      return RTLUtil.isRTL() ?
        (pageIndex % displayCnt === 0 ? StyleConstants.PERCENTAGE_NEGATIVE_50 : StyleConstants.PERCENTAGE_150) :
        (pageIndex % displayCnt === 0 ? StyleConstants.PERCENTAGE_150 : StyleConstants.PERCENTAGE_NEGATIVE_50);
    } else {
      return StyleConstants.PERCENTAGE_50;
    }
  }

  public static getPageCountFromRdb(): number {
    log.showInfo(`getPageCountFromRdb`);
    return EditModePageUtil.pageCountFromRdb;
  }

  public static setPageCountFromRdb(pageCountFromRdb: number): void {
    log.showInfo(`setPageCountFromRdb: ${pageCountFromRdb}`);
    EditModePageUtil.pageCountFromRdb = pageCountFromRdb;
  }
}

export class EditModePageStaticData {
  /** 编辑模式背景板中心点据桌面左上角Y位置 */
  public static editModeBgCenterPointY: number = 0;
  /** 编辑模式背景板宽度 */
  public static editModeBgWidth: number = 0;
  /** 编辑模式背景板高度 */
  public static editModeBgHeight: number = 0;
}

/**
 * 桌面编辑样式配置类
 */
export class EditModeStyleConfig {
  /**
   * 多选框大小
   */
  public checkboxSize: number = MultiSelectStyleConfig.CHECKBOX_SIZE;

  /**
   * 编辑态页面缩放比例
   */
  public swiperEditScaleRate: number = EditModeConstants.SWIPER_EDIT_SCALE_RATE;

  /**
   * 编辑态页面itemSpace
   */
  public swiperPreItemSpace: number = EditModeConstants.SWIPER_PRE_ITEM_SPACE;

  /**
   * 编辑态页面两侧margin
   */
  public swiperPrevNextMargin: number = EditModeConstants.SWIPER_PREV_NEXT_MARGIN;

  /**
   * 编辑态页面添加的高度
   */
  public swiperEditAddHeight: number = EditModeConstants.SWIPER_EDIT_ADD_HEIGHT;

  /**
   * 编辑模式右侧addPage按钮尺寸
   */
  public pageEditButtonSize: number = EditModeConstants.PAGE_EDIT_BUTTON_SIZE;

  /**
   * 编辑模式右侧addPage按钮内图片尺寸
   */
  public pageEditButtonIconSize: number = EditModeConstants.PAGE_EDIT_BUTTON_ICON_SIZE;

  /**
   * 编辑模式顶部删除按钮内图片尺寸
   */
  public pageEditRemoveBarButtonIconSize: number = StyleConstants.DEFAULT_20;

  /**
   * 编辑模式顶部删除按钮内宽度
   */
  public pageEditRemoveBarButtonWidth: number = StyleConstants.DEFAULT_60;

  /**
   * 编辑模式顶部删除按钮内高度
   */
  public pageEditRemoveBarButtonHeight: number = StyleConstants.DEFAULT_32;

  /**
   * 编辑模式顶部删除按钮内圆角
   */
  public pageEditRemoveBarBorderRadius: string | number | Resource = $r('sys.float.ohos_id_corner_radius_default_l');

  /**
   * 编辑模式顶部删除按钮上边距
   */
  public pageEditRemoveBarMarginTop: number = EditModeConstants.PAGE_EDIT_REMOVE_BAR_MARGIN_TOP;

  /**
   * 编辑模式顶部删除按钮左边距
   */
  public pageEditRemoveBarPaddingLeft: number = StyleConstants.DEFAULT_24;

  /**
   * 编辑模式顶部删除按钮右边距
   */
  public pageEditRemoveBarPaddingRight: number = StyleConstants.DEFAULT_24;

  /**
   * 编辑模式右侧addPage按钮非深色背景颜色
   */
  public pageEditButtonBgColor: string = EditModeConstants.PAGE_EDIT_BUTTON_BG_COLOR;

  /**
   * 编辑模式右侧addPage按钮深色背景颜色
   */
  public pageEditButtonDarkBgColor: string | Resource = $r('sys.color.ohos_id_color_background');

  /**
   * 编辑模式右侧addPage按钮深色背景透明度
   */
  public pageEditButtonDeepBgOpacity: number = EditModeConstants.PAGE_EDIT_BUTTON_DEEP_BG_OPACITY;

  /**
   * 编辑模式右侧addPage按钮深色背景颜色
   */
  public pageEditButtonClickEffect: ClickEffect | null =
    { level: ClickEffectLevel.MIDDLE, scale: EditModeConstants.PAGE_EDIT_BUTTON_BREARHE_SCALE };

  /**
   * 编辑模式右侧addPage按钮hover背景颜色
   */
  public pageEditButtonHoverBgColor: string | Resource = $r('sys.color.interactive_hover');

  /**
   * 编辑模式删除页面按钮底边距
   */
  public pageEditDeleteIconMarginBottom: number = EditModeConstants.PAGE_EDIT_DELETE_ICON_MARGIN_BOTTOM;

  /**
   * 编辑模式页面圆角
   */
  public editModeBorderRadius: number = EditModeConstants.EDIT_MODE_BORDER_RADIUS;

  /**
   * 编辑模式背板背景颜色
   */
  public pageEditBgColor: string | Resource = $r('sys.color.ohos_id_color_background');

  /**
   * 编辑态页面透明度
   */
  public swiperEditOpacity: number = EditModeConstants.SWIPER_EDIT_OPACITY;

  /**
   * 编辑模式上方拖拽页面提示语高度尺寸
   */
  public editModeDragPageTipHeight: number = EditModeConstants.EDIT_MODE_DRAG_PAGE_TIP_HEIGHT;

  /**
   * 编辑模式上方拖拽页面提示语透明度
   */
  public dragPageTipOpacity: number = EditModeConstants.DRAG_PAGE_TIP_OPACITY;

  /**
   * 编辑模式上方拖拽页面提示语透明度
   */
  public dragPageTipTextSize: number | string = '16vp';

  /**
   * 编辑模式上方拖拽页面提示语字重
   */
  public dragPageTipTextFontWeight: number | FontWeight | string = FontWeight.Regular;

  /**
   * 编辑模式背板背景颜色
   */
  public dragPageTipTextColor: string | Resource = '#FFFFFF';

  /**
   * 编辑模式上方拖拽页面提示语距离背景板间隔
   */
  public editModeDragPageTipBottomMargin: number = EditModeConstants.EDIT_MODE_DRAG_PAGE_TIP_BOTTOM_MARGIN;

  /**
   * 编辑模式添加按钮边框
   */
  public addEditButtonBorderOptions: BorderOptions = {};

  /**
   * 编辑模式添加删除样式为Tv样式
   */
  public addPageButtonStyle: string = '';

  /**
   * 编辑模式下, 应用卸载弹框样式是否自定义
   */
  public uninstallDialogCustomStyle: boolean | undefined = true;

  /**
   * 编辑模式下, 应用卸载弹框内容对齐样式
   */
  public uninstallDialogAlignment: DialogAlignment | undefined = DialogAlignment.Top;

  /**
   * 编辑模式下, 应用卸载弹框自定义蒙层颜色
   */
  public uninstallDialogMaskColor: ResourceColor | undefined = Color.Transparent;

  /**
   * 编辑模式下, 应用卸载弹框宽度占栅格宽度的个数。
   */
  public uninstallDialogGridCount: number | undefined = 4;

  /**
   * 编辑模式下, 应用卸载弹框是否触发主动关闭
   */
  public uninstallDialogNeedActiveCloseDialog: boolean = false;

  /**
   * 编辑模式下, 应用卸载弹框类型样式
   */
  public uninstallDialogCustomDialogType: string = 'default';

}