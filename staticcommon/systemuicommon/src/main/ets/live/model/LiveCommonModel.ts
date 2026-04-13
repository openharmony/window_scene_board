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

import type { image } from '@kit.ImageKit';
import type resourceManager from '@ohos.resourceManager';
import { LiveButtonState } from '../../liveview/common/LiveConstants';
import { SystemUICommonUtil } from '../../utils/SystemUICommonUtil';

/**
 * 辅助区显示类型
 */
export enum LiveExtensionType {
  /**
   * 不显示
   */
  DEFAULT = 0,

  /**
   * 显示普通文本
   */
  NORMAL_TEXT = 1,

  /**
   * 显示胶囊文本
   */
  CAPSULE_TEXT = 2,

  /**
   * 显示图片
   */
  PICTURE = 3,

  /**
   * 显示Icon
   */
  ICON = 4,
}

/**
 * 指示器类型
 */
export enum LiveIndicatorType {
  /**
   * 不显示指示器小图标
   */
  UNDISPLAYED = 0,
  /**
   * 显示在进度线上方
   */
  UP = 1,
  /**
   * 显示覆盖在进度线上。
   */
  OVERLAY = 2,
}

/**
 * 进度条线条类型
 */
export enum LiveLineType {
  /**
   * 虚线进度
   */
  DOTTED_LINE = 0,
  /**
   * 实线进度
   */
  NORMAL_SOLID_LINE = 1,
  /**
   * 粗实线进度
   */
  THICK_SOLID_LINE = 2,
}

/**
 * 实况胶囊类型
 */
export enum LiveCapsuleType {
  /**
   * 文本胶囊
   */
  TEXT = 1,
  /**
   * 计时器胶囊
   */
  TIMER = 2,
  /**
   * 进度胶囊
   */
  PROGRESS = 3,
  /**
   * 长时胶囊
   */
  PERSISTENT = 4,
  /**
   * 即时胶囊
   */
  INSTANT = 5,
}
/**
 * 胶囊状态
 */
export enum LiveCapsuleStatus {
  /**
   * 显示胶囊
   */
  SHOW = 1,
  /**
   * 不显示胶囊
   */
  HIDE = -1,
}

/**
 * 实况通知状态
 */
export enum LiveStatus {
  /**
   * 创建
   */
  CREATE = 0,
  /**
   * 增量更新
   */
  INCREMENTAL_UPDATE = 1,
  /**
   * 结束不显示
   */
  END = 2,
  /**
   * 全量更新
   */
  FULL_UPDATE = 3
}

/**
 * 胶囊提醒方式
 */
export enum LiveCapsuleRemindType {
  /**
   * 自动展开为横幅
   */
  EXPAND = 'EXPAND',

  /**
   * 胶囊强提醒更新
   */
  FLIP = 'FLIP',

  /**
   * 无特殊提醒方式
   */
  DEFAULT = 'DEFAULT',
}

let timerId = 0;

/**
 * 实况计时器数据
 */
export class LiveTimerModel {
  /**
   * 计时器唯一标识
   */
  uid: string;
  /**
   * 计时器初始值，单位ms
   */
  initialTime: number = 0;

  /**
   * ans接口中获取到的计时器初始值，单位ms。和接口查询到的值一致，不会进行修改。
   */
  requestInitialTime?: number;

  /**
   * 是否为倒计时
   */
  isCountdown: boolean = false;
  /**
   * 计时器是否暂停
   */
  isPaused: boolean = false;
  /**
   * 计时器时间是否更新
   */
  isUpdateTimer: boolean = true;
  /**
   * 自动更新预置标题
   */
  presetTitle?: string;
  /**
   * 自动更新预置内容
   */
  presetContent?: string;

  /**
   * 构造函数
   * @param key 计时器身份标识
   */
  constructor(key: string) {
    this.uid = `${key}_${timerId++}`;
  }
}

/**
 * 富文本
 */
export class LiveRichTextModel {
  /**
   * text字段字符串长度总和需小于1024
   */
  private static readonly MAX_LENGTH: number = 1024;

  /**
   * 富文本内容
   */
  text: string;

  /**
   * 富文本原颜色
   */
  textColor?: string;

  /**
   * 解析字符串的富文本
   * @param text
   * @returns
   */
  public static parse(text: string): LiveRichTextModel[] {
    if (!text) {
      return [];
    }
    const jsonArray = SystemUICommonUtil.safeParseJson<LiveRichTextModel[]>(text) ?? [];
    const richTextArr: LiveRichTextModel[] = [];
    let totalTextLen = 0;

    for (const data of jsonArray) {
      if (typeof data.text !== 'string') {
        continue;
      }

      let richText = new LiveRichTextModel();
      if (totalTextLen + data.text.length >= LiveRichTextModel.MAX_LENGTH) {
        richText.text = data.text.substring(0, LiveRichTextModel.MAX_LENGTH - totalTextLen);
        richText.textColor = data.textColor;
        richTextArr.push(richText);
        break;
      }
      richText.text = data.text;
      richText.textColor = data.textColor;
      richTextArr.push(richText);
      totalTextLen += (data.text as string)?.length;
    }

    return richTextArr;
  }
}

