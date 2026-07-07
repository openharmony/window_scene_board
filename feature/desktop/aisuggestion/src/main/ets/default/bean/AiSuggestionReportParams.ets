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

/**
 * 语音助手建议卡片服务点击、卡片刷新等事件上报
 *
 * @since 2023-12-24
 */

export class DeviceParams {
  // 包名
  public PNAMEID: string = '';

  // 应用版本
  public PVERSIONID: string = '';

  // 设备类型 0-手机 1-平板 2-折叠屏
  public DEVICETYPE?: number;

  // 屏幕旋转类型 0-竖屏 1-横屏
  public ROTATIONMODE?: number;

  //屏幕类型，1为其他屏（默认值），2为新形态小外屏
  public SCREEN_TYPE?: number;
}

export class AiSuggestionReportParams extends DeviceParams {
  // 应用模块名
  public MODULENAME?: string = '';

  // 卡片名称
  public FORMNAME?: string = '';

  // 卡片对应应用版本号
  public VERSIONCODE?: string = '';

  // 卡片来源
  public SOURCETYPE?: string = '';
}

export class RefreshReportParams extends AiSuggestionReportParams {
  // 卡片尺寸类型 spanX*spanY
  public CELLSIZE: string = '';

  // 卡片具体尺寸width*height
  public DPSIZE: string = '';

  // 请求刷新用时ms
  public REQUESTTIME: string = '';

  // 刷新显示用时ms
  public REFRESHTIME: string = '';

  // 本次刷新图标数量
  public ICONNUM: number = 0;

  // 本次刷新卡片数量
  public FORMNUM: number = 0;

  // 卡片json信息
  public FAINFO: string = '';

  // 卡片唯一标识
  public FORMID: string = '';
}

export class WeeklyStatusReportParams extends AiSuggestionReportParams {
  // 每周总刷新次数
  public REFRESHTIMES: number = 0;

  // 卡片尺寸类型 spanX*spanY
  public CELLSIZE: string = '';

  // 母卡所在屏幕页数
  public SCREENID: number = 0;

  // 母卡所在位置的X坐标
  public CELLX: number = 0;

  // 母卡所在位置的Y坐标
  public CELLY: number = 0;

  // 卡片唯一标识
  public FORMID: string = '';

  // 桌面添加语音助手建议卡片总数量
  public FANUM: number = 0;

  // 序列号，用于标识同一次上报的不同条目，采用时间戳作为标记
  public SERIALNUM: string = '';
}

export class ReportItem {
  // 卡片id
  public cardId: string = '';

  // 服务ID，其中btn_toggle代表是是切换键；
  public serviceId: string = '';

  // 推荐服务类型：0，应用；1：代表卡片； 2:代表场景卡切换键
  public itemType: number = 0;

  // 0：不支持PIN，1：未PIN；2：已PIN；
  public pinStatus: number = 0;

  // 是否是分身
  public uid: number = 0;

  // 装填位置起始行
  public rowStart: number = 0;

  // 装填位置起始列
  public columnStart: number = 0;

  // 子卡片占据的行数（高度）
  public rowSpan: number = 0;

  // 子卡片占据的列数（宽度）
  public columnSpan: number = 0;
}

export class IconClickReportParams extends AiSuggestionReportParams {
  // 应用包名
  public PACKAGENAME: string = '';

  // 卡片尺寸类型 spanX*spanY
  public CELLSIZE: string = '';

  // 母卡所在屏幕页数
  public CURRENTPAGE: number = 0;

  // 屏幕总页数
  public TOTALPAGE: number = 0;

  // 母卡所在位置的X坐标
  public CELLX: number = 0;

  // 母卡所在位置的Y坐标
  public CELLY: number = 0;

  // 是否为分身应用 true-是 false-不是
  public ISCLONEAPP: boolean = false;

  // 图标在母卡中的位置X坐标
  public POSITIONX: number = 0;

