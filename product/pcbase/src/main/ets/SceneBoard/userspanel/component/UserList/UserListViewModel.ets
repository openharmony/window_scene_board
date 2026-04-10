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
import osAccount from '@ohos.account.osAccount';
import { UserAvatarUtils } from '../../common/UserAvatarUtils';
import { AvatarVM } from '../Avatar/Avatar';
import { UserButtonVM } from '../UserButton/UserButton';
import { UserTextStyle } from '../UserText/UserText';

interface IUserItemStyle {
  height?: Length;
  padding?: Padding | Length;
  margin?: Margin | Length;
}

/**
 * UserItem 样式类，用于传递和修改 UserItem 组件样式
 * @since 2024-07-25
 */
@Observed
export class UserItemStyle {
  public height?: Length = 72;
  public padding: Padding | Length = {
    left: 20,
    right: 20
  };
  public margin?: Margin | Length = 0;

  constructor(style?: IUserItemStyle) {
    this.height = style?.height || this.height;
    this.padding = style?.padding || this.padding;
    this.margin = style?.margin || this.margin;
  }
}

export interface IUserItemConfig {
  id?: string;
  style?: UserItemStyle;
  avatar?: AvatarVM;
  text?: ResourceStr;
  textStyle?: UserTextStyle;
  subText?: ResourceStr;
  subTextStyle?: UserTextStyle;
  button?: UserButtonVM;
  enableHoverEffect?: boolean;
  onHover?: (isHover: boolean, vm: UserItemVM) => void;
  onClick?: (vm: UserItemVM) => void;
}

/**
 * UserItem 组件的 ViewModel 类
 * @since 2024-07-25
 */
@Observed
export class UserItemVM {
  public account: osAccount.OsAccountInfo;
  public id: string | undefined;
  public style: UserItemStyle = new UserItemStyle();
  public avatar: AvatarVM;
  public text: ResourceStr;
  public textStyle: UserTextStyle = new UserTextStyle({
    size: $r('sys.float.Body_L'),
    weight: FontWeight.Medium,
    color: $r('sys.color.font_primary'),
    maxLines: 1,
  });
  public subText: ResourceStr;
  public subTextStyle: UserTextStyle = new UserTextStyle({
    size: $r('sys.float.Body_M'),
    weight: FontWeight.Regular,
    color: $r('sys.color.font_tertiary'),
    maxLines: 1,
  });
  public button: UserButtonVM | undefined;
  public enableHoverEffect: boolean;
  public onHover: ((isHover: boolean, vm: UserItemVM) => void) | undefined;
  public onClick: ((vm: UserItemVM) => void) | undefined;

  public static createUserItemVM(account: osAccount.OsAccountInfo, config?: IUserItemConfig): UserItemVM {
    const userItem: UserItemVM = new UserItemVM(account, config);
    return userItem;
  }

  constructor(account: osAccount.OsAccountInfo, config?: IUserItemConfig) {
    this.account = account;
    this.id = config?.id;
    this.style = config?.style || this.style;
    this.avatar = config?.avatar || this.getAvatar();
    this.text = config?.text || this.getText();
    this.textStyle.merge(config?.textStyle);
    this.subText = config?.subText || this.getSubText();
    this.subTextStyle.merge(config?.subTextStyle);
    this.button = config?.button;
    this.enableHoverEffect = config?.enableHoverEffect || true;
    this.onHover = config?.onHover;
    this.onClick = config?.onClick;
  }

  public clear(): void {
    this.button = undefined;
    this.onHover = () => {};
    this.onClick = () => {};
  }

  public isDomainUser(): boolean {
    return !!(this.account.domainInfo?.domain);
  }

  public getAvatar(): AvatarVM {
    const avatar: AvatarVM = new AvatarVM({
      src: UserAvatarUtils.getImgSrcFromPhoto(this.account.photo),
      imgSize: 48,
      badge: this.account.isLoggedIn,
    });
    return avatar;
  }

  public getText(): ResourceStr {
    const localName: string = this.account.localName;
    if (this.isDomainUser()) {
      return `${this.account.domainInfo.domain}/${localName}`;
    }
    return localName;
  }

  public getSubText(): ResourceStr {
    return '';
  }
}

export class UserItemModifier implements AttributeModifier<RowAttribute> {
  public isHover: boolean = false;

  applyNormalAttribute(instance: RowAttribute): void {
    if (this.isHover) {
      instance.backgroundColor($r('sys.color.interactive_hover'));
    } else {
      instance.backgroundColor(Color.Transparent);
    }
  }

  applyPressedAttribute(instance: RowAttribute): void {
    instance.backgroundColor($r('sys.color.interactive_pressed'));
  }
}