let buttonId = 0;

export class LiveButtonModel {
  /**
   * 按钮标题
   * 点击按钮时回调应用该标题
   */
  name: string = '';
  /**
   * 浅色模式按钮图标
   */
  lightIcon?: image.PixelMap;
  /**
   * 深色模式按钮图标
   */
  darkIcon?: image.PixelMap;
  /**
   * 图标资源，用于深浅色模式切换时替换icon
   */
  iconResource?: resourceManager.Resource;
  /**
   * 无障碍文本
   */
  accessibilityText?: string;
  /**
   * 按钮开关状态
   */
  onOffState?: LiveButtonState;
  /**
   * 额外信息中的图标
   */
  text?: string;
  /**
   * 点击后是否隐藏面板
   */
  hidePanel?: boolean;
  /**
   * 按钮ID
   */
  buttonId: number = buttonId++;
}

export class LiveProgressModel {
  /**
   * 进度条最大进度值，默认为1
   */
  maxValue: number = 1;
  /**
   * 进度条当前进度值，默认为0
   */
  currentValue: number = 0;
  /**
   * 是否显示为百分比，默认否。
   */
  isPercentage: boolean = false;
  /**
   * 进度条颜色
   */
  color?: ResourceColor;
}

export class EventControl {
  /**
   * 锁屏沉浸态权益
   */
  lockScreen?: number;
  /**
   * 关联服务按钮权益
   */
  serviceButton?: number;
}

/**
 * 胶囊展示类型
 */
export enum CapsuleShowType {
  // 顶层
  TOP = 0,
  // 左孔
  LEFT_HOLE = 1,
  // 右孔
  RIGHT_HOLE = 2,
  // 圆饼
  ROUND_CAKE = 3,
  // 可伸缩圆饼
  RETRACTABLE_ROUND_CAKE = 4,
  // 挂孔
  HANGING_HOLE = 5,
  // 双端挂孔
  HANGING_HOLE_DOUBLE_ENDED = 6,
  // 阴影
  SHADOW = 7,
  // 自适应圆饼，宽度在最大最小范围之间时，能够按照内容自适应，如果小于最小则显示为圆饼
  SELF_ADAPTIVE_ROUND_CAKE = 8,
  // 不显示
  NONE = 9,
}
/**
 * 系统实况类型
 */
export enum LiveType {
  // 普通实况
  NORMAL = 0,
  // 即时类实况
  INSTANT = 1,
  // 即时横幅
  INSTANT_BANNER = 3,
}

/**
 * 实况卡片类型
 */
export enum LiveCardType {
  /**
   * 无扩展区类型
   */
  NO_LAYOUT = -1,

  /**
   * 系统卡片
   */
  TYPE_SYSTEM = 0,

  /**
   * 进度可视化类型
   */
  PROGRESS = 3,

  /**
   * 强调文本类型
   */
  PICK_UP = 4,

  /**
   * 左右文本类型
   */
  FLIGHT = 5,

  /**
   * 赛事比分类型
   */
  SCORE = 7,

  /**
   * 导航类型
   */
  NAVIGATION = 8,
}

/**
 * 状态栏动效场景
 */
export enum StatusBarChangeType {
  // 默认场景
  Default = 0,
  // 提醒场景
  Remind = 1,
}

/**
 * 融球动效场景
 */
export enum LiveMetaBallScene {
  /**
   * 桌面
   */
  DESKTOP = 'Desktop',
  /**
   * 实况列表
   */
  LIVE_PANEL = 'LivePanel',
  /**
   * 双中心
   */
  DROPDOWN = 'Dropdown',
  /**
   * 锁屏
   */
  SCREEN_LOCK = 'ScreenLock',
  /**
   * 提醒
   */
  REMIND = 'FusionRemind',
  /**
   * 沉浸式
   */
  IMMERSIVE = 'Immersive',
  /**
   * 横幅
   */
  HEADS_UP = 'HeadsUp',
  /**
   * 状态栏隐藏
   */
  STATUSBAR_HIDE = 'StatusbarHide',
}

/**
 * 胶囊布局场景
 */
export enum LiveCapsuleLayoutScene {
  /**
   * 胶囊出现隐藏引起的布局变化
   */
  SHOW_HIDE = 'ShowHide',
  /**
   * 胶囊内容更新
   */
  UPDATE = 'Update',
}

export class LiveCapsuleLayoutInfo {
  /**
   * 胶囊区域最左坐标
   */
  left: number = 0;

  /**
   * 胶囊区域最右坐标
   */
  right: number = 0;

  /**
   * 当前是否有胶囊显示
   */
  hasCapsuleShow: boolean = false;

  /**
   * 是否是长时或及时胶囊
   */
  isInstantOrPersistentShowing: boolean = false;
  /* 变化场景 */
  scene: LiveCapsuleLayoutScene = LiveCapsuleLayoutScene.SHOW_HIDE;
  /* 延迟时间 */
  delay: number = 0;

  needAnimation?: boolean;
}

/**
 * 胶囊图标动效类型
 */
export enum LiveCapsuleIconAnimationType {
  // 默认无动效
  Default = 0,
  // 切换动效
  Animate = 1,
}