  // 图标在母卡中的位置Y坐标
  public POSITIONY: number = 0;

  // 卡片唯一标识
  public FORMID: string = '';
}

export class IconMenuReportParams extends AiSuggestionReportParams {
  // 应用包名
  public PACKAGENAME: string = '';

  // 卡片尺寸类型 spanX*spanY
  public CELLSIZE: string = '';

  // 母卡所在屏幕页数
  public CURRENTPAGE: number = 0;

  // 屏幕总页数
  public TOTALPAGE: number = 0;

  // 母卡所在位置的X坐标
  public CELLX: number = 0;

  // 母卡所在位置的Y坐标
  public CELLY: number = 0;

  // 是否为分身应用 true-是 false-不是
  public ISCLONEAPP: boolean = false;

  // 图标在母卡中的位置X坐标
  public POSITIONX: number = 0;

  // 图标在母卡中的位置Y坐标
  public POSITIONY: number = 0;

  // 菜单类型 0-没有点击 1-更多服务卡片 2-不感兴趣 3-设为常驻 4-取消常驻
  public MENUTYPE: number = 0;

  // 卡片唯一标识
  public FORMID: string = '';
}

export class FormDeleteReportParams extends AiSuggestionReportParams {
  // 应用包名
  public ABILITYFORM: string = '';

  // 卡片尺寸类型 spanX*spanY
  public SIZE: string = '';

  // 卡片的位置，格式为[screenId,cellx,celly]
  public POSITION: string = '';

  // 删除对话框按钮操作 0-移除 1-取消
  public RESULTTYPE: number = 0;

  // 卡片唯一标识
  public FORMID: string = '';

  //屏幕类型，1为其他屏（默认值），2为新形态小外屏
  public SCREEN_TYPE: number = 0;

  // 卡片类型，0-普通卡片 1-互动卡片-场景动效 2-互动卡片-趣味交互
  public FORMTYPE: number = 0;
}

export class FormClickReportParams extends AiSuggestionReportParams {
  // 应用包名
  public PACKAGENAME: string = '';

  // 卡片尺寸类型 spanX*spanY
  public CELLSIZE: string = '';

  // 卡片具体尺寸width*height
  public DPSIZE: string = '';

  // 母卡所在屏幕页数
  public CURRENTPAGE: number = 0;

  // 屏幕总页数
  public TOTALPAGE: number = 0;

  // 母卡所在位置的X坐标
  public CELLX: number = 0;

  // 母卡所在位置的Y坐标
  public CELLY: number = 0;

  // 卡片信息类型，0-普通卡片 1-语音助手母卡 2-语音助手子卡
  public INFOTYPE: number = 0;

  // 卡片唯一标识
  public FORMID: string = '';

  //屏幕类型，1为其他屏（默认值），2为新形态小外屏
  public SCREEN_TYPE: number = 0;
}

export class FormMenuReportParams extends AiSuggestionReportParams {
  // 应用包名
  public PACKAGENAME: string = '';

  // 卡片尺寸类型 spanX*spanY
  public CELLSIZE: string = '';

  // 卡片具体尺寸width*height
  public DPSIZE: string = '';

  // 卡片信息类型，0-普通卡片 1-语音助手母卡 2-语音助手子卡
  public INFOTYPE: number = 0;

  // 菜单类型 0-没有点击 1-更多服务卡片 2-移除(非二次确认框中的移除) 3-编辑 4-不感兴趣 5-设为常驻 6-取消常驻 7-不感兴趣此场景 8-移除二次弹框取消移除
  public MENUTYPE: number = 0;

  // 卡片唯一标识
  public FORMID: string = '';

  //屏幕类型，1为其他屏（默认值），2为新形态小外屏
  public SCREEN_TYPE: number = 0;

  // 卡片类型，0-普通卡片 1-互动卡片-场景动效 2-互动卡片-趣味交互
  public FORMTYPE: number = 0;
}