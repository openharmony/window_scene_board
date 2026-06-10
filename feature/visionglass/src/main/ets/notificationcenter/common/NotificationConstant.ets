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
 * 消息通知常量类
 */
export default class NotificationConstant {
  /**
   * 空字符串
   */
  public static readonly EMPTY_STRING: string = '';
  /**
   * 消息名称最大行数
   */
  public static readonly TITLE_MAX_LINE: number = 1;
  /**
   * 消息内容最大行数
   */
  public static readonly EXPAND_CONTENT_MAX_LINE: number = 3;
  /*
   * 折叠消息最大行数
   * */
  public static readonly COLLAPSE_CONTEXT_MAX_LINE: number = 1;
  /**
   * 组件间的空隙
   */
  public static readonly SPACE_20: string = '20.67px';
  public static readonly SPACE_8: string = '8px';
  public static readonly SPACE_12: string = '6px';
  public static readonly SPACE_24: string = '24px';
  public static readonly SPACE_87: string = '87px';
  /**
   * 按钮尺寸
   */
  public static readonly BUTTON_SIZE_80: string = '80px';
  /**
   * 边框圆角
   */
  public static readonly BORDERRADIUS_100: string = '100px';
  public static readonly BORDERRADIUS_32: string = '32px';
  public static readonly BORDERRADIUS_0: string = '0px';
  /**
   * 标题组件尺寸
   */
  public static readonly TITLE_SIZE_200: string = '200px';
  public static readonly TITLE_SIZE_33: string = '33px';
  public static readonly TITLE_SIZE_28: string = '28px';
  /**
   * 内容组件尺寸
   */
  public static readonly NOTIFICATIONCONTENT_SIZE_946: string = '946px';
  public static readonly NOTIFICATIONCONTENT_SIZE_33: string = '33px';
  public static readonly NOTIFICATIONCONTENT_SIZE_888: string = '888px';
  public static readonly NOTIFICATIONCONTENT_SIZE_550: string = '550px';
  /**
   * 时间组件尺寸
   */
  public static readonly TIME_SIZE_28: string = '28px';
  public static readonly TIME_SIZE_72: string = '72px';
  /**
   * 组件尺寸
   */
  public static readonly NFT_WIDTH_946: string = '946px';
  public static readonly NTF_WIDTH_988: string = '988px'
  public static readonly NTF_HEIGHT_122: string = '122px';
  public static readonly NTF_PADDING_24: string = '24px';
  public static readonly NTF_MARGIN_3: string = '3px';
  public static readonly NTF_MARGIN_15: string = '15.44px';
  public static readonly NTF_MARGIN_9: string = '9px';
  public static readonly NTF_MARGIN_688: string = '688px';
  public static readonly NTF_MARGIN_47: string = '47px';
  public static readonly NTF_HEIGHT_576: string = '576px';
  public static readonly NTF_HEIGHT_820: string = '820px';
  public static readonly NTF_MARGIN_164: string = '164px';
  public static readonly NTF_WIDTH_942: string = '942px';
  // 电话包名
  public static readonly PHONE_BUNDLE_NAME: string = 'com.ohos.callui';
  // 短信包名
  public static readonly MESSAGE_BUNDLE_NAME: string = 'com.ohos.mms';
  // 来电时显示的按钮数
  public static readonly CALL_BUTTON_NUMBER: number = 2;
  // 接通中显示的按钮数
  public static readonly CALLING_BUTTON_NUMBER: number = 3;
  //联系人包名 用于通话横幅判断是否打开的查找包
  public static readonly CONTACT_BUNDLE_NAME: string = 'com.ohos.contacts';
  public static readonly SINGLE_ITEM_WIDTH: string = '1128px';
  public static readonly NTF_VERTICAL_SPACE: string = '16px'
}

/**
 * 消息接收类型
 */
export enum NotificationReceiveType {
  /**
   * 新增消息
   */
  ADD = 1,

  /**
   * 更新消息
   */
  UPDATE = 2,

  /**
   * 眼镜侧下发删除消息
   */
  CANCEL = 3,

  /**
   * 手机侧下发删除消息
   */
  DELETE = 4
}