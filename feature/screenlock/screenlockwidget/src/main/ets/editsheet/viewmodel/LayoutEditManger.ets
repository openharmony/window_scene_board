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
import { ClockColorUtil } from '../../clock/common/ClockColorUtil';
import { AestheticColorArgs, ClockLayout } from '../../common/WidgetParam';
import { clockLayoutHelper, GridAmount } from '../../clock/common/ClockLayoutHelper';
import { AnyClock } from '../models/AnyClock';
import { clockWidgetConfigManager } from '../../clock/common/ClockWidgetConfigManager';
import { CLOCK_LAYOUT_REVERSE_CONSTANT, REVERSE_LAYOUT } from '../../common/WidgetParam';
import {
  ISlStateChangeListener,
  PerformanceMonitorUtil,
  SlMainStateType,
  SlSubStateType,
  slWallpaperMgr,
  CommonConstants,
  ClockStaticStateType,
  slUiStateMgr,
  ClockEditBindStateType,
  AccessibilityUtil,
  SlWidgetId
} from '@ohos/screenlockcommon';
import { EditBindStateType } from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { LimitMap } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import MultiSceneThemeManager from '../../common/theme/MultiSceneThemeManager';
import ScreenLockFormViewModel from '../../form/vm/ScreenLockFormViewModel';
import { slStateHelper } from '../../common/utils/SlStateHelper';
import { SlEditorBindState } from '../models/SlEditorBindState';
import { slEditorHelper } from '../utils/EditSheetHelper';
import AnimationUtil from '../utils/AnimationUtil';
import { ClockAdapterFactory } from '../../clock/adapter/ClockAdapter';
import { UseScene } from '../../common/adapter/Constans';
import { MainColor } from '../models/MainColor';
import { ClockInputEventType, UpdateClockParamEvent } from '../../common/command/Event';
import {
  ArtLayoutBindStateType,
  DofWallpaperStaticStateType
} from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { IDofParam } from '@ohos/screenlockcommon/src/main/ets/wallpaper/ScreenLockWallpaperManager';
import { curves, performanceMonitor } from '@kit.ArkUI';
import { ObjectCopyUtil } from '@ohos/componenthelper';

const TAG = 'LayoutEditManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);
const editAnimCurves = curves.interpolatingSpring(0, 1, 228, 30);

/**
 * 样式切换美学推荐缓存匹配条件
 */
interface ArtSignLayoutCacheCondition {
  // 是否合体字
  isShowAsCompound: boolean;
  // 文本长度
  textLength: number;
  // 是否中文
  isChinese: boolean;
}

/**
 * 样式切换美学推荐缓存
 */
interface ArtLayoutCache {
  // 能使用缓存的条件
  condition: ArtSignLayoutCacheCondition;
  // 智慧美学推荐的颜色参数
  aestheticColorArgs: AestheticColorArgs;
  // 具体类型，可以是子类型
  detailLayout: ClockLayout;
  // 景深信息
  dofScenesInfo: Map<string, IDofParam>;
}

/**
 * 样式编辑管理器
 */
export class LayoutEditManager {
  private clockStyle?: AnyClock;
  private formViewModel?: ScreenLockFormViewModel;
  private clockLayout?: ClockLayout;
  private mainColor?: MainColor;
  private updateLayoutstartTime?: number;
  // 锁屏编辑UI绑定状态
  private slEditBindState: SlEditorBindState = slStateHelper.getEditorBindState();
  private initCount: number = 0;
  private artSignAestheticTaskId: number = 0;
  // 样式切换临时缓存
  private artLayoutCacheMap: LimitMap<ClockLayout, ArtLayoutCache> =
    new LimitMap<ClockLayout, ArtLayoutCache>(TAG, 10);
  private onClockStateChange: ISlStateChangeListener = {
    slMainStateType: SlMainStateType.SL_ART_LAYOUT_STATE,
  }
  // 艺术签名编辑面板是否打开中
  private isArtSignatureDialogOpen: boolean = false;

  /**
   * 监听卡片编辑界面退出 退出重新触发景深计算
   */
  private clockEditStateListener: ISlStateChangeListener = {
    slMainStateType: SlMainStateType.SL_CLOCK_EDIT_BIND_STATE,
    onSlStateChange: (mainType: SlMainStateType, subType?: SlSubStateType): void => {
      if (subType === ClockEditBindStateType.IS_SHOW_FORM_BIND_SHEET && this.clockStyle) {
        // 是否显示卡片编辑页面
        let slStateMgr = ClockAdapterFactory.wrapper(UseScene.MAIN_PAGE).getClockEditStateManger();
        let slClockEditState = slStateMgr.getSlState(SlMainStateType.SL_CLOCK_EDIT_BIND_STATE);
        let isShowFrom = slClockEditState?.getSlState(ClockEditBindStateType.IS_SHOW_FORM_BIND_SHEET);
        log.showInfo(`clockEditStateListener isShowFrom:${isShowFrom} layout:${this.clockStyle?.layout}`);
        if (!isShowFrom) {
          if (REVERSE_LAYOUT.has(this.clockStyle?.layout)) {
            this.clockStyle.layout -= CLOCK_LAYOUT_REVERSE_CONSTANT;
            this.updateLayout(this.clockStyle.layout, true);
          }
        }
      }
    }
  };

