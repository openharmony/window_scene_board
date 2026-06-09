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
import { LogDomain, LogHelper } from './BasicCommon';
import { PageContext } from '../model/SystemUISettingSession';

const TAG = 'PageStorages';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

/**
 * 用于存储页面交互时的数据
 */
export class PageStorages {
  /**
   * 包装一个含页面上下文的Storage
   *
   * @param pageContext
   * @returns
   */
  public static wrapPageCtxStorage(pageContext: PageContext): LocalStorage {
    return new LocalStorage({ 'paras': pageContext } as Record<string, PageContext>);
  }

  /**
   * 获取页面上下文
   * @returns
   */
  public static getPageContext(): PageContext | undefined {
    return LocalStorage.getShared()?.get<PageContext>('paras');
  }

  /**
   * 发送数据到上下文
   */
  public static sendData = (data: Record<string, Object>): void => {
    const param = PageStorages.getPageContext();
    if (param && param.session) {
      try {
        param.session.sendData(data);
      } catch (err) {
        log.error('Send data error.', err);
      }
    } else {
      log.showWarn('Session is none');
    }
  }

  /**
   * 弹出当前上下文
   */
  public static popContext = (): void => {
    PageStorages.sendData({ 'action': 'pop' });
  }
}