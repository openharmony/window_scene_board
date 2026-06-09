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
import notificationSubscribe from '@ohos.notificationSubscribe';
import { systemSoundManager } from '@kit.AudioKit';
import {
  NtfReminderConfig,
  NotificationCreatorType,
  NotificationAction,
  SysTypeCode,
  OverlayIconStyle,
} from '@ohos/systemuicommon';
import { NtfControlConfig } from '@ohos/systemuicommon/src/main/ets/model/NtfControlFlags';
import { NotificationBase, NotificationUtil } from '@ohos/systemuicommon/newTsIndex';
import { describe, beforeEach, afterEach, it, MockKit, when } from '@ohos/hypium';
import { NotificationBaseParser } from '../../../../main/ets/parser/NotificationBaseParser';

export default function NotificationBaseParserTest() {
  describe('parseData_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_call_all_parse_methods_and_updateKey_when_parseData_is_called', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockParseBasicInfo: Function = mocker.mockFunc(NotificationBaseParser.prototype, 'parseBasicInfo');
      let mockParseCreatorInfo: Function = mocker.mockFunc(NotificationBaseParser.prototype, 'parseCreatorInfo');
      let mockParseAppConfig: Function = mocker.mockFunc(NotificationBaseParser.prototype, 'parseAppConfig');
      let mockParseWantAgentInfo: Function = mocker.mockFunc(NotificationBaseParser.prototype, 'parseWantAgentInfo');
      let mockParseSmallIcon: Function = mocker.mockFunc(NotificationBaseParser.prototype, 'parseSmallIcon');
      let mockParseRemindInfo: Function = mocker.mockFunc(NotificationBaseParser.prototype, 'parseRemindInfo');
      let mockParseControlInfo: Function = mocker.mockFunc(NotificationBaseParser.prototype, 'parseControlInfo');
      let mockParseCustomAppName: Function = mocker.mockFunc(NotificationBaseParser.prototype, 'parseCustomAppName');
      let mockParseActionButtons: Function = mocker.mockFunc(NotificationBaseParser.prototype, 'parseActionButtons');
      let mockUpdateKey: Function = mocker.mockFunc(NotificationBase.prototype, 'updateKey');

      when(mockParseBasicInfo)().afterReturn(undefined);
      when(mockParseCreatorInfo)().afterReturn(undefined);
      when(mockParseAppConfig)().afterReturn(undefined);
      when(mockParseWantAgentInfo)().afterReturn(undefined);
      when(mockParseSmallIcon)().afterReturn(undefined);
      when(mockParseRemindInfo)().afterReturn(undefined);
      when(mockParseControlInfo)().afterReturn(undefined);
      when(mockParseCustomAppName)().afterReturn(undefined);
      when(mockParseActionButtons)().afterReturn(undefined);
      when(mockUpdateKey)().afterReturn(undefined);

      let subscribeCallbackData: notificationSubscribe.SubscribeCallbackData = {
        request: {
          bundleName: 'com.example.app',
          hashCode: 123,
          creatorBundleName: 'com.example.app',
          label: 'test',
          settings: {
            sound: {
              sysSoundType: SysTypeCode.DEFAULT,
              sysSoundUsage: systemSoundManager.SystemSoundUsage.NOTIFICATION,
              customSoundPath: 'path/to/sound',
              soundUsage: systemSoundManager.SystemSoundUsage.NOTIFICATION,
              loop: 1,
              volume: 100,
              duration: 1000,
              settings: {
                sysSoundType: SysTypeCode.DEFAULT,
                sysSoundUsage: systemSoundManager.SystemSoundUsage.NOTIFICATION,
                customSoundPath: 'path/to/sound',
                soundUsage: systemSoundManager.SystemSoundUsage.NOTIFICATION,
                loop: 1,
                volume: 100,
                duration: 1000,
              }
            },
            vibration: {
              usage: systemSoundManager.SystemSoundUsage.NOTIFICATION,
              duration: 1000,
              settings: {
                usage: systemSoundManager.SystemSoundUsage.NOTIFICATION,
                duration: 1000,
              }
            },
            light: {
              usage: systemSoundManager.SystemSoundUsage.NOTIFICATION,
              color: '#FFFFFF',
              settings: {
                usage: systemSoundManager.SystemSoundUsage.NOTIFICATION,
                color: '#FFFFFF',
              }
            },
            led: {
              usage: systemSoundManager.SystemSoundUsage.NOTIFICATION,
              color: '#FFFFFF',
              settings: {
                usage: systemSoundManager.SystemSoundUsage.NOTIFICATION,
                color: '#FFFFFF',
              }
            },
            carousel: {
              usage: systemSoundManager.SystemSoundUsage.NOTIFICATION,
              loop: 1,
              settings: {
                usage: systemSoundManager.SystemSoundUsage.NOTIFICATION,
                loop: 1,
              }
            },
            defaults: {
              light: {
                usage: systemSoundManager.SystemSoundUsage.NOTIFICATION,
                color: '#FFFFFF',
              },
              vibration: {
                usage: systemSoundManager.SystemSoundUsage.NOTIFICATION,
                duration: 1000,
              },
              carousel: {
                usage: systemSoundManager.SystemSoundUsage.NOTIFICATION,
                loop: 1,
              },
              led: {
                usage: systemSoundManager.SystemSoundUsage.NOTIFICATION,
                color: '#FFFFFF',
              },
              sound: {
                usage: systemSoundManager.SystemSoundUsage.NOTIFICATION,
                customSoundPath: 'path/to/sound',
                soundUsage: systemSoundManager.SystemSoundUsage.NOTIFICATION,
                loop: 1,
                volume: 100,
                duration: 1000,
              },
              wrist: {
                usage: systemSoundManager.SystemSoundUsage.NOTIFICATION,
                vibratorUsage: systemSoundManager.SystemSoundUsage.NOTIFICATION,
                ledUsage: systemSoundManager.SystemSoundUsage.NOTIFICATION,
                carouselUsage: systemSoundManager.SystemSoundUsage.NOTIFICATION,
                loop: 1,
                volume: 100,
                duration: 1000,
              }
            },
            reminders: [
              {
                reminderId: 1,
                sortIndex: 1,
                reminderType: 'timer',
                reminderTime: 1000,
                reminderDays: [1, 2, 3],
                vibrate: {
                  usage: systemSoundManager.SystemSoundUsage.NOTIFICATION,
                  duration: 1000,
                },
                light: {
                  usage: systemSoundManager.SystemSoundUsage.NOTIFICATION,
                  color: '#FFFFFF',
                },
                led: {
                  usage: systemSoundManager.SystemSoundUsage.NOTIFICATION,
                  color: '#FFFFFF',
                },
                carousel: {
                  usage: systemSoundManager.SystemSoundUsage.NOTIFICATION,
                  loop: 1,
                }
              } as NtfReminderConfig,
            ],
            controls: [
              {
                controlId: 1,
                sortIndex: 1,
                action: NotificationAction.ARCHIVE,
              } as NtfControlConfig,
            ],
            actionButtons: [
              {
                action: NotificationAction.ARCHIVE,
                label: 'Archive',
                settings: {
                  sound: {
                    sysSoundType: SysTypeCode.DEFAULT,
                    sysSoundUsage: systemSoundManager.SystemSoundUsage.NOTIFICATION,
                    customSoundPath: 'path/to/sound',
                    soundUsage: systemSoundManager.SystemSoundUsage.NOTIFICATION,
                    loop: 1,
                    volume: 100,
                    duration: 1000,
                  },
                  vibration: {
                    usage: systemSoundManager.SystemSoundUsage.NOTIFICATION,
                    duration: 1000,
                  },
                  light: {
                    usage: systemSoundManager.SystemSoundUsage.NOTIFICATION,
                    color: '#FFFFFF',
                  },
                  led: {
                    usage: systemSoundManager.SystemSoundUsage.NOTIFICATION,
                    color: '#FFFFFF',
                  },
                  carousel: {
                    usage: systemSoundManager.SystemSoundUsage.NOTIFICATION,
                    loop: 1,
                  },
                },
              } as NotificationAction,
            ],
            creatorType: NotificationCreatorType.SERVICE,
            overlayIcon: {
              style: OverlayIconStyle.NOTIFICATION,
              resource: 'path/to/icon',
            },
          },
        },
        sortingMap: {
          sortings: {
            123: {
              slot: 1,
            }
          }
        },
      };

      let ntf: NotificationUtil = new NotificationUtil();
      let parser: NotificationBaseParser = new NotificationBaseParser(subscribeCallbackData, ntf);

      await parser.parseData();
    });

    it('should_call_all_parse_methods_and_updateKey_when_parseData_is_called01', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockParseBasicInfo: Function = mocker.mockFunc(NotificationBaseParser.prototype, 'parseBasicInfo');
      let mockParseCreatorInfo: Function = mocker.mockFunc(NotificationBaseParser.prototype, 'parseCreatorInfo');
      let mockParseAppConfig: Function = mocker.mockFunc(NotificationBaseParser.prototype, 'parseAppConfig');
      let mockParseWantAgentInfo: Function = mocker.mockFunc(NotificationBaseParser.prototype, 'parseWantAgentInfo');
      let mockParseSmallIcon: Function = mocker.mockFunc(NotificationBaseParser.prototype, 'parseSmallIcon');
      let mockParseRemindInfo: Function = mocker.mockFunc(NotificationBaseParser.prototype, 'parseRemindInfo');
      let mockParseControlInfo: Function = mocker.mockFunc(NotificationBaseParser.prototype, 'parseControlInfo');
      let mockParseCustomAppName: Function = mocker.mockFunc(NotificationBaseParser.prototype, 'parseCustomAppName');
      let mockParseActionButtons: Function = mocker.mockFunc(NotificationBaseParser.prototype, 'parseActionButtons');
      let mockUpdateKey: Function = mocker.mockFunc(NotificationBase.prototype, 'updateKey');

      when(mockParseBasicInfo)().afterReturn(undefined);
      when(mockParseCreatorInfo)().afterReturn(undefined);
      when(mockParseAppConfig)().afterReturn(undefined);
      when(mockParseWantAgentInfo)().afterReturn(undefined);
      when(mockParseSmallIcon)().afterReturn(undefined);
      when(mockParseRemindInfo)().afterReturn(undefined);
      when(mockParseControlInfo)().afterReturn(undefined);
      when(mockParseCustomAppName)().afterReturn(undefined);
      when(mockParseActionButtons)().afterReturn(undefined);
      when(mockUpdateKey)().afterReturn(undefined);

      let subscribeCallbackData: notificationSubscribe.SubscribeCallbackData = {
        request: {
          bundleName: 'com.example.app',
          hashCode: 123,
          creatorBundleName: 'com.example.app',
          label: 'test',
          settings: {
            sound: {
              sysSoundType: SysTypeCode.DEFAULT,
              sysSoundUsage: systemSoundManager.SystemSoundUsage.NOTIFICATION,
              customSoundPath: 'path/to/sound',
              soundUsage: systemSoundManager.SystemSoundUsage.NOTIFICATION,
              loop: 1,
              volume: 100,
              duration: 1000,
              settings: {
                sysSoundType: SysTypeCode.DEFAULT,
                sysSoundUsage: systemSoundManager.SystemSoundUsage.NOTIFICATION,
                customSoundPath: 'path/to/sound',
                soundUsage: systemSoundManager.SystemSoundUsage.NOTIFICATION,
                loop: 1,
                volume: 100,
                duration: 1000,
              }
            },
            vibration: {
              usage: systemSoundManager.SystemSoundUsage.NOTIFICATION,
              duration: 1000,
              settings: {
                usage: systemSoundManager.SystemSoundUsage.NOTIFICATION,
                duration: 1000,
              }
            },
            light: {
              usage: systemSoundManager.SystemSoundUsage.NOTIFICATION,
              color: '#FFFFFF',
              settings: {
                usage: systemSoundManager.SystemSoundUsage.NOTIFICATION,
                color: '#FFFFFF',
              }
            },
            led: {
              usage: systemSoundManager.SystemSoundUsage.NOTIFICATION,
              color: '#FFFFFF',
              settings: {
                usage: systemSoundManager.SystemSoundUsage.NOTIFICATION,
                color: '#FFFFFF',
              }
            },
            carousel: {
              usage: systemSoundManager.SystemSoundUsage.NOTIFICATION,
              loop: 1,
              settings: {
                usage: systemSoundManager.SystemSoundUsage.NOTIFICATION,
                loop: 1,
              }
            },
            defaults: {
              light: {
                usage: systemSoundManager.SystemSoundUsage.NOTIFICATION,
                color: '#FFFFFF',
              },
              vibration: {
                usage: systemSoundManager.SystemSoundUsage.NOTIFICATION,
                duration: 1000,
              },
              carousel: {
                usage: systemSoundManager.SystemSoundUsage.NOTIFICATION,
                loop: 1,
              },
              led: {
                usage: systemSoundManager.SystemSoundUsage.NOTIFICATION,
                color: '#FFFFFF',
              },
              sound: {
                usage: systemSoundManager.SystemSoundUsage.NOTIFICATION,
                customSoundPath: 'path/to/sound',
                soundUsage: systemSoundManager.SystemSoundUsage.NOTIFICATION,
                loop: 1,
                volume: 100,
                duration: 1000,
              },
              wrist: {
                usage: systemSoundManager.SystemSoundUsage.NOTIFICATION,
                vibratorUsage: systemSoundManager.SystemSoundUsage.NOTIFICATION,
                ledUsage: systemSoundManager.SystemSoundUsage.NOTIFICATION,
                carouselUsage: systemSoundManager.SystemSoundUsage.NOTIFICATION,
                loop: 1,
                volume: 100,
                duration: 1000,
              }
            },
            reminders: [
              {
                reminderId: 1,
                sortIndex: 1,
                reminderType: 'timer',
                reminderTime: 1000,
                reminderDays: [1, 2, 3],
                vibrate: {
                  usage: systemSoundManager.SystemSoundUsage.NOTIFICATION,
                  duration: 1000,
                },
                light: {
                  usage: systemSoundManager.SystemSoundUsage.NOTIFICATION,
                  color: '#FFFFFF',
                },
                led: {
                  usage: systemSoundManager.SystemSoundUsage.NOTIFICATION,
                  color: '#FFFFFF',
                },
                carousel: {
                  usage: systemSoundManager.SystemSoundUsage.NOTIFICATION,
                  loop: 1,
                }
              } as NtfReminderConfig,
            ],
            controls: [
              {
                controlId: 1,
                sortIndex: 1,
                action: NotificationAction.ARCHIVE,
              } as NtfControlConfig,
            ],
            actionButtons: [
              {
                action: NotificationAction.ARCHIVE,
                label: 'Archive',
                settings: {
                  sound: {
                    sysSoundType: SysTypeCode.DEFAULT,
                    sysSoundUsage: systemSoundManager.SystemSoundUsage.NOTIFICATION,
                    customSoundPath: 'path/to/sound',
                    soundUsage: systemSoundManager.SystemSoundUsage.NOTIFICATION,
                    loop: 1,
                    volume: 100,
                    duration: 1000,
                  },
                  vibration: {
                    usage: systemSoundManager.SystemSoundUsage.NOTIFICATION,
                    duration: 1000,
                  },
                  light: {
                    usage: systemSoundManager.SystemSoundUsage.NOTIFICATION,
                    color: '#FFFFFF',
                  },
                  led: {
                    usage: systemSoundManager.SystemSoundUsage.NOTIFICATION,
                    color: '#FFFFFF',
                  },
                  carousel: {
                    usage: systemSoundManager.SystemSoundUsage.NOTIFICATION,
                    loop: 1,
                  },
                },
              } as NotificationAction,
            ],
            creatorType: NotificationCreatorType.SERVICE,
            overlayIcon: {
              style: OverlayIconStyle.NOTIFICATION,
              resource: 'path/to/icon',
            },
          },
        },
        sortingMap: {
          sortings: {
            123: {
              slot: 1,
            }
          }
        },
      };

      let ntf: NotificationUtil = new NotificationUtil();
      let parser: NotificationBaseParser = new NotificationBaseParser(subscribeCallbackData, ntf);

      await parser.parseData();
    });
  });
}