  public init(): void {
    this.initCount++;
    if (this.initCount > 1) {
      return;
    }
    ClockAdapterFactory.wrapper(UseScene.MAIN_PAGE).getClockEditStateManger()
      .registerSlStateChangeListener(this.clockEditStateListener);
    ClockAdapterFactory.wrapper(UseScene.MAIN_PAGE).getClockEditStateManger()
      .registerSlStateChangeListener(this.onClockStateChange);
  }

  public destroy(): void {
    this.initCount--;
    if (this.initCount > 0) {
      return;
    }
    ClockAdapterFactory.wrapper(UseScene.MAIN_PAGE).getClockEditStateManger()
      .unregisterSlStateChangeListener(this.clockEditStateListener);
    ClockAdapterFactory.wrapper(UseScene.MAIN_PAGE).getClockEditStateManger()
      .unregisterSlStateChangeListener(this.onClockStateChange);
  }

  /**
   * 清空样式缓存
   */
  public clearEditCache() {
    this.artLayoutCacheMap.clear();
  }

  public setClockStyleObject(clockStyle: AnyClock): void {
    if (this.clockStyle !== clockStyle) {
      this.clockStyle = clockStyle;
    }
  }

  public setFormViewModel(formViewModel: ScreenLockFormViewModel): void {
    if (formViewModel !== this.formViewModel) {
      this.formViewModel = formViewModel;
    }
  }

  public setMainColor(mainColor: MainColor): void {
    if (mainColor !== this.mainColor) {
      this.mainColor = mainColor;
    }
  }

  /**
   * 选择字体
   * @param id 字体ID
   */
  setFontFamily(id: string): void {
    if (this.clockStyle) {
      this.clockStyle.clockFontFamily = id;
    }
  }

  /**
   * 刷新当前选中时钟样式
   *
   * @param clockLayout 时钟样式
   */
  public setSelectLayout(clockLayout: ClockLayout): void {
    if (this.clockLayout !== clockLayout) {
      this.clockLayout = clockLayout;
    }
  }

  /**
   * 更新时钟样式
   *
   * @param layout 新的时钟样式
   * @param isForReverse 时钟倒置这些已经计算过景深不需要重复计算
   */
  public updateLayout(layout: ClockLayout, isForReverse: boolean = false): void {
    if (layout === this.clockLayout) {
      return;
    }

    this.updateLayoutstartTime = Date.now();
    log.showInfo(`Layout change from ${this.clockLayout} to ${layout}`);
    let preLayout: ClockLayout | undefined = this.clockLayout;
    this.setSelectLayout(layout);

    // 非艺术签名样式切换无需构图动画
    if (layout < 200) {

      // 恢复阴影
      ClockAdapterFactory.wrapper(UseScene.MAIN_PAGE).setClockShadowUsing(true);

      if (isForReverse) {
        this.updateClockLayout(layout, this.clockStyle?.clockFontFamily);
      } else {
        this.updateClockLayout(layout, clockWidgetConfigManager.getClockDefaultFontFamily(layout));
      }
      return;
    }

    // 去除阴影
    ClockAdapterFactory.wrapper(UseScene.MAIN_PAGE).setClockShadowUsing(false);

    // 全推荐，时钟样式+位置+赋色
    let isAestheticAllEnable = slStateHelper.getEditorBindState()?.isAestheticAllEnable();
    if (isAestheticAllEnable) {



      // 生成美学推荐任务id
      this.artSignAestheticTaskId++;
      this.animateToHidePanel(true);

    } else {
      // 仅赋色推荐，提前切换时钟样式
      this.updateAestheticColor();
    }
  }

  /**
   * 美学赋色推荐
   */
  public updateAestheticColor(): void {
    // 非艺术签名类型样式，无需赋色推荐
  }

  /**
   * 更新时钟智慧美学颜色参数
   *
   * @param args 新的智慧美学颜色参数
   */
  private updateAestheticColorArgs(args: AestheticColorArgs): void {
    const selectedIndex = slUiStateMgr.getSlState(SlMainStateType.SL_EDIT_BIND_STATE)?.getSlState(
      EditBindStateType.SELECTED_COLOR_INDEX) as number;
    log.showInfo(`selectedIndex: ${selectedIndex}`);
    // 颜色选择的是第一个，才使用美学推荐的。否则使用选择的颜色。
    if (selectedIndex === 0) {
      if (this.clockStyle?.clockStrokeColor && args && args.needColor.length === '#FFFFFFFF'.length) {
        let strokeColor = args.needColor[0] + args.needColor.substring(3);
        this.clockStyle.clockStrokeColor = strokeColor;
        this.clockStyle.isClockTextBlurEffectEnabled = !args.isPosterShadow;
        this.clockStyle.isPosterShadow = args.isPosterShadow;
        log.showWarn(`update new color is ${strokeColor}`);
      }
    }

    if (this.clockStyle?.aestheticColorArgs) {
      this.clockStyle.aestheticColorArgs = args;
    }

    // 根据美学推荐的壁纸亮度和颜色，计算颜色面板第二款样式是黑色还是白色
    // ColorType.LIGHT 表示纯白 ColorType.DARK 表示纯黑
    if (this.mainColor) {
      this.mainColor.colorType = ClockColorUtil.getColorType(this.clockStyle?.aestheticColorArgs?.brightness);
    }

    log.showWarn(`update new brightness is ${args.brightness}`);
    // 更新壁纸亮度
    ClockAdapterFactory.wrapper(UseScene.MAIN_PAGE).getClockWidgetModel()
      .updateClockBrightnessOption(args.brightness < CommonConstants.BRIGHT_NESS_DEFAULT);
    slUiStateMgr.getSlState(SlMainStateType.SL_CLOCK_WG_STATIC_STATE)?.setSlState(ClockStaticStateType.BRIGHTNESS,
      args.brightness);
  }

