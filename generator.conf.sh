#!/bin/sh

template_file=template.conf

read -p "Введите название страны (прим. RU, US): " country_name
read -p "Введите штат или провинцию (прим. NY, Moscow): " state_or_province_name
read -p "Введите город (прим. Moscow ): " locality_name
read -p "Введите доменное имя (прим. test.com): " domain
read -p "Введите электронную почту (прим. test@example.com): " email
read -p "Введите путь для сохранения файлов: " path_to_dir

new_file="$domain.conf"

mkdir -p "$path_to_dir/$domain"

cp $template_file $new_file

sed -i "s|{country_name}|$country_name|g" $new_file
sed -i "s|{state_or_province_name}|$state_or_province_name|g" $new_file
sed -i "s|{locality_name}|$locality_name|g" $new_file
sed -i "s|{name_organization}|${domain%.*}|g" $new_file
sed -i "s|{domain}|$domain|g" $new_file
sed -i "s|{email}|$email|g" $new_file

openssl req -config $new_file -new -sha256 -newkey rsa:2048 -nodes -keyout $domain.key -x509 -days 1825 -out $domain.cert

mv $domain.* "$path_to_dir/$domain/"

chmod -R 775 "$path_to_dir/$domain/"