  /**
   * 更新布局参数
   */
  public updateClockParam(): void {
    let event = new UpdateClockParamEvent(ClockInputEventType.UPDATE_CLOCK_PARAM_EVENT, TAG);
    ClockAdapterFactory.wrapper(UseScene.MAIN_PAGE).getInvoker().onEvent(event);
    log.showInfo('trigger the to update clock param');
  }



  /**
   * 数字时钟样式全推荐
   */
  public async loadClockAllLayout(): Promise<boolean> {
    // 生成美学推荐任务id
    this.artSignAestheticTaskId++;
    // 开启点阵动效
    this.animateToHidePanel(true);

    this.animateToShowButton(true);
    return true;
  }


  private updateClockLayout(clockLayout: ClockLayout, fontId?: string, pos?: GridAmount): void {
    if (!this.clockStyle) {
      log.showWarn(`updateClockLayout invalid clockStyle:${this.clockStyle}`);
      return;
    }
    let newFontId: string | undefined = fontId;
      if (!newFontId) {
        newFontId = clockWidgetConfigManager.getClockDefaultFontFamily(clockLayout);
      }
      this.setFontFamily(newFontId);
    // 存在推荐位置，则使用推荐位置
    let formHeight = this.formViewModel?.getReloadFormHeight(clockLayout) ?? 0;
    let formPanelHeight = this.formViewModel?.getCurrentPanelHeight() ?? 0;
    let clockAmount = this.slEditBindState?.getClockAmount();
    if (pos) {
      if (this.clockStyle) {
        this.clockStyle.x = pos.x;
        this.clockStyle.y = pos.y;
      }
      // 数字时钟考虑卡片影响
      clockLayoutHelper.updateClockObjectY(clockLayout, this.clockStyle, clockAmount?.y, formHeight, formPanelHeight);
    } else {
      // 无推荐位置，使用默认位置
      clockLayoutHelper.updateClockPosition(clockLayout, this.clockStyle, clockAmount, formHeight, formPanelHeight);
    }
    log.showInfo(`updateClockLayout clockLayout is ${clockLayout}, ${this.clockStyle?.x}, ${pos?.x}`);
    MultiSceneThemeManager.updateMultiSceneClockPosition(
      clockLayout, MultiSceneThemeManager.getCurrentThemeQualifier());

    AnimationUtil.createAnimateTo(editAnimCurves, 0, 200, () => {
      if (this.clockStyle) {
        this.clockStyle.layout = clockLayout;
      }
    }, {
      onAnimationStart: () => {
        performanceMonitor.begin('ON_CLOCK_LAYOUT_CHANGE', performanceMonitor.ActionType.LAST_UP);
      },
      onAnimationEnd: () => {
        performanceMonitor.end('ON_CLOCK_LAYOUT_CHANGE');
      },
    })

    PerformanceMonitorUtil.reportLockscreenEditStatus(PerformanceMonitorUtil.LAYOUT, clockLayout.toString());
  }

  private isValidChangeTask(taskId: number): boolean {
    return taskId === this.artSignAestheticTaskId;
  }



  private updateLayoutDetail(detailLayout: ClockLayout | undefined) {
    if (detailLayout == undefined) {
      log.showError('Detail layout is undefined.');
      return;
    }
    ClockAdapterFactory.wrapper(UseScene.MAIN_PAGE)
      .setMirrorLayoutUsing(false);
  }

  private animateToHidePanel(isNeedRipple: boolean) {
    AnimationUtil.createAnimateTo(editAnimCurves, 0, 200, () => {
      // 设置编辑面板缩放比例
      this.slEditBindState.setLayoutScale(0.8);
      // 隐藏应用按钮
      this.slEditBindState.setButtonAlpha(0);
      if (isNeedRipple) {
        // 开启点阵动效
      }
    });
  }

  private animateToShowButton(isNeedRipple: boolean) {
    AnimationUtil.createAnimateTo(editAnimCurves, 0, 200, () => {
      if (isNeedRipple) {
        // 停止点阵动效
      }
      // 显示应用按钮
      this.slEditBindState.setButtonAlpha(1);
      // 设置编辑面板缩放比例
      this.slEditBindState.setLayoutScale(1);
    });
  }